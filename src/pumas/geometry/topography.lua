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

-- XXX Add a TopographyDataSet with global offset? Or multiple data sources


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
        return self._elevation + self.offset
    else
        local z = ffi.new('double [1]')
        local inside = ffi.new('int [1]')
        call(self._elevation, self._c, x, y, z, inside)
        if inside[0] == 1 then
            return z[0] + self.offset
        else
            return nil
        end
    end
end


-------------------------------------------------------------------------------
-- Addition and subtraction operators
-------------------------------------------------------------------------------
do
    local function add (t, v)
        if type(v) == 'number' then
            local c = {}
            for ki, vi in pairs(t) do
                c[ki] = vi
            end
            c.offset = c.offset + v

            return setmetatable(c, getmetatable(t))
        else
            error.raise{
                fname = '__add',
                argnum = 2,
                expected = 'a number',
                got = metatype.a(v)
            }
        end
    end

    TopographyData.__add = add

    function TopographyData:__sub (v)
        return add(self, -v)
    end
end


-------------------------------------------------------------------------------
-- Generic wrapper for topography data types
-------------------------------------------------------------------------------
local function WrappedData (add, elevation)
    local mt = {__index = {}}

    mt.__index._stepper_add = add
    if elevation then
        mt.__index._elevation = elevation
    end

    for k, v in pairs(TopographyData.__index) do
        mt.__index[k] = v
    end

    mt.__add = TopographyData.__add
    mt.__sub = TopographyData.__sub

    return mt
end


-------------------------------------------------------------------------------
-- Wrapper for turtle_stack struct
-------------------------------------------------------------------------------
local mt_stack = WrappedData(
    ffi.C.turtle_stepper_add_stack,
    ffi.C.turtle_stack_elevation)


-------------------------------------------------------------------------------
-- Wrapper for turtle_map struct
-------------------------------------------------------------------------------
local mt_map = WrappedData(
    ffi.C.turtle_stepper_add_map,
    function (self, x, y, z, inside)
        local projection = ffi.C.turtle_map_projection(self)

        if projection ~= nil then
            local xmap = ffi.new('double [1]')
            local ymap = ffi.new('double [1]')
            ffi.C.turtle_projection_project(projection, x, y, xmap, ymap)
            x, y = xmap[0], ymap[0]
        end

        return ffi.C.turtle_map_elevation(self, x, y, z, inside)
    end)


-------------------------------------------------------------------------------
-- Wrapper for flat topography
-------------------------------------------------------------------------------
local mt_flat = WrappedData(ffi.C.turtle_stepper_add_flat)


-------------------------------------------------------------------------------
-- The topography data constructor
-------------------------------------------------------------------------------
do
    local function new (_, data)
        if data == nil then data = 0 end

        local self = {}
        self.offset = 0
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
