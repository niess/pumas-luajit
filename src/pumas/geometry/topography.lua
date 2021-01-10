-------------------------------------------------------------------------------
-- Wrapper for topography data
-- Author: Valentin Niess
-- License: GNU LGPL-3.0
-------------------------------------------------------------------------------
local ffi = require('ffi')
local lfs = require('lfs')
local call = require('pumas.call')
local error = require('pumas.error')
local metatype = require('pumas.metatype')

local topography = {}


-------------------------------------------------------------------------------
-- The topography data metatypes
-------------------------------------------------------------------------------
local TopographyData = {__index={}}
TopographyData.__index.__metatype = 'TopographyData'


function TopographyData.__index:elevation (x, y)
    if (self == nil) or (x == nil) or (y == nil) then
        local args = {self, x, y}
        error.raise{
            fname = 'elevation',
            argnum = 'bad',
            expected = 3,
            got = #args
        }
    end

    if type(self._elevation) == 'number' then
        return self._elevation
    else
        local z = ffi.new('double [1]')
        local inside = ffi.new('int [1]')
        call(self._elevation, self._c, x, y, z, inside)
        if inside[0] == 1 then
            return z[0]
        else
            return nil
        end
    end
end


-- Wrap the turtle_stack struct
local mt_stack = {__index = {}}
mt_stack.__index._stepper_add = ffi.C.turtle_stepper_add_stack
mt_stack.__index._elevation = ffi.C.turtle_stack_elevation
for k, v in pairs(TopographyData.__index) do mt_stack.__index[k] = v end


-- Wrap the turtle_map struct
local mt_map = {__index = {}}
mt_map.__index._stepper_add = ffi.C.turtle_stepper_add_map
do
    mt_map.__index._elevation = function (self, x, y, z, inside)
        local projection = ffi.C.turtle_map_projection(self)
        if projection ~= nil then
            local xmap = ffi.new('double [1]')
            local ymap = ffi.new('double [1]')
            ffi.C.turtle_projection_project(projection, x, y, xmap, ymap)
            x, y = xmap[0], ymap[0]
        end
        return ffi.C.turtle_map_elevation(self, x, y, z, inside)
    end
end
for k, v in pairs(TopographyData.__index) do mt_map.__index[k] = v end


-- Wrap the flat topography
local mt_flat = {__index = {}}
mt_flat.__index._stepper_add = ffi.C.turtle_stepper_add_flat
for k, v in pairs(TopographyData.__index) do mt_flat.__index[k] = v end


-------------------------------------------------------------------------------
-- The topography data constructor
-------------------------------------------------------------------------------
do
    local function new (_, data)
        if data == nil then data = 0 end

        local self = {}
        local c, ptr, metatype_
        local data_type = type(data)
        if data_type == 'string' then
            local mode, errmsg = lfs.attributes(data, 'mode')
            if mode == nil then
                error.raise{
                    fname = 'TopographyData',
                    description = errmsg
                }
            elseif mode == 'directory' then
                ptr = ffi.new('struct turtle_stack *[1]')
                call(ffi.C.turtle_stack_create, ptr, data, 0, nil, nil)
                c = ptr[0]
                ffi.gc(c, function () ffi.C.turtle_stack_destroy(ptr) end)
                call(ffi.C.turtle_stack_load, c)
                metatype_ = mt_stack
            else
                ptr = ffi.new('struct turtle_map *[1]')
                call(ffi.C.turtle_map_load, ptr, data)
                c = ptr[0]
                ffi.gc(c, function () ffi.C.turtle_map_destroy(ptr) end)
                metatype_ = mt_map
            end
        elseif data_type == 'number' then
            self._elevation = data
            metatype_ = mt_flat
        else
            error.raise{
                fname = 'TopographyData',
                argnum = 1,
                expected = 'a number or a string',
                got = metatype.a(data)
            }
        end
        self._c = c

        return setmetatable(self, metatype_)
    end

    topography.TopographyData = setmetatable(TopographyData, {__call = new})
end


-------------------------------------------------------------------------------
-- Return the package
-------------------------------------------------------------------------------
return topography
