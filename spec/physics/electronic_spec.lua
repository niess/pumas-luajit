-------------------------------------------------------------------------------
-- Spec of the pumas.electronic metatable
-- Author: Valentin Niess
-- License: GNU LGPL-3.0
-------------------------------------------------------------------------------
local pumas = require('pumas')
local util = require('spec.util')

describe('electronic', function ()
    it('should properly get function', function ()
        assert.is_not.equal(nil, pumas.electronic.dcs)
        assert.is_not.equal(nil, pumas.electronic.density_effect)
    end)

    it('should cache fetched results', function ()
        assert.is.equal(pumas.electronic.dcs,
            pumas.electronic._functions['dcs'])
        assert.is.equal(pumas.electronic.density_effect,
            pumas.electronic._functions['density_effect'])
    end)

    it('should catch errors', function ()
        assert.has_error(
            function () return pumas.electronic[1] end,
            "bad key for 'electronic' (expected a string, got a number)")

        assert.has_error(
            function () return pumas.electronic.toto end,
            "'electronic' has no member named 'toto'")

        assert.has_error(
            function () pumas.electronic.toto = 1 end,
            "cannot modify 'electronic' for 'pumas'")

        assert.has_error(
            function () pumas.electronic.density_effect(1) end,
            "bad argument #2 to 'density_effect' \z
                (expected a number, got nil)")
    end)

    describe('density_effect', function ()
        it('should accept scalar inputs', function ()
            local delta = pumas.electronic.density_effect(
                1, 1, 19.2E-09, 1.205, 100)
            assert.is.equal(util.round(2.338, 3), util.round(delta, 3))
        end)

        it('should accept vector inputs', function ()
            local delta = pumas.electronic.density_effect(
                {1, 11}, {1, 22}, {0.5, 0.5}, 19.2E-09, 1.3125E+03, 1)
            assert.is.equal(util.round(0.694, 3), util.round(delta, 3))
        end)
    end)

    describe('energy_loss', function ()
        it('should accept scalar inputs', function ()
            local de = pumas.electronic.energy_loss(
                11, 22, 136.4E-09, 2.65E+03, 0.10566, 1)
            assert.is.equal(util.round(1.81E-04, 6), util.round(de, 6))
        end)

        it('should accept vector inputs', function ()
            local de = pumas.electronic.energy_loss(
                {1, 11}, {1, 22}, {0.5, 0.5}, 136.4E-09, 1.3125E+03, 0.10566, 1)
            assert.is.equal(util.round(2.78E-04, 6), util.round(de, 6))
        end)
    end)
end)
