-------------------------------------------------------------------------------
-- Materials for PUMAS
-- Author: Valentin Niess
-- License: GNU LGPL-3.0
-------------------------------------------------------------------------------
local element_ = require('pumas.element')
local error = require('pumas.error')
local metatype = require('pumas.metatype')
local readonly = require('pumas.readonly')

local material = {}


-- XXX add a name attribute to materials?


-------------------------------------------------------------------------------
-- Utility functions for computing stats over atomic element components
-------------------------------------------------------------------------------
function material.compute_ZoA (elements_, ELEMENTS, raise_error)
    ELEMENTS = ELEMENTS or element_.ELEMENTS
    local ZoA = 0
    if getmetatable(elements_) == 'Readonly' then
        elements_ = readonly.rawget(elements_)
    end
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
    if getmetatable(elements_) == 'Readonly' then
        elements_ = readonly.rawget(elements_)
    end
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
        if args == nil then
            raise_error{
                argnum = 'bad', expected = '1', got = '0'}
        elseif type(args) ~= 'table' then
            raise_error{
                argnum = 1, expected = 'a table', got = metatype(args)}
        end

        local formula, composition, density, I
        for key, value in pairs(args) do
            if     key == 'formula' then formula = value
            elseif key == 'elements' then composition = value
            elseif key == 'density' then density = value
            elseif key == 'I' then I = value
            elseif key ~= 'ZoA' then
                raise_error{
                    argname = key,
                    description = 'unknown parameter'}
            end
        end

        check_number('density', density, 'kg / m^2')

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
            for symbol, v in pairs(compo) do
                compo[symbol] = v * norm
            end
            self.elements = compo
        elseif composition then
            -- Use the provided composition
            if type(composition) ~= 'table' then
                raise_error{argname = 'composition', expected = 'a table',
                    got = metatype.a(composition)}
            end
            local tmp = {}
            for key, v in pairs(composition) do tmp[key] = v end
            self.elements = tmp
        else
            raise_error{description = "missing 'composition' or 'formula'"}
        end

        if I then
            check_number('I', I, 'GeV')
            self.I = I
            self.ZoA = material.compute_ZoA(
                self.elements, ELEMENTS, raise_error)
        else
            self.ZoA, I = material.compute_ZoA_and_I(
                self.elements, ELEMENTS, raise_error)
            self.I = I
        end
        self.density = density

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
