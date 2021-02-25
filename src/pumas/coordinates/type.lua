-------------------------------------------------------------------------------
-- Coordinates types for PUMAS
-- Author: Valentin Niess
-- License: GNU LGPL-3.0
-------------------------------------------------------------------------------
local ffi = require('ffi')
local clib = require('pumas.clib')
local error = require('pumas.error')
local metatype = require('pumas.metatype')

local type_ = {}


-------------------------------------------------------------------------------
-- The Coordinates C types
-------------------------------------------------------------------------------
local cartesian_point_t = ffi.typeof('struct pumas_cartesian_point')
local cartesian_vector_t = ffi.typeof('struct pumas_cartesian_vector')
local spherical_point_t = ffi.typeof('struct pumas_spherical_point')
local spherical_vector_t = ffi.typeof('struct pumas_spherical_vector')
local geodetic_point_t = ffi.typeof('struct pumas_geodetic_point')
local horizontal_vector_t = ffi.typeof('struct pumas_horizontal_vector')


-------------------------------------------------------------------------------
-- Generic constructor for coordinates metatypes
-------------------------------------------------------------------------------
local function CoordinatesType (name, ctype, setter, get, transform)
    local mt = {__index = {}}

    mt.__index.__metatype = 'Coordinates'

    local double3_t = ffi.typeof('double [3]')
    local raw_coordinates
    if tostring(ctype):match('_point>$') then
        raw_coordinates = 'CartesianPoint'
    else
        raw_coordinates = 'CartesianVector'
    end

    local function set (self, coordinates, fname)
        if (self == nil) or (coordinates == nil) then
            local nargs = (self ~= nil) and 1 or 0
            error.raise{
                fname = fname or 'set',
                argnum = 'bad',
                expected = 2,
                got = nargs
            }
        end

        if ffi.istype(double3_t, coordinates) then
            if type(raw_coordinates) == 'string' then
                raw_coordinates = type_[raw_coordinates]()
            end
            raw_coordinates.x = coordinates[0]
            raw_coordinates.y = coordinates[1]
            raw_coordinates.z = coordinates[2]
            coordinates = raw_coordinates
        elseif metatype(coordinates) ~= 'Coordinates' then
            error.raise{
                fname = fname or 'set',
                argnum = fname and 1 or 2,
                expected = 'a Coordinates cdata',
                got = metatype.a(coordinates)
            }
        end

        local ct = ffi.typeof(coordinates)
        if ct == ctype then
            ffi.copy(self, coordinates, ffi.sizeof(ct))
        else
            local set_ = setter(ct)
            if set_ ~= nil then
                set_(self, coordinates)
            else
                error.raise{
                    fname = fname or 'set',
                    description = 'not implemented'
                }
            end
        end
        return self
    end

    mt.__index.set = set

    function mt.__index:get ()
        if self == nil then
            error.raise{
                fname = 'get', argnum = 1, expected = 'a Coordinates cdata',
                got = 'nil'}
        end

        if type(raw_coordinates) == 'string' then
            raw_coordinates = type_[raw_coordinates]()
        end
        if get ~= nil then
            get(raw_coordinates, self)
        else
            ffi.copy(raw_coordinates, self, ffi.sizeof(self))
        end
        raw_coordinates:transform()

        return ffi.new('double [3]', raw_coordinates.x, raw_coordinates.y,
                       raw_coordinates.z)
    end

    if transform ~= nil then
        function mt.__index:transform (frame)
            if (self == nil) or (metatype(self) ~= 'Coordinates') then
                error.raise{
                    fname = 'transform',
                    argnum = 1,
                    expected = 'a Coordinates cdata',
                    got = metatype.a(self)
                }
            end

            if (frame ~= nil) and
               (metatype(frame) ~= 'UnitaryTransformation') then
                error.raise{
                    fname = 'transform',
                    argnum = 2,
                    expected = 'a UnitaryTransformation cdata',
                    got = metatype.a(frame)
                }
            end

            transform(self, frame)
            return self
        end
    end

    local Meta = ffi.metatype(ctype, mt)

    local function new (_, ...)
        if select('#', ...) == 1 then
            local arg = select(1, ...)
            if type(arg) ~= 'table' then
                local self = Meta()
                return set(self, arg, name)
            end
        end
        return Meta(...)
    end

    function mt.__index:clone ()
        if self == nil then
            error.raise{
                fname = 'clone', argnum = 1, expected = 'a Coordinates cdata',
                got = 'nil'}
        end

        local coordinates = Meta()
        ffi.copy(coordinates, self, ffi.sizeof(ctype))

        return coordinates
    end

    return setmetatable(mt, {__call = new})
end


-------------------------------------------------------------------------------
-- Metatype for a point using Cartesian coordinates
-------------------------------------------------------------------------------
type_.CartesianPoint = CoordinatesType('CartesianPoint', cartesian_point_t,
    function (ct)
        if ct == geodetic_point_t then
            return clib.pumas_coordinates_cartesian_point_from_geodetic
        elseif ct == spherical_point_t then
            return clib.pumas_coordinates_cartesian_point_from_spherical
        end
    end,
    nil,
    clib.pumas_coordinates_cartesian_point_transform)


-------------------------------------------------------------------------------
-- Metatype for a vector using Cartesian coordinates
-------------------------------------------------------------------------------
type_.CartesianVector = CoordinatesType('CartesianVector', cartesian_vector_t,
    function (ct)
        if ct == horizontal_vector_t then
            return clib.pumas_coordinates_cartesian_vector_from_horizontal
        elseif ct == spherical_vector_t then
            return clib.pumas_coordinates_cartesian_vector_from_spherical
        end
    end,
    nil,
    clib.pumas_coordinates_cartesian_vector_transform)


-------------------------------------------------------------------------------
-- Metatype for a point using geodetic coordinates
-------------------------------------------------------------------------------
type_.GeodeticPoint = CoordinatesType('GeodeticPoint', geodetic_point_t,
    function (ct)
        if ct == cartesian_point_t then
            return clib.pumas_coordinates_geodetic_point_from_cartesian
        elseif ct == spherical_point_t then
            return clib.pumas_coordinates_geodetic_point_from_spherical
        end
    end,
    clib.pumas_coordinates_cartesian_point_from_geodetic)


-------------------------------------------------------------------------------
-- Metatype for a vector using horizontal coordinates
-------------------------------------------------------------------------------
type_.HorizontalVector = CoordinatesType('HorizontalVector',
    horizontal_vector_t,
    function (ct)
        if ct == cartesian_vector_t then
            return clib.pumas_coordinates_horizontal_vector_from_cartesian
        elseif ct == spherical_vector_t then
            return clib.pumas_coordinates_horizontal_vector_from_spherical
        end
    end,
    clib.pumas_coordinates_cartesian_vector_from_horizontal,
    clib.pumas_coordinates_horizontal_vector_transform)


-------------------------------------------------------------------------------
-- Metatype for a point using spherical coordinates
-------------------------------------------------------------------------------
type_.SphericalPoint = CoordinatesType('SphericalPoint', spherical_point_t,
    function (ct)
        if ct == cartesian_point_t then
            return clib.pumas_coordinates_spherical_point_from_cartesian
        elseif ct == geodetic_point_t then
            return clib.pumas_coordinates_spherical_point_from_geodetic
        end
    end,
    clib.pumas_coordinates_cartesian_point_from_spherical,
    clib.pumas_coordinates_spherical_point_transform)


-------------------------------------------------------------------------------
-- Metatype for a vector using spherical coordinates
-------------------------------------------------------------------------------
type_.SphericalVector = CoordinatesType('SphericalVector', spherical_vector_t,
    function (ct)
        if ct == cartesian_vector_t then
            return clib.pumas_coordinates_spherical_vector_from_cartesian
        elseif ct == horizontal_vector_t then
            return clib.pumas_coordinates_spherical_vector_from_horizontal
        end
    end,
    clib.pumas_coordinates_cartesian_vector_from_spherical,
    clib.pumas_coordinates_spherical_vector_transform)


-------------------------------------------------------------------------------
-- Return the package
-------------------------------------------------------------------------------
return type_
