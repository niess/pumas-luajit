-------------------------------------------------------------------------------
-- Coordinates transformations for PUMAS
-- Author: Valentin Niess
-- License: GNU LGPL-3.0
-------------------------------------------------------------------------------
local ffi = require('ffi')
local clib = require('pumas.clib')
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
        raise_error{argnum = 'bad', expected = '3 or more', got = nargs}
    end

    if metatype(self) ~= 'UnitaryTransformation' then
        raise_error{argnum = 1, expected = 'a UnitaryTransformation cdata',
            got = metatype.a(self)}
    end

    if type(axis) ~= 'string' then
        raise_error{argnum = 2, expected = 'a string', got = metatype.a(axis)}
    elseif axis:gsub('[^XYZxyz]', '') ~= axis then
        raise_error{argnum = 2, description = "bad axis '"..axis.."'"}
    end

    local intrinsic
    if axis:upper() == axis then
        intrinsic = true
    elseif axis:lower() == axis then
        intrisic = false
    else
        raise_error{argnum = 2, description = "bad axis '"..axis.."'"}
    end

    local angles = {...}
    if #angles ~= #axis then
        raise_error{argnum = 'bad', expected = #axis + 2, got = #angles + 2}
    end

    local n = #axis
    local c_axis = ffi.new('int [?]', n)
    local c_angles = ffi.new('double [?]', n)
    local indices = {x = 0, y = 1, z = 2}
    for i = 1, n do
        local tag = axis:sub(i,i)
        local index = indices[tag:lower()]
        if index then
            local ii = intrinsic and i - 1 or n - i
            c_angles[ii] = angles[i]
            c_axis[ii] = index
        else
            raise_error{argnum = 1, expected = 'x, y or z', got = tag}
        end
    end

    clib.pumas_coordinates_unitary_transformation_from_euler(
        self, n, c_axis, c_angles)

    return self
end


function UnitaryTransformation.__new (ct, ...)
    local self = ffi.new(ct, ...)

    local n = select('#', ...)
    local arg1 = select(1, ...)
    if (n == 0) or
       ((n == 1) and (type(arg1) == 'table') and (not arg1.matrix)) then
        self.matrix[0][0] = 1
        self.matrix[1][1] = 1
        self.matrix[2][2] = 1
    end

    return self
end


transform.UnitaryTransformation = ffi.metatype(
    'struct pumas_coordinates_unitary_transformation', UnitaryTransformation)

error.register('UnitaryTransformation', UnitaryTransformation)


function UnitaryTransformation.__index:clone ()
    if self then
        return transform.UnitaryTransformation(self)
    else
        error.raise{fname = 'clone', argnum = 1,
            expected = 'a UnitaryTransformation cdata', got = 'nil'}
    end
end


-------------------------------------------------------------------------------
-- Return the package
-------------------------------------------------------------------------------
return transform
