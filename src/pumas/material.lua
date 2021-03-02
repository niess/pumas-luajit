-------------------------------------------------------------------------------
-- Materials for PUMAS
-- Author: Valentin Niess
-- License: GNU LGPL-3.0
-------------------------------------------------------------------------------
local element_ = require('pumas.element')
local error = require('pumas.error')
local metatype = require('pumas.metatype')

local material = {}


-------------------------------------------------------------------------------
-- Utility functions for computing stats over atomic element components
-------------------------------------------------------------------------------
function material.compute_ZoA (elements_, ELEMENTS, raise_error)
    ELEMENTS = ELEMENTS or element_.ELEMENTS
    local ZoA = 0
    for symbol, wi in pairs(elements_) do
        local e = ELEMENTS[symbol]
        if e == nil then
            local description = "unknown element '"..symbol.."'"
            if raise_error then
                raise_error{description = description}
            else
                error.raise{fname = 'compute_ZoA', argnum = 1,
                    description = description}
            end
        end
        local tmp = wi * e.Z / e.A
        ZoA = ZoA + tmp
    end

    return ZoA
end

function material.compute_ZoA_and_I (elements_, ELEMENTS, raise_error)
    ELEMENTS = ELEMENTS or element_.elements
    local ZoA, mee = 0, 0
    for symbol, wi in pairs(elements_) do
        local e = ELEMENTS[symbol]
        if e == nil then
            local description = "unknown element '"..symbol.."'"
            if raise_error then
                raise_error{description = description}
            else
                error.raise{fname = 'compute_ZoA_and_I', argnum = 1,
                    description = description}
            end
        end
        local tmp = wi * e.Z / e.A
        ZoA = ZoA + tmp
        mee = mee + tmp * math.log(e.I)
    end
    local I = math.exp(mee / ZoA) * 1.13 -- 13% rule, see Groom et al.

    return ZoA, I
end


-------------------------------------------------------------------------------
-- The Material metatype
-------------------------------------------------------------------------------
local Material = {__index = {}}

Material.__index.__metatype = 'Material'

local raise_error = error.ErrorFunction{fname = 'Material'}

do
    local function check_number (k, v, unit)
        if type(v) ~= 'number' then
            raise_error{argname = k, expected = 'a number',
                got = metatype.a(v)}
        elseif unit and (v <= 0) then
            v = v..' '..unit
            raise_error{argname = k, expected = 'a positive number', got = v}
        end
    end

    local function new (cls, args, ELEMENTS)
        if type(args) ~= 'table' then
            raise_error{
                argnum = 1,
                expected = 'a table',
                got = type(args)
            }
        end

        local formula, composition, density, state, I, a, k, x0, x1, Cbar,
            delta0
        for key, value in pairs(args) do
            if     key == 'formula' then formula = value
            elseif key == 'elements' then composition = value
            elseif key == 'density' then density = value
            elseif key == 'state' then state = value
            elseif key == 'I' then I = value
            elseif key == 'a' then a = value
            elseif key == 'k' then k = value
            elseif key == 'x0' then x0 = value
            elseif key == 'x1' then x1 = value
            elseif key == 'Cbar' then Cbar = value
            elseif key == 'delta0' then delta0 = value
            else
                raise_error{
                    argname = key,
                    description = 'unknown parameter'
                }
            end
        end

        check_number('density', density, 'kg / m^2')

        if delta0 then
            check_number('delta0', delta0)
        else
            delta0 = 0
        end

        if not ELEMENTS then
            ELEMENTS = element_.elements
        end

        local self = {}

        if formula then
            if type(formula) ~= 'string' then
                raise_error{argname = 'formula', expected = 'a string',
                    got = metatype.a(formula)}
            end

            -- Parse the chemical composition and compute the mass fractions
            self.formula = args.formula
            local compo, norm = {}, 0
            for symbol, count in formula:gmatch('(%u%l?)(%d*)') do
                count = tonumber(count) or 1
                local wi = count * ELEMENTS[symbol].A
                compo[symbol] = wi
                norm = norm + wi
            end
            norm = 1 / norm
            for _, value in ipairs(compo) do
                value[2] = value[2] * norm
            end
            self.elements = compo
        elseif composition then
            -- Use the provided composition
            if type(composition) ~= 'table' then
                raise_error{argname = 'composition', expected = 'a table',
                    got = metatype.a(composition)}
            end
            self.elements = composition -- XXX copy or not?
        else
            raise_error{description = "missing 'composition' or 'formula'"}
        end

        if I then
            check_number('I', I, 'GeV')
            self.I = I
            self.ZoA = material.compute_ZoA(
                self.elements, ELEMENTS, raise_error)
        else
            self.ZoA, self.I = material.compute_ZoA_and_I(
                self.elements, ELEMENTS, raise_error)
        end
        self.density = density

        if state then
            if type(state) ~= 'string' then
                raise_error{argname = 'state', expected = 'a string',
                    got = metatype.a(state)}
            end

            local tmp = state:lower()
            if (tmp ~= 'gas') and (tmp ~= 'liquid') and (tmp ~= 'solid') then
                raise_error{
                    argname = 'state', expected = "'solid', 'liquid' or 'gas'",
                    got = "'"..state.."'"
                }
            end
            state = tmp
        else
            if self.density < 0.1E+03
            then state = 'gas'
            else state = 'liquid'
            end
        end
        self.state = state

        -- Set the Sternheimer coefficients. If not provided the Sternheimer
        -- and Peierls recipe is used
        if k then
            check_number('k', k)
        else
            k = 3
        end
        self.k = k

        if Cbar then
            check_number('Cbar', Cbar)
        else
            local hwp = 28.816E-09 * math.sqrt(density * 1E-03 * self.ZoA)
            Cbar = 2 * math.log(self.I / hwp)
        end
        self.Cbar = Cbar

        if x0 then
            check_number('x0', x0)
        else
            if state == 'gas' then
                if     Cbar <= 10     then x0 = 1.6
                elseif Cbar <= 10.5   then x0 = 1.7
                elseif Cbar <= 11     then x0 = 1.8
                elseif Cbar <= 11.5   then x0 = 1.9
                elseif Cbar <= 13.804 then x0 = 2
                else                       x0 = 0.326 * Cbar - 1.5
                end
            elseif I <= 100 then
                if   Cbar <= 3.681
                then x0 = 0.2
                else x0 = 0.326 * Cbar - 1
                end
            else
                if   Cbar <= 5.215
                then x0 = 0.2
                else x0 = 0.326 * Cbar - 1.5
                end
            end
        end
        self.x0 = x0

        if x1 then
            check_number('x1', x1)
        else
            if state == 'gas' then
                if   Cbar < 13.804
                then x1 = 4
                else x1 = 5
                end
            elseif I <= 100 then
                x1 = 2
            else
                x1 = 3
            end
        end
        self.x1 = x1

        if a then
            check_number('a', a)
        else
            local dx = x1 - x0
            a = (Cbar - 2 * math.log(10) * x0) / (dx * dx * dx)
        end
        self.a = a

        self.delta0 = delta0

        return setmetatable(self, cls)
    end

    material.Material = setmetatable(Material, {__call = new})
end


-------------------------------------------------------------------------------
-- Build the Materials table
-------------------------------------------------------------------------------
material.materials = require('pumas.data.materials')
for k, v in pairs(material.materials) do
    material.materials[k] = setmetatable(v, material.Material)
end


-------------------------------------------------------------------------------
-- Register the subpackage
-------------------------------------------------------------------------------
function material.register_to (t)
    t.Material = material.Material
    t.materials = material.materials
end


-------------------------------------------------------------------------------
-- Return the package
-------------------------------------------------------------------------------
return material
