-------------------------------------------------------------------------------
-- Coordinates transformations for PUMAS
-- Author: Valentin Niess
-- License: GNU LGPL-3.0
-------------------------------------------------------------------------------
local ffi = require('ffi')
local error = require('pumas.error')
local metatype = require('pumas.metatype')

local transform = {}


-------------------------------------------------------------------------------
-- The transform metatype
-------------------------------------------------------------------------------
local UnitaryTransformation = {__index = {}}
UnitaryTransformation.__index.__metatype = 'UnitaryTransformation'


local raise_error = error.ErrorFunction{fname = 'from_euler'}

function UnitaryTransformation.__index:from_euler (axis,...)
    if (self == nil) or (axis == nil) then
        local nargs = (self ~= nil) and 1 or 0
        raise_error{
            argnum = 'bad',
            expected = '3 or more',
            got = nargs
        }
    end

    if type(axis) ~= 'string' then
        raise_error{
            argnum = 2,
            expected = 'a string',
            got = metatype.a(axis)
        }
    end

    local angles = {...}
    if #angles ~= #axis then
        raise_error{
            argnum = 'bad',
            expected = #axis + 2,
            got = #angles + 2
        }
    end

    if #axis == 1 then
        local c, s = math.cos(angles[1]), math.sin(angles[1])
        if (axis == 'x') or (axis == 'X') then
            self.matrix = {{  1,  0,  0},
                           {  0,  c,  s},
                           {  0, -s,  c}}
            return self
        elseif (axis == 'y') or (axis == 'Y') then
            self.matrix = {{  c,  0,  s},
                           {  0,  1,  0},
                           { -s,  0,  c}}
            return self
        elseif (axis == 'z') or (axis == 'Z') then
            self.matrix = {{  c,  s,  0},
                           { -s,  c,  0},
                           {  0,  0,  1}}
            return self
        end
    end

    -- XXX implement the general case in C
    raise_error('not implemented')
end


transform.UnitaryTransformation = ffi.metatype(
    'struct pumas_coordinates_unitary_transformation', UnitaryTransformation)

error.register('UnitaryTransformation', UnitaryTransformation)


function UnitaryTransformation.__index:clone ()
    return transform.UnitaryTransformation(self)
end


-------------------------------------------------------------------------------
-- Return the package
-------------------------------------------------------------------------------
return transform
