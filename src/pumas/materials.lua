-------------------------------------------------------------------------------
-- Materials for PUMAS
-- Author: Valentin Niess
-- License: GNU LGPL-3.0
-------------------------------------------------------------------------------
local elements = require('pumas.elements')
local error = require('pumas.error')

local materials = {}


-------------------------------------------------------------------------------
-- The Material metatype
-------------------------------------------------------------------------------
local mt = {__index = {}}

mt.__index.__metatype = 'material'

local raise_error = error.ErrorFunction{fname = 'Material'}

function materials.Material (args)
    if type(args) ~= 'table' then
        raise_error{
            argnum = 1,
            expected = 'a table',
            got = type(args)
        }
    end

    local formula, composition, density, state, I, a, k, x0, x1, Cbar,
          delta0
    for k, v in pairs(args) do
        if     k == 'formula' then formula = v
        elseif k == 'composition' then composition = v
        elseif k == 'density' then density = v
        elseif k == 'state' then state = v
        elseif k == 'I' then I = v
        elseif k == 'a' then a = v
        elseif k == 'k' then k = v
        elseif k == 'x0' then x0 = v
        elseif k == 'x1' then x1 = v
        elseif k == 'Cbar' then Cbar = v
        elseif k == 'delta0' then delta0 = v
        else
            raise_error{
                argname = k,
                description = 'unknown parameter'
            }
        end
    end

    -- XXX check the type of other args
    if type(density) ~= 'number' then
        raise_error{
            argname = 'density',
            expected = 'a number',
            got = type(density)
        }
    end

    if delta0 == nil then delta0 = 0 end

    local self = {}

    if formula then
        -- Parse the chemical composition and compute the mass fractions
        self.formula = args.formula
        local composition, norm = {}, 0
        for symbol, count in formula:gmatch('(%u%l?)(%d*)') do
            count = tonumber(count) or 1
            local wi = count * elements.ELEMENTS[symbol].A
            table.insert(composition, {symbol, wi})
            norm = norm + wi
        end
        norm = 1 / norm
        for _, value in ipairs(composition) do
            local symbol, wi = unpack(value)
            value[2] = wi * norm
        end
        self.composition = composition
    elseif composition then
        -- Use the provided composition
        self.composition = composition
    else
        raise_error{description = "missing 'composition' or 'formula'"}
    end

    local ZoA, mee = 0, 0
    for _, value in ipairs(self.composition) do
        local symbol, wi = unpack(value)
        local e = elements.ELEMENTS[symbol]
        if e == nil then
            raise_error{description = "unknown element '"..symbol.."'"}
        end
        local tmp = wi * e.Z / e.A
        ZoA = ZoA + tmp
        mee = mee + tmp * math.log(e.I)
    end
    self.ZoA = ZoA
    if not I then
        I = math.exp(mee / ZoA) * 1.13 -- 13% rule, see Groom et al.
    end
    self.I = I
    self.density = density

    if state then
        local tmp = state:lower()
        if (tmp ~= 'gaz') and (tmp ~= 'liquid') and (tmp ~= 'solid') then
            raise_error{
                argname = 'state',
                expected = "'solid', 'liquid' or 'gaz'",
                got = "'"..state.."'"
            }
        end
        state = tmp
    else
        if self.density < 0.1E+03
        then state = 'gaz'
        else state = 'liquid'
        end
    end
    self.state = state

    -- Set the Sternheimer coefficients. If not provided the Sternheimer
    -- and Peierls recipe is used
    if k == nil then k = 3 end
    self.k = k

    if not Cbar then
        local hwp = 28.816E-09 * math.sqrt(density * 1E-03 * ZoA)
        Cbar = 2 * math.log(self.I / hwp)
    end
    self.Cbar = Cbar

    if not x0 then
        if state == 'gaz' then
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

    if not x1 then
        if state == 'gaz' then
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

    if not a then
        local dx = x1 - x0
        a = (Cbar - 2 * math.log(10) * x0) / (dx * dx * dx)
    end
    self.a = a

    self.delta0 = delta0

    return setmetatable(self, mt)
end


-------------------------------------------------------------------------------
-- Build the Materials table
-------------------------------------------------------------------------------
materials.MATERIALS = require('pumas.data.materials')
for k, v in pairs(materials.MATERIALS) do
    v.density = v.density * 1E+03 -- XXX use kg / m^3
    materials.MATERIALS[k] = materials.Material(v)
end


-------------------------------------------------------------------------------
-- Register the subpackage
-------------------------------------------------------------------------------
function materials.register_to (t)
    for k, v in pairs(materials) do
        t[k] = v
    end
end


-------------------------------------------------------------------------------
-- Return the package
-------------------------------------------------------------------------------
return materials