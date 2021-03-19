local pumas = require('pumas')
local metatype = require('pumas.metatype')


describe('Element', function ()
    describe('constructor', function ()
        it('should return an Element with proper attributes', function ()
            local e0 = pumas.Element(1, 2, 3)
            assert.is.equal(1, e0.Z)
            assert.is.equal(2, e0.A)
            assert.is.equal(3, e0.I)
            assert.is.equal('Element', metatype(e0))

            local e1 = pumas.Element{Z = 1, A = 2, I = 3}
            assert.is.equal(1, e1.Z)
            assert.is.equal(2, e1.A)
            assert.is.equal(3, e1.I)
            assert.is.equal('Element', metatype(e1))

            local e2 = pumas.Element(e0)
            assert.is.equal(1, e2.Z)
            assert.is.equal(2, e2.A)
            assert.is.equal(3, e2.I)
            assert.is.equal('Element', metatype(e2))
        end)

        it('should raise errors on missing argument(s)', function ()
            assert.has_error(
                function () pumas.Element() end,
                "bad number of argument(s) to 'Element' \z
                (expected 1 or 3, got 0)")
            assert.has_error(
                function () pumas.Element(1) end,
                "bad argument #1 to 'Element' (expected a table, got a number)")
            assert.has_error(
                function () pumas.Element(1, 2) end,
                "bad number of argument(s) to 'Element' \z
                (expected 1 or 3, got 2)")
            assert.has_error(
                function () pumas.Element{Z = 1} end,
                "bad argument 'A' to 'Element' (expected a number, got nil)")
            assert.has_error(
                function () pumas.Element{Z = 1, A = 2} end,
                "bad argument 'I' to 'Element' (expected a number, got nil)")
            assert.has_error(
                function () pumas.Element{A = 2, I = 3} end,
                "bad argument 'Z' to 'Element' (expected a number, got nil)")
        end)
    end)
end)
