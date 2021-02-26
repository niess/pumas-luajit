local ffi = require('ffi')
local pumas = require('pumas')
local metatype = require('pumas.metatype')
local util = require('spec.util')


describe('CartesianVector', function ()
    describe('constructor', function ()
        it('should default to zero', function ()
            local c = pumas.CartesianVector()
            assert.are.equals(c.x, c.y, c.z, 0)
            assert.is.equal(c.frame, nil)
        end)

        it('should properly set attributes', function ()
            local t = pumas.UnitaryTransformation()
            local c = pumas.CartesianVector(1, 2, 3, t)
            assert.is.equal(c.x, 1)
            assert.is.equal(c.y, 2)
            assert.is.equal(c.z, 3)
            assert.is.equal(c.frame, t)
        end)

        it('should properly set keyword attributes', function ()
            local t = pumas.UnitaryTransformation()
            local c = pumas.CartesianVector{x = 1, y = 2, z = 3, frame = t}
            assert.is.equal(c.x, 1)
            assert.is.equal(c.y, 2)
            assert.is.equal(c.z, 3)
            assert.is.equal(c.frame, t)
        end)

        it('should initialise from another instance', function ()
            local t = pumas.UnitaryTransformation()
            local c0 = pumas.CartesianVector(1, 2, 3, t)
            local c1 = pumas.CartesianVector(c0)
            assert.is.equal(c1.x, 1)
            assert.is.equal(c1.y, 2)
            assert.is.equal(c1.z, 3)
            assert.is.equal(c1.frame, t)
        end)

        it('should return a Coordinates cdata', function ()
            local c = pumas.CartesianVector()
            assert.is.equal(metatype(c), 'Coordinates')
        end)
    end)

    describe('clone', function ()
        it('should raise an error on missing self', function ()
            local c = pumas.CartesianVector()
            assert.has_error(function ()
                c.clone()
            end, "bad argument #1 to 'clone' (expected a Coordinates cdata, \z
                got nil)")
        end)

        it('should return a copy', function ()
            local t = pumas.UnitaryTransformation()
            local c0 = pumas.CartesianVector(1, 2, 3, t)
            local c1 = c0:clone()
            assert.is_not.equal(c0, c1)
            assert.is.equal(c1.x, 1)
            assert.is.equal(c1.y, 2)
            assert.is.equal(c1.z, 3)
            assert.is.equal(c1.frame, t)
            assert.is.equal(metatype(c1), metatype(c0))
        end)
    end)

    describe('get', function ()
        it('should raise an error on missing self', function ()
            local c = pumas.CartesianVector()
            assert.has_error(function ()
                c.get()
            end, "bad argument #1 to 'get' (expected a Coordinates cdata, \z
                got nil)")
        end)

        it('should return an equivalent C array', function ()
            local c = pumas.CartesianVector(1, 2, 3)
            local a = c:get()
            assert.is.True(ffi.istype('double [3]', a))
            assert.is.equal(a[0], c.x)
            assert.is.equal(a[1], c.y)
            assert.is.equal(a[2], c.z)
        end)

        it('should transform back to the simulation frame', function ()
            local t = util.Reflection()
            local c = pumas.CartesianVector(1, 2, 3, t)
            local a = c:get()
            assert.is.equal(a[0], -c.x)
            assert.is.equal(a[1], -c.y)
            assert.is.equal(a[2], -c.z)
        end)
    end)

    describe('set', function ()
        it('should raise an error on missing self', function ()
            local c = pumas.CartesianVector()
            assert.has_error(function ()
                c.set(pumas.CartesianVector())
            end, "bad number of argument(s) to 'set' (expected 2, got 1)")
        end)

        it('should accept a C array', function ()
            local c = pumas.CartesianVector()
            c:set(ffi.new('double [3]', 1, 2, 3))
            assert.is.equal(c.x, 1)
            assert.is.equal(c.y, 2)
            assert.is.equal(c.z, 3)
            assert.is.equal(c.frame, nil)
        end)

        it('should accept another vector instance of same type', function ()
            local c = pumas.CartesianVector()
            local t = util.Reflection()
            c:set(pumas.CartesianVector(1, 2, 3, t))
            assert.is.equal(c.x, 1)
            assert.is.equal(c.y, 2)
            assert.is.equal(c.z, 3)
            assert.is.equal(c.frame, t)
        end)

        it('should accept another vector instance of different type',
        function ()
            local c = pumas.CartesianVector()
            local t = util.Reflection()
            c:set(pumas.SphericalVector(1, 0, 0, t))
            assert.is.equal(c.x, 0)
            assert.is.equal(c.y, 0)
            assert.is.equal(c.z, 1)
            assert.is.equal(c.frame, t)
        end)

        it('should not accept a vector instance', function ()
            local c = pumas.CartesianVector()
            assert.has_error(function ()
                c:set(pumas.CartesianPoint())
            end, "bad argument(s) to 'set' (not implemented)")
        end)

        it('should not accept other types', function ()
            assert.has_error(function ()
                local c = pumas.CartesianVector()
                c:set(1)
            end, "bad argument #2 to 'set' (expected a Coordinates cdata, \z
                got a number)")
        end)

        it('should return an instance of self', function ()
            local c = pumas.CartesianVector()
            assert.is.equal(c, c:set(ffi.new('double [3]')))
        end)
    end)

    describe('transform', function ()
        it('should raise an error on missing self', function ()
            local c = pumas.CartesianVector()
            local t = pumas.UnitaryTransformation()
            assert.has_error(function ()
                c.transform(t)
            end, "bad argument #1 to 'transform' (expected a Coordinates \z
                cdata, got a UnitaryTransformation cdata)")
        end)

        it('should do nothing when same frame', function ()
            local c = pumas.CartesianVector(1, 2, 3)
            c:transform()
            assert.is.equal(c.x, 1)
            assert.is.equal(c.y, 2)
            assert.is.equal(c.z, 3)
            assert.is.equal(c.frame, nil)
        end)

        it('should transform to the simulation frame', function ()
            local t = util.Reflection()
            local c = pumas.CartesianVector(1, 2, 3, t)
            c:transform()
            assert.is.equal(c.x, -1)
            assert.is.equal(c.y, -2)
            assert.is.equal(c.z, -3)
            assert.is.equal(c.frame, nil)
        end)

        it('should transform from the simulation frame', function ()
            local c = pumas.CartesianVector(1, 2, 3)
            local t = util.Reflection()
            c:transform(t)
            assert.is.equal(c.x, -1)
            assert.is.equal(c.y, -2)
            assert.is.equal(c.z, -3)
            assert.is.equal(c.frame, t)
        end)

        it('should transform between two frames', function ()
            local t0 = util.Reflection()
            local c = pumas.CartesianVector(1, 2, 3, t0)
            local t1 = util.Reflection()
            c:transform(t1)
            assert.is.equal(c.x, 1)
            assert.is.equal(c.y, 2)
            assert.is.equal(c.z, 3)
            assert.is.equal(c.frame, t1)
        end)

        it('should return an instance of self', function ()
            local c = pumas.CartesianVector()
            assert.is.equal(c, c:transform())
        end)
    end)
end)
