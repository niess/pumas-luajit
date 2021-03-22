-------------------------------------------------------------------------------
-- Spec of the pumas.Readonly metatype
-- Author: Valentin Niess
-- License: GNU LGPL-3.0
-------------------------------------------------------------------------------
local pumas = require('pumas')
local metatype = require('pumas.metatype')
local readonly = require('pumas.readonly')


describe('Readonly', function ()
    describe('constructor', function ()
        it('should create a proper metatable', function ()
            local t = {1, x = 2}
            local r = readonly.Readonly(t)
            assert.is.equal('table', metatype(r))
            assert.is.equal(t[1], r[1])
            assert.is.equal(t.x, r.x)
            assert.is_nil(r[2])
            assert.is_nil(r.y)
            assert.is.equal('Readonly', getmetatable(r))
        end)

        it('should catch errors', function ()
            assert.has_error(
                function () readonly.Readonly() end,
                "bad argument #1 to 'Readonly' (expected a raw table, got nil)")

            assert.has_error(
                function () readonly.Readonly(pumas.State()) end,
                "bad argument #1 to 'Readonly' \z
                (expected a raw table, got a State table)")

            assert.has_error(
                function () readonly.Readonly({}, 1) end,
                "bad argument #2 to 'Readonly' \z
                (expected a string, got a number)")

            assert.has_error(
                function () readonly.Readonly({}, 'table', 1) end,
                "bad argument #3 to 'Readonly' \z
                (expected a string, got a number)")
        end)

        it('should be readonly', function ()
            local r = readonly.Readonly({1, x = 2}, 'Test')

            assert.has_error(
                function () r[1] = 0 end,
                "cannot modify entry #1 for 'Test'")

            assert.has_error(
                function () r.x = 0 end,
                "cannot modify 'x' for 'Test'")
        end)

        it('should return a proper length', function ()
            local r = readonly.Readonly({1, 2, 3, x = 4}, 'Test')
            assert.is.equal(3, #r)
        end)
    end)

    describe('ipairs', function ()
        it('should iterate properly', function ()
            local r = readonly.Readonly({1, 2, 3, x = 4}, 'Test')
            for i, v in r:ipairs() do
                assert.is.equal(r[i], v)
            end
        end)
    end)

    describe('pairs', function ()
        it('should iterate properly', function ()
            local r = readonly.Readonly({1, 2, 3, x = 4}, 'Test')
            for k, v in r:pairs() do
                assert.is.equal(r[k], v)
            end
        end)
    end)
end)
