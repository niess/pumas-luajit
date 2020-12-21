-------------------------------------------------------------------------------
-- Uniform medium for PUMAS
-- Author: Valentin Niess
-- License: GNU LGPL-3.0
-------------------------------------------------------------------------------
local error = require('pumas.error')
local ffi = require('pumas.ffi')
local base = require('pumas.medium.base')
local metatype = require('pumas.metatype')

local gradient = {}


-------------------------------------------------------------------------------
-- The gradient medium metatype
-------------------------------------------------------------------------------
local GradientMedium = {}
local strtype = 'GradientMedium'


local parse_type
do
    local raise_error = error.ErrorFunction{
        fname = 'type',
        depth = 3
    }

    function parse_type (v)
        if type(v) ~= 'string' then
            raise_error{
                expected = 'a string',
                got = metatype.a(v)
            }
        end
        local tag = v:lower()
        if tag == 'linear' then
            return ffi.C.PUMAS_MEDIUM_GRADIENT_LINEAR
        elseif tag == 'exponential' then
            return ffi.C.PUMAS_MEDIUM_GRADIENT_EXPONENTIAL
        else
            raise_error{
                expected = "'linear' or 'exponential'",
                got = v
            }
        end
    end
end


function GradientMedium:__index (k)
    if k == 'type' then
        return rawget(self, '_type')
    elseif k == 'magnet' then
        return self._c.magnet
    else
        return base.BaseMedium.__index(self, k, strtype)
    end
end


function GradientMedium:__newindex (k, v)
    if k == 'type' then
        rawget(self, '_c').gradient.type = parse_type(v)
        rawset(self, '_type', v)
    elseif k == 'magnet' then
        self._c.magnet = v
    else
        base.BaseMedium.__newindex(self, k, v, strtype)
    end
end


-------------------------------------------------------------------------------
-- The gradient medium constructor
-------------------------------------------------------------------------------
local ctype = ffi.typeof('struct pumas_medium_gradient')
local ctype_ptr = ffi.typeof('struct pumas_medium_gradient *')

-- XXX Use keyword arguments instead
function gradient.GradientMedium (material, type_, axis, value, position0,
    density0, magnet)

    if density0 == nil then
        local args = {material, type_, axis, value, position0}
        error.raise{
            fname = strtype,
            argnum = 'bad',
            expected = '6 or more',
            got = #args
        }
    end

    local self, index = base.BaseMedium.new(ctype, ctype_ptr, material, strtype)
    type_ = parse_type(type_)

    ffi.C.pumas_medium_gradient_initialise(self._c, index, type_, value,
                                           position0, density0, magnet)
    if (type(axis) == 'string') and (axis:lower() == 'vertical') then
        self._c.gradient.project =
            ffi.C.pumas_medium_gradient_project_altitude
    else
        self._c.gradient.direction = axis
    end

    return setmetatable(self, GradientMedium)
end


-------------------------------------------------------------------------------
-- Return the package
-------------------------------------------------------------------------------
return gradient
