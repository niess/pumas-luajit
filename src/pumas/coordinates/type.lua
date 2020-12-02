-------------------------------------------------------------------------------
-- Coordinates types for PUMAS
-- Author: Valentin Niess
-- License: GNU LGPL-3.0
-------------------------------------------------------------------------------
local ffi = require('ffi')
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
local function CoordinatesType (ctype, setter, get, transform)
    local mt = {__index = {}}

    mt.__index.__metatype = 'coordinates'

    local double3_t = ffi.typeof('double [3]')
    local raw_coordinates
    if tostring(ctype):match('_point>$') then
        raw_coordinates = 'CartesianPoint'
    else
        raw_coordinates = 'CartesianVector'
    end

    function mt.__index:set (coordinates)
        if (self == nil) or (coordinates == nil) then
            local nargs = (self ~= nil) and 1 or 0
            error.raise{
                fname = 'set',
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
        end

        local ct = ffi.typeof(coordinates)
        if ct == ctype then
            ffi.copy(self, coordinates, ffi.sizeof(ct))
        else
            local set = setter(ct)
            if set ~= nil then
                set(self, coordinates)
            else
                error.raise{
                    fname = 'set',
                    description = 'not implemented'
                }
            end
        end
        return self
    end

    function mt.__index:get ()
        if self == nil then
            error.raise{
                fname = 'get',
                argnum = 1,
                expected = 'coordinates',
                got = 'nil'
            }
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
            if (self == nil) or (metatype(self) ~= 'coordinates') then
                error.raise{
                    fname = 'transform',
                    argnum = 1,
                    expected = 'coordinates',
                    got = metatype.a(self)
                }
            end

            transform(self, frame)
            return self
        end
    end

    return ffi.metatype(ctype, mt)
end


-------------------------------------------------------------------------------
-- Metatype for a point using Cartesian coordinates
-------------------------------------------------------------------------------
type_.CartesianPoint = CoordinatesType(cartesian_point_t,
    function (ct)
        if ct == geodetic_point_t then
            return ffi.C.pumas_coordinates_cartesian_point_from_geodetic
        elseif ct == spherical_point_t then
            return ffi.C.pumas_coordinates_cartesian_point_from_spherical
        end
    end,
    nil,
    ffi.C.pumas_coordinates_cartesian_point_transform)


-------------------------------------------------------------------------------
-- Metatype for a vector using Cartesian coordinates
-------------------------------------------------------------------------------
type_.CartesianVector = CoordinatesType(cartesian_vector_t,
    function (ct)
        if ct == horizontal_vector_t then
            return ffi.C.pumas_coordinates_cartesian_vector_from_horizontal
        elseif ct == spherical_vector_t then
            return ffi.C.pumas_coordinates_cartesian_vector_from_spherical
        end
    end,
    nil,
    ffi.C.pumas_coordinates_cartesian_vector_transform)


-------------------------------------------------------------------------------
-- Metatype for a point using geodetic coordinates
-------------------------------------------------------------------------------
type_.GeodeticPoint = CoordinatesType(geodetic_point_t,
    function (ct)
        if ct == cartesian_point_t then
            return ffi.C.pumas_coordinates_geodetic_point_from_cartesian
        elseif ct == spherical_point_t then
            return ffi.C.pumas_coordinates_geodetic_point_from_spherical
        end
    end,
    ffi.C.pumas_coordinates_cartesian_point_from_geodetic)


-------------------------------------------------------------------------------
-- Metatype for a vector using horizontal coordinates
-------------------------------------------------------------------------------
type_.HorizontalVector = CoordinatesType(horizontal_vector_t,
    function (ct)
        if ct == cartesian_vector_t then
            return ffi.C.pumas_coordinates_horizontal_vector_from_cartesian
        elseif ct == spherical_vector_t then
            return ffi.C.pumas_coordinates_horizontal_vector_from_spherical
        end
    end,
    ffi.C.pumas_coordinates_cartesian_vector_from_horizontal,
    ffi.C.pumas_coordinates_horizontal_vector_transform)


-------------------------------------------------------------------------------
-- Metatype for a point using spherical coordinates
-------------------------------------------------------------------------------
type_.SphericalPoint = CoordinatesType(spherical_point_t,
    function (ct)
        if ct == cartesian_point_t then
            return ffi.C.pumas_coordinates_spherical_point_from_cartesian
        elseif ct == geodetic_point_t then
            return ffi.C.pumas_coordinates_spherical_point_from_geodetic
        end
    end,
    ffi.C.pumas_coordinates_cartesian_point_from_spherical,
    ffi.C.pumas_coordinates_spherical_point_transform)


-------------------------------------------------------------------------------
-- Metatype for a vector using spherical coordinates
-------------------------------------------------------------------------------
type_.SphericalVector = CoordinatesType(spherical_vector_t,
    function (ct)
        if ct == cartesian_vector_t then
            return ffi.C.pumas_coordinates_spherical_vector_from_cartesian
        elseif ct == horizontal_vector_t then
            return ffi.C.pumas_coordinates_spherical_vector_from_horizontal
        end
    end,
    ffi.C.pumas_coordinates_cartesian_vector_from_spherical,
    ffi.C.pumas_coordinates_spherical_vector_transform)


-------------------------------------------------------------------------------
-- Return the package
-------------------------------------------------------------------------------
return type_
