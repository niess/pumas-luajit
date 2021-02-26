-------------------------------------------------------------------------------
-- Coordinate frame(s) for PUMAS
-- Author: Valentin Niess
-- License: GNU LGPL-3.0
-------------------------------------------------------------------------------
local ffi = require('ffi')
local clib = require('pumas.clib')
local transform = require('pumas.coordinates.transform')
local type_ = require('pumas.coordinates.type')
local error = require('pumas.error')
local metatype = require('pumas.metatype')

local frame = {}


-------------------------------------------------------------------------------
-- Wrapper for local Earth frames
-------------------------------------------------------------------------------
local pumas_cartesian_point_t = ffi.typeof('struct pumas_cartesian_point')
local pumas_geodetic_point_t = ffi.typeof('struct pumas_geodetic_point')


-- XXX Add extra frame parameters, e.g. declination
function frame.LocalFrame (origin, options)
    if origin == nil then
        error.raise{fname = 'LocalFrame', argnum = 'bad', expected = 1, got = 0}
    end

    local geodetic
    if ffi.istype(pumas_geodetic_point_t, origin) then
        geodetic = origin
    else
        geodetic = type_.GeodeticPoint():set(origin)
    end

    if (not ffi.istype(pumas_cartesian_point_t, origin)) or
       (origin.frame ~= nil) then
        origin = type_.CartesianPoint():set(origin)
                                       :transform(nil)
    end


    local declination = options and options.declination or 0
    local inclination = options and options.inclination or 0

    local declination, inclination
    if options then
        declination = options.declination or 0
        if type(declination) ~= 'number' then
            error.raise{fname = 'LocalFrame', argname = 'declination',
                expected = 'a number', got = metatype.a(declination)}
        end

        inclination = options.inclination or 0
        if type(inclination) ~= 'number' then
            error.raise{fname = 'LocalFrame', argname = 'inclination',
                expected = 'a number', got = metatype.a(inclination)}
        end
    else
        declination, inclination = 0, 0
    end

    local self = transform.UnitaryTransformation()
    clib.pumas_coordinates_frame_initialise_local(
        self, origin, geodetic, declination, inclination)

    return self
end


-------------------------------------------------------------------------------
-- Return the package
-------------------------------------------------------------------------------
return frame
