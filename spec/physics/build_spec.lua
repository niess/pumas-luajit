-------------------------------------------------------------------------------
-- Spec of the pumas.build function
-- Author: Valentin Niess
-- License: GNU LGPL-3.0
-------------------------------------------------------------------------------
local pumas = require('pumas')


-- Generate the physics tables for the tests
-- Note that we do not explicitly test this stage. It is validated through
-- other function, e.g. when instanciating a Physics object.
require('spec.physics')


describe('build', function ()
    it('should raise proper errors', function ()
        assert.has_error(
            function () pumas.build() end,
            "bad number of argument(s) to 'build' (expected 1, got 0)")

        assert.has_error(
            function () pumas.build('toto') end,
            "bad argument #1 to 'build' (expected a table, got a string)")

        assert.has_error(
            function () pumas.build{} end,
            "bad argument 'materials' to 'build' (expected a table, got nil)")

        assert.has_error(
            function () pumas.build{toto = true} end,
            "bad argument 'toto' to 'build' (unknown argument)")

        assert.has_error(
            function () pumas.build{materials = {1}} end,
            "bad argument 'materials[1]' to 'build' \z
            (expected a string, got a number)")

        assert.has_error(
            function () pumas.build{materials = {'Water'}, cutoff = 'toto'} end,
            "bad argument 'cutoff' to 'build' \z
            (expected a number, got a string)")

        assert.has_error(
            function () pumas.build{materials = {Toto = 1}} end,
            "bad argument 'materials[Toto]' to 'build' \z
            (expected a Material table, got a number)")
    end)
end)
