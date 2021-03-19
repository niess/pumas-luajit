-------------------------------------------------------------------------------
-- Spec of the pumas.UnitaryTransformation metatype
-- Author: Valentin Niess
-- License: GNU LGPL-3.0
-------------------------------------------------------------------------------
local pumas = require('pumas')
local metatype = require('pumas.metatype')
local util = require('spec.util')


describe('UnitaryTransformation', function ()
    describe('constructor', function ()
        it('should default to the identity transformation', function ()
            local transformations = {
                pumas.UnitaryTransformation(),
                pumas.UnitaryTransformation{translation = {0, 0, 0}}}

            for _, t in ipairs(transformations) do
                util.IdentityTransformation.check(t)
            end
        end)

        it('should properly set attributes', function ()
            local t = util.DummyTransformation()
            util.DummyTransformation.check(t)
        end)

        it('should properly set keyword attributes', function ()
            local t = pumas.UnitaryTransformation{
                translation = {1, 2, 3},
                matrix = {{4, 5, 6}, {7, 8, 9}, {10, 11, 12}}}
            util.DummyTransformation.check(t)
        end)

        it('should initialise from another instance', function ()
            local t0 = util.DummyTransformation()
            local t1 = pumas.UnitaryTransformation(t0)
            util.DummyTransformation.check(t1)
        end)

        it('should return a UnitaryTransformation table', function ()
            local t = pumas.UnitaryTransformation()
            assert.is.equal(metatype(t), 'UnitaryTransformation')
        end)
    end)

    describe('clone', function ()
        it('should raise an error on missing self', function ()
            local c = pumas.UnitaryTransformation()
            assert.has_error(function ()
                c.clone()
            end, "bad argument #1 to 'clone' (expected a \z
                UnitaryTransformation cdata, got nil)")
        end)

        it('should return a copy', function ()
            local t0 = util.DummyTransformation()
            local t1 = pumas.UnitaryTransformation(t0)
            assert.is_not.equal(t0, t1)
            util.DummyTransformation.check(t1)
        end)
    end)

    describe('from_euler', function ()
        it('should raise an error on missing self', function ()
            local t = pumas.UnitaryTransformation()
            assert.has_error(function ()
                t.from_euler('XY', 0, 0)
            end, "bad argument #1 to 'from_euler' (expected a \z
                UnitaryTransformation cdata, got a string)")
        end)

        it('should raise an error on bad axis', function ()
            local t = pumas.UnitaryTransformation()

            assert.has_error(function ()
                t:from_euler('XTZ', 0, 0, 0)
            end, "bad argument #2 to 'from_euler' (bad axis 'XTZ')")

            assert.has_error(function ()
                t:from_euler('xYZ', 0, 0, 0)
            end, "bad argument #2 to 'from_euler' (bad axis 'xYZ')")
        end)

        it('should raise an error on wrong number of angles', function ()
            local t = pumas.UnitaryTransformation()

            assert.has_error(function ()
                t:from_euler('XYZ', 0, 0)
            end, "bad number of argument(s) to 'from_euler' \z
                (expected 5, got 4)")

            assert.has_error(function ()
                t:from_euler('X', 0, 0)
            end, "bad number of argument(s) to 'from_euler' \z
                (expected 3, got 4)")
        end)

        it('should return an instance of self', function ()
            local t = pumas.UnitaryTransformation()
            assert.is.equal(t, t:from_euler('X', 0))
        end)

        it('should rotate around a single axis', function ()
            local t = pumas.UnitaryTransformation()

            t:from_euler('X', 0.25 * math.pi)
            util.EulerMatrix(0, 0, 0.25 * math.pi):check(t)

            t:from_euler('Y', 0.5 * math.pi)
            util.EulerMatrix(0, 0.5 * math.pi):check(t)

            t:from_euler('Z', 0.75 * math.pi)
            util.EulerMatrix(0.75 * math.pi):check(t)
        end)

        it('should rotate around several intrinsic axis', function ()
            local t = pumas.UnitaryTransformation()

            t:from_euler('XY', 0.25 * math.pi, 0.5 * math.pi)
            util.EulerMatrix(0, 0.5 * math.pi, 0.25 * math.pi):check(t)

            t:from_euler('YZ', 0.5 * math.pi, 0.75 * math.pi)
            util.EulerMatrix(0.75 * math.pi, 0.5 * math.pi):check(t)

            t:from_euler('XYZ', 0.25 * math.pi, 0.5 * math.pi, 0.75 * math.pi)
            util.EulerMatrix(
                0.75 * math.pi, 0.5 * math.pi, 0.25 * math.pi):check(t)
        end)

        it('should rotate around several extrinsic axis', function ()
            local t = pumas.UnitaryTransformation()

            t:from_euler('yx', 0.5 * math.pi, 0.25 * math.pi)
            util.EulerMatrix(0, 0.5 * math.pi, 0.25 * math.pi):check(t)

            t:from_euler('zy', 0.75 * math.pi, 0.5 * math.pi)
            util.EulerMatrix(0.75 * math.pi, 0.5 * math.pi):check(t)

            t:from_euler('zyx', 0.75 * math.pi, 0.5 * math.pi, 0.25 * math.pi)
            util.EulerMatrix(
                0.75 * math.pi, 0.5 * math.pi, 0.25 * math.pi):check(t)
        end)
    end)
end)
