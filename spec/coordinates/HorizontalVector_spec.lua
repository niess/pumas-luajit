local ffi = require('ffi')
local pumas = require('pumas')
local metatype = require('pumas.metatype')
local util = require('spec.util')


describe('HorizontalVector', function ()
    describe('constructor', function ()
        it('should default to zero', function ()
            local c = pumas.HorizontalVector()
            assert.are.equals(c.norm, c.elevation, c.azimuth, 0)
            assert.is.equal(c.frame, nil)
        end)

        it('should properly set attributes', function ()
            local t = pumas.UnitaryTransformation()
            local c = pumas.HorizontalVector(3, 1, 2, t)
            assert.is.equal(c.norm, 3)
            assert.is.equal(c.elevation, 1)
            assert.is.equal(c.azimuth, 2)
            assert.is.equal(c.frame, t)
        end)

        it('should properly set keyword attributes', function ()
            local t = pumas.UnitaryTransformation()
            local c = pumas.HorizontalVector{
                norm = 3, elevation = 1, azimuth = 2, frame = t}
            assert.is.equal(c.norm, 3)
            assert.is.equal(c.elevation, 1)
            assert.is.equal(c.azimuth, 2)
            assert.is.equal(c.frame, t)
        end)

        it('should initialise from another instance', function ()
            local t = pumas.UnitaryTransformation()
            local c0 = pumas.HorizontalVector(3, 1, 2, t)
            local c1 = pumas.HorizontalVector(c0)
            assert.is.equal(c1.norm, 3)
            assert.is.equal(c1.elevation, 1)
            assert.is.equal(c1.azimuth, 2)
            assert.is.equal(c1.frame, t)
        end)

        it('should return a Coordinates cdata', function ()
            local c = pumas.HorizontalVector()
            assert.is.equal(metatype(c), 'Coordinates')
        end)
    end)

    describe('clone', function ()
        it('should raise an error on missing self', function ()
            local c = pumas.HorizontalVector()
            assert.has_error(function ()
                c.clone()
            end, "bad argument #1 to 'clone' (expected a Coordinates cdata, \z
                got nil)")
        end)

        it('should return a copy', function ()
            local t = pumas.UnitaryTransformation()
            local c0 = pumas.HorizontalVector(3, 1, 2, t)
            local c1 = c0:clone()
            assert.is_not.equal(c0, c1)
            assert.is.equal(c1.norm, 3)
            assert.is.equal(c1.elevation, 1)
            assert.is.equal(c1.azimuth, 2)
            assert.is.equal(c1.frame, t)
            assert.is.equal(metatype(c1), metatype(c0))
        end)
    end)

    describe('get', function ()
        it('should raise an error on missing self', function ()
            local c = pumas.HorizontalVector()
            assert.has_error(function ()
                c.get()
            end, "bad argument #1 to 'get' (expected a Coordinates cdata, \z
                got nil)")
        end)

        it('should return an equivalent C array', function ()
            local c = pumas.HorizontalVector(1, 0.5 * math.pi, 0)
            local a = c:get()
            assert.is.True(ffi.istype('double [3]', a))
            assert.is.equal(a[0], 0)
            assert.is.equal(a[1], 0)
            assert.is.equal(a[2], 1)
        end)

        it('should transform back to the simulation frame', function ()
            local t = util.Reflection()
            local c = pumas.HorizontalVector(1, 0.5 * math.pi, 0, t)
            local a = c:get()
            assert.is.equal(a[0], 0)
            assert.is.equal(a[1], 0)
            assert.is.equal(a[2], -1)
        end)
    end)

    describe('set', function ()
        it('should raise an error on missing self', function ()
            local c = pumas.HorizontalVector()
            assert.has_error(function ()
                c.set(pumas.HorizontalVector())
            end, "bad number of argument(s) to 'set' (expected 2, got 1)")
        end)

        it('should accept a C array', function ()
            local c = pumas.HorizontalVector()
            c:set(ffi.new('double [3]', 0, 0, 1))
            assert.is.equal(c.norm, 1)
            assert.is.equal(c.elevation, 0.5 * math.pi)
            assert.is.equal(c.azimuth, 0)
            assert.is.equal(c.frame, nil)
        end)

        it('should accept another vector instance of same type', function ()
            local c = pumas.HorizontalVector()
            local t = util.Reflection()
            c:set(pumas.HorizontalVector(3, 1, 2, t))
            assert.is.equal(c.norm, 3)
            assert.is.equal(c.elevation, 1)
            assert.is.equal(c.azimuth, 2)
            assert.is.equal(c.frame, t)
        end)

        it('should accept another vector instance of different type',
        function ()
            local c = pumas.HorizontalVector()
            local t = util.Reflection()
            c:set(pumas.SphericalVector(3, 1, 2, t))
            assert.is.equal(c.norm, 3)
            assert.is.equal(c.elevation, 0.5 * math.pi - 1)
            assert.is.equal(c.azimuth, 0.5 * math.pi - 2)
            assert.is.equal(c.frame, t)
        end)

        it('should not accept a point instance', function ()
            local c = pumas.HorizontalVector()
            assert.has_error(function ()
                c:set(pumas.SphericalPoint())
            end, "bad argument(s) to 'set' (not implemented)")
        end)

        it('should not accept other types', function ()
            assert.has_error(function ()
                local c = pumas.HorizontalVector()
                c:set(1)
            end, "bad argument #2 to 'set' (expected a Coordinates cdata, \z
                got a number)")
        end)

        it('should return an instance of self', function ()
            local c = pumas.HorizontalVector()
            assert.is.equal(c, c:set(ffi.new('double [3]')))
        end)
    end)

    describe('transform', function ()
        it('should raise an error on missing self', function ()
            local c = pumas.HorizontalVector()
            local t = pumas.UnitaryTransformation()
            assert.has_error(function ()
                c.transform(t)
            end, "bad argument #1 to 'transform' (expected a Coordinates \z
                cdata, got a UnitaryTransformation cdata)")
        end)

        it('should do nothing when same frame', function ()
            local c = pumas.HorizontalVector(3, 1, 2)
            c:transform()
            assert.is.equal(c.norm, 3)
            assert.is.equal(c.elevation, 1)
            assert.is.equal(c.azimuth, 2)
            assert.is.equal(c.frame, nil)
        end)

        it('should transform to the simulation frame', function ()
            local t = util.Reflection()
            local c = pumas.HorizontalVector(1, 0.5 * math.pi, 0, t)
            c:transform()
            assert.is.equal(c.norm, 1)
            assert.is.equal(c.elevation, -0.5 * math.pi)
            assert.is.equal(c.azimuth, 0)
            assert.is.equal(c.frame, nil)
        end)

        it('should transform from the simulation frame', function ()
            local c = pumas.HorizontalVector(1, 0.5 * math.pi, 0)
            local t = util.Reflection()
            c:transform(t)
            assert.is.equal(c.norm, 1)
            assert.is.equal(c.elevation, -0.5 * math.pi)
            assert.is.equal(c.azimuth, 0)
            assert.is.equal(c.frame, t)
        end)

        it('should transform between two frames', function ()
            local t0 = util.Reflection()
            local c = pumas.HorizontalVector(3, 1, 2, t0)
            local t1 = util.Reflection()
            c:transform(t1)
            assert.is.equal(util.round(c.norm, 7), 3)
            assert.is.equal(c.elevation, 1)
            assert.is.equal(c.azimuth, 2)
            assert.is.equal(c.frame, t1)
        end)

        it('should return an instance of self', function ()
            local c = pumas.HorizontalVector()
            assert.is.equal(c, c:transform())
        end)
    end)
end)
