-------------------------------------------------------------------------------
-- Spec of the pumas.elastic metatable
-- Author: Valentin Niess
-- License: GNU LGPL-3.0
-------------------------------------------------------------------------------
local pumas = require('pumas')

describe('elastic', function ()
    it('should properly get function', function ()
        assert.is_not.equal(nil, pumas.elastic.dcs)
        assert.is_not.equal(nil, pumas.elastic.length)
    end)

    it('should cache fetched results', function ()
        assert.is.equal(pumas.elastic.dcs,
            pumas.elastic._functions['dcs'])
        assert.is.equal(pumas.elastic.length,
            pumas.elastic._functions['length'])
    end)

    it('should catch errors', function ()
        assert.has_error(
            function () return pumas.elastic[1] end,
            "bad key for 'elastic' (expected a string, got a number)")

        assert.has_error(
            function () return pumas.elastic.toto end,
            "'elastic' has no member named 'toto'")

        assert.has_error(
            function () pumas.elastic.toto = 1 end,
            "cannot modify 'elastic' for 'pumas'")
    end)
end)
