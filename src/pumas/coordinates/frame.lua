-------------------------------------------------------------------------------
-- Coordinate frame(s) for PUMAS
-- Author: Valentin Niess
-- License: GNU LGPL-3.0
-------------------------------------------------------------------------------
local transform = require('pumas.coordinates.transform')
local error = require('pumas.error')
local ffi = require('pumas.ffi')
local type_ = require('pumas.coordinates.type')

local frame = {}


-------------------------------------------------------------------------------
-- Wrapper for local Earth frames
-------------------------------------------------------------------------------
local pumas_cartesian_point_t = ffi.typeof('struct pumas_cartesian_point')
local pumas_geodetic_point_t = ffi.typeof('struct pumas_geodetic_point')


function frame.LocalFrame (origin)
    if origin == nil then
        error.raise{
            fname = 'LocalFrame',
            argnum = 'bad',
            expected = 1,
            got = 0
        }
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

    local self = transform.Transform()
    ffi.C.pumas_coordinates_frame_initialise_local(
        self, origin, geodetic)

    return self
end


-------------------------------------------------------------------------------
-- Return the package
-------------------------------------------------------------------------------
return frame
