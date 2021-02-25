require 'busted.runner' ()
require 'luacov'

local ffi = require('ffi')
local pumas = require('pumas')


-- ECEF coordinates for latitude = 1 deg, longitude = 2 deg, and altitude = 3 m
-- Ref: http://walter.bislins.ch/bloge/index.asp?page=Rainy+Lake+Experiment%3A+WGS84+Calculator
local ecef = {x = 6373290.28, y = 222560.20, z = 110568.83}


local function round (v, precision)
    return math.floor(v * 10^precision + 0.5) * 10^(-precision)
end


describe('GeodeticPoint', function ()
    describe('constructor', function ()
        it('should default to zero', function ()
            local c = pumas.GeodeticPoint()
            assert.are.equals(c.latitude, c.longitude, c.altitude, 0)
        end)

        it('should properly set attributes', function ()
            local c = pumas.GeodeticPoint(1, 2, 3)
            assert.is.equal(c.latitude, 1)
            assert.is.equal(c.longitude, 2)
            assert.is.equal(c.altitude, 3)
        end)

        it('should properly set keyword attributes', function ()
            local c = pumas.GeodeticPoint{
                latitude = 1, longitude = 2, altitude = 3}
            assert.is.equal(c.latitude, 1)
            assert.is.equal(c.longitude, 2)
            assert.is.equal(c.altitude, 3)
        end)

        it('should initialise from another instance', function ()
            local c0 = pumas.GeodeticPoint(1, 2, 3)
            local c1 = pumas.GeodeticPoint(c0)
            assert.is.equal(c1.latitude, 1)
            assert.is.equal(c1.longitude, 2)
            assert.is.equal(c1.altitude, 3)
        end)
    end)

    describe('clone', function ()
        it('should raise an error on missing self', function ()
            local c = pumas.GeodeticPoint()
            assert.has_error(function ()
                c.clone()
            end, "bad argument #1 to 'clone' (expected a Coordinates cdata, \z
                got nil)")
        end)

        it('should return a copy', function ()
            local c0 = pumas.GeodeticPoint(1, 2, 3)
            local c1 = c0:clone()
            assert.is_not.equal(c0, c1)
            assert.is.equal(c1.latitude, 1)
            assert.is.equal(c1.longitude, 2)
            assert.is.equal(c1.altitude, 3)
        end)
    end)

    describe('get', function ()
        it('should raise an error on missing self', function ()
            local c = pumas.GeodeticPoint()
            assert.has_error(function ()
                c.get()
            end, "bad argument #1 to 'get' (expected a Coordinates cdata, \z
                got nil)")
        end)

        it('should return an equivalent C array', function ()
            local c = pumas.GeodeticPoint(1, 2, 3)
            local a = c:get()
            assert.is.True(ffi.istype('double [3]', a))
            assert.is.equal(round(a[0], 2), ecef.x)
            assert.is.equal(round(a[1], 2), ecef.y)
            assert.is.equal(round(a[2], 2), ecef.z)
        end)
    end)

    describe('set', function ()
        it('should raise an error on missing self', function ()
            local c = pumas.GeodeticPoint()
            assert.has_error(function ()
                c.set(pumas.CartesianVector())
            end, "bad number of argument(s) to 'set' (expected 2, got 1)")
        end)

        it('should accept a C array', function ()
            local c = pumas.GeodeticPoint{frame = t}
            c:set(ffi.new('double [3]', ecef.x, ecef.y, ecef.z))
            assert.is.equal(round(c.latitude, 7), 1)
            assert.is.equal(round(c.longitude, 7), 2)
            assert.is.equal(round(c.altitude, 2), 3)
        end)

        it('should accept another point instance of same type', function ()
            local c = pumas.GeodeticPoint()
            c:set(pumas.GeodeticPoint(1, 2, 3))
            assert.is.equal(c.latitude, 1)
            assert.is.equal(c.longitude, 2)
            assert.is.equal(c.altitude, 3)
        end)

        it('should accept another point instance of different type', function ()
            local c = pumas.GeodeticPoint()
            c:set(pumas.CartesianPoint(ecef.x, ecef.y, ecef.z))
            assert.is.equal(round(c.latitude, 7), 1)
            assert.is.equal(round(c.longitude, 7), 2)
            assert.is.equal(round(c.altitude, 2), 3)
        end)

        it('should not accept a vector instance', function ()
            local c = pumas.GeodeticPoint()
            assert.has_error(function ()
                c:set(pumas.CartesianVector())
            end, "bad argument(s) to 'set' (not implemented)")
        end)

        it('should return an instance of self', function ()
            local c = pumas.GeodeticPoint()
            assert.is.equal(c, c:set(ffi.new('double [3]')))
        end)
    end)
end)
