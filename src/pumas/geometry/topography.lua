-------------------------------------------------------------------------------
-- Wrapper for topography data
-- Author: Valentin Niess
-- License: GNU LGPL-3.0
-------------------------------------------------------------------------------
local ffi = require('ffi')
local lfs = require('lfs')
local call = require('pumas.call')
local clib = require('pumas.clib')
local compat = require('pumas.compat')
local error = require('pumas.error')
local metatype = require('pumas.metatype')
local type_ = require('pumas.coordinates.type')

local topography = {}


-------------------------------------------------------------------------------
-- The topography data metatypes
-------------------------------------------------------------------------------
local TopographyData = {}

do
    local pumas_geodetic_point_t = ffi.typeof('struct pumas_geodetic_point')

    local function elevation (self, x, y)
        if (self == nil) or (x == nil) then
            local args = {self, x, y}
            error.raise{
                fname = 'elevation', argnum = 'bad', expected = '2 or 3',
                got = #args}
        end

        if y == nil then
            local geodetic
            if ffi.istype(pumas_geodetic_point_t, x) then
                geodetic = x
            elseif (metatype(x) == 'Coordinates') or
                ffi.istype('double [3]', x) then
                geodetic = type_.GeodeticPoint():set(x)
            else
                error.raise{
                    fname = 'elevation', argnum = 2,
                    expected = 'a Coordinates ctype', got = metatype.a(x)}
            end
            x, y = geodetic.latitude, geodetic.longitude
        else
            local argnum, argval
            if type(x) ~= 'number' then argnum, argval = 2, x end
            if type(y) ~= 'number' then argnum, argval = 3, y end

            if argnum then
                error.raise{
                    fname = 'elevation', argnum = argnum,
                    expected = 'a number', got = metatype.a(argval)}
            end
        end

        if self._elevation then
            local z = ffi.new('double [1]')
            local inside = ffi.new('int [1]')
            call(self._elevation, self._c, x, y, z, inside)
            if inside[0] == 1 then
                return z[0] + self._offset
            else
                return nil
            end
        else
            return self._offset
        end
    end

    local function clone (self)
        if not self then
            error.raise{
                fname = 'clone', argnum = 1,
                expected = 'a TopographyData table', got = metatype.a(self)}
        end

        local new = {}
        for k, v in pairs(self) do
            if k ~= '_geometry' then
                new[k] = v
            end
        end

        return setmetatable(new, TopographyData)
    end

    error.register('TopographyData.__index.clone')
    error.register('TopographyData.__index.elevation')

    function TopographyData:__index (k)
        if k == '__metatype' then
            return 'TopographyData'
        elseif k == 'clone' then
            return clone
        elseif k == 'elevation' then
            return elevation
        elseif k == 'offset' then
            return self._offset
        elseif k == 'path' then
            return self._path
        else
            error.raise{
                ['type'] = 'TopographyData', bad_member = k}
        end
    end

    function TopographyData:__newindex (k, v)
        if k == 'offset' then
            if type(v) ~= 'number' then
                error.raise{fname = 'offset', expected = 'a number',
                    got = metatype.a(v)}
            end

            if v ~= self._offset then
                self._offset = v

                local geometry = rawget(self, '_geometry')
                if geometry then
                    geometry:_invalidate()
                end
            end
        elseif (k == 'path') or (k == 'elevation') then
            error.raise{
                ['type'] = 'TopographyData', not_mutable = k}
        else
            error.raise{
                ['type'] = 'TopographyData', bad_member = k}
        end
    end
end


-------------------------------------------------------------------------------
-- Addition and subtraction operators
-------------------------------------------------------------------------------
do
    local function add (t, v)
        if type(v) == 'number' then
            local c = t:clone()
            c._offset = c._offset + v

            return c
        else
            error.raise{
                fname = 'TopographyData.__add',
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
-- The topography data constructor
-------------------------------------------------------------------------------
do
    local function map_elevation (self, x, y, z, inside)
        local projection = clib.turtle_map_projection(self)

        if projection == nil then
            x, y = y, x
        else
            local xmap = ffi.new('double [1]')
            local ymap = ffi.new('double [1]')
            clib.turtle_projection_project(projection, x, y, xmap, ymap)
            x, y = xmap[0], ymap[0]
        end

        return clib.turtle_map_elevation(self, x, y, z, inside)
    end

    local function new (cls, data, offset)
        if data == nil then data = 0 end

        local self = {}
        local c, ptr
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
                call(clib.turtle_stack_create, ptr, data, 0, nil, nil)
                c = ptr[0]
                ffi.gc(c, function () clib.turtle_stack_destroy(ptr) end)
                call(clib.turtle_stack_load, c)
                self._stepper_add = clib.turtle_stepper_add_stack
                self._elevation = clib.turtle_stack_elevation
            else
                ptr = ffi.new('struct turtle_map *[1]')
                call(clib.turtle_map_load, ptr, data)
                c = ptr[0]
                ffi.gc(c, function () clib.turtle_map_destroy(ptr) end)
                self._stepper_add = clib.turtle_stepper_add_map
                self._elevation = map_elevation
            end
            self._offset = offset or 0
            self._path = data
        elseif data_type == 'number' then
            if offset then
                error.raise{
                    fname = 'TopographyData', argnum = 'bad', expected = 1,
                    got = 2}
            end
            self._offset = data
            self._stepper_add = clib.turtle_stepper_add_flat
            self._elevation = false
        else
            error.raise{
                fname = 'TopographyData', argnum = 1,
                expected = 'a number or a string', got = metatype.a(data)}
        end
        self._c = c

        return setmetatable(self, cls)
    end

    topography.TopographyData = setmetatable(TopographyData, {__call = new})
end


-------------------------------------------------------------------------------
-- Topography data set
-------------------------------------------------------------------------------
local TopographyDataset = {__index = {}}

do
    local function add (self, t)
        local new = compat.table_new(#self, 0)

        for i, v in ipairs(self) do
            new[i] = v + t
        end

        return setmetatable({_set = new}, TopographyDataset)
    end

    TopographyDataset.__add = add

    function TopographyDataset:__sub (t)
        return add(self, -t)
    end
end

function TopographyDataset:__len ()
    return #self._set
end

do
    local function clone (self)
        if not self then
            error.raise{fname = 'clone', argnum = 1,
                expected = 'a TopographyDataset table', got = metatype.a(self)}
        else
            local new = {}
            for k, v in pairs(self._set) do
                new[k] = v:clone()
            end

            return setmetatable({_set = new}, TopographyDataset)
        end
    end

    local function elevation (self, x, y)
        if not self then
            error.raise{fname = 'elevation', argnum = 1,
                expected = 'a TopographyDataset', got = metatype.a(self)}
        end

        for _, v in ipairs(self._set) do
            local z = v:elevation(x, y)
            if z then return z end
        end
    end

    local function ipairs_ (self)
        if not self then
            error.raise{fname = 'ipairs', argnum = 1,
                expected = 'a TopographyDataset', got = metatype.a(self)}
        end

        return ipairs(self._set)
    end

    error.register('TopographyDataset.__index.clone', clone)
    error.register('TopographyDataset.__index.elevation', elevation)
    error.register('TopographyDataset.__index.ipairs', ipairs_)

    function TopographyDataset:__index (k)
        if type(k) == 'number' then
            return self._set[k]
        elseif k == '__metatype' then
            return 'TopographyDataset'
        elseif k == 'clone' then
            return clone
        elseif k == 'elevation' then
            return elevation
        elseif k == 'ipairs' then
            return ipairs_
        else
            error.raise{['type'] = 'TopographyDataset', bad_member = k}
        end
    end

    function TopographyDataset.__newindex (_, k)
        if (type(k) == 'number') or (k == 'clone') or (k == 'elevation') then
            error.raise{['type'] = 'TopographyDataset', not_mutable = k}
        else
            error.raise{['type'] = 'TopographyDataset', bad_member = k}
        end
    end
end

do
    local raise_error = error.ErrorFunction{fname = 'TopographyDataset'}

    local function new (cls, ...)
        local nargs = select('#', ...)
        if nargs == 0 then
            raise_error{argnum = 'bad', expected = '1 or more', got = 0}
        end

        local set = compat.table_new(nargs, 0)
        local iarg = 0

        local function add (args, index)
            for i, arg in ipairs(args) do
                local mt = metatype(arg)
                if mt == 'TopographyData' then
                    iarg = iarg + 1
                    set[iarg] = arg:clone()
                elseif (mt == 'string') or (mt == 'number') then
                    iarg = iarg + 1
                    set[iarg] = TopographyData(arg)
                elseif mt == 'table' then
                    add(arg, index or i)
                else
                    raise_error{argnum = index or i,
                        expected = 'a (TopographyData) table, a string or \z
                                    a number',
                        got = metatype.a(arg)}
                end
            end
        end

        add({...})

        return setmetatable({_set = set}, cls)
    end

    topography.TopographyDataset =
        setmetatable(TopographyDataset, {__call = new})
end


-------------------------------------------------------------------------------
-- Return the package
-------------------------------------------------------------------------------
return topography
