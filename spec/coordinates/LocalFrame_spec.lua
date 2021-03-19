-------------------------------------------------------------------------------
-- Spec of the pumas.LocalFrame metatype
-- Author: Valentin Niess
-- License: GNU LGPL-3.0
-------------------------------------------------------------------------------
local pumas = require('pumas')
local metatype = require('pumas.metatype')
local util = require('spec.util')


-- ECEF coordinates for latitude = 45 deg, longitude = 0 deg, and altitude = 0 m
-- Ref: http://walter.bislins.ch/bloge/index.asp?page=Rainy+Lake+Experiment%3A+WGS84+Calculator
local ecef = {x = 4517590.88, y = 0, z = 4487348.41}


describe('LocalFrame', function ()
    describe('constructor', function ()
        it('should raise an error on missing origin', function ()
            assert.has_error(function ()
                pumas.LocalFrame()
            end, "bad number of argument(s) to 'LocalFrame' \z
                (expected 1, got 0)")
        end)

        it('should raise an error on wrong type for origin', function ()
            assert.has_error(function ()
                pumas.LocalFrame(1)
            end, "bad argument #2 to 'set' (expected a Coordinates cdata, \z
                got a number)")
        end)

        it('should return a UnitaryTransformation table', function ()
            local c = pumas.GeodeticPoint(45, 0, 0)
            local f = pumas.LocalFrame(c)
            assert.is.equal(metatype(f), 'UnitaryTransformation')
        end)

        it('should propely set the transform', function ()
            local c = pumas.GeodeticPoint(45, 0, 0)
            local f = pumas.LocalFrame(c)

            util.assert_unitary(f)

            assert.is.equal(util.round(f.translation[0], 2), ecef.x)
            assert.is.equal(util.round(f.translation[1], 2), ecef.y)
            assert.is.equal(util.round(f.translation[2], 2), ecef.z)

            local s2 = util.round(1 / math.sqrt(2), 7)
            assert.is.equal(  0, util.round(f.matrix[0][0], 7))
            assert.is.equal(  1, util.round(f.matrix[1][0], 7))
            assert.is.equal(  0, util.round(f.matrix[2][0], 7))
            assert.is.equal(-s2, util.round(f.matrix[0][1], 7))
            assert.is.equal(  0, util.round(f.matrix[1][1], 7))
            assert.is.equal( s2, util.round(f.matrix[2][1], 7))
            assert.is.equal( s2, util.round(f.matrix[0][2], 7))
            assert.is.equal(  0, util.round(f.matrix[1][2], 7))
            assert.is.equal( s2, util.round(f.matrix[2][2], 7))
        end)

        it('should propely set declination', function ()
            local c = pumas.GeodeticPoint(45, 0, 0)
            local f = pumas.LocalFrame(c, {declination = 90})

            util.assert_unitary(f)

            local s2 = util.round(1 / math.sqrt(2), 7)
            assert.is.equal( s2, util.round(f.matrix[0][0], 7))
            assert.is.equal(  0, util.round(f.matrix[1][0], 7))
            assert.is.equal(-s2, util.round(f.matrix[2][0], 7))
            assert.is.equal(  0, util.round(f.matrix[0][1], 7))
            assert.is.equal(  1, util.round(f.matrix[1][1], 7))
            assert.is.equal(  0, util.round(f.matrix[2][1], 7))
            assert.is.equal( s2, util.round(f.matrix[0][2], 7))
            assert.is.equal(  0, util.round(f.matrix[1][2], 7))
            assert.is.equal( s2, util.round(f.matrix[2][2], 7))
        end)

        it('should propely set inclination', function ()
            local c = pumas.GeodeticPoint(45, 0, 0)
            local f = pumas.LocalFrame(c, {inclination = 45})

            util.assert_unitary(f)

            assert.is.equal( 0, util.round(f.matrix[0][0], 7))
            assert.is.equal( 1, util.round(f.matrix[1][0], 7))
            assert.is.equal( 0, util.round(f.matrix[2][0], 7))
            assert.is.equal(-1, util.round(f.matrix[0][1], 7))
            assert.is.equal( 0, util.round(f.matrix[1][1], 7))
            assert.is.equal( 0, util.round(f.matrix[2][1], 7))
            assert.is.equal( 0, util.round(f.matrix[0][2], 7))
            assert.is.equal( 0, util.round(f.matrix[1][2], 7))
            assert.is.equal( 1, util.round(f.matrix[2][2], 7))
        end)
    end)
end)
