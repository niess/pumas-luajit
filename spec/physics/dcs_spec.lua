-------------------------------------------------------------------------------
-- Spec of the pumas.dcs metatable
-- Author: Valentin Niess
-- License: GNU LGPL-3.0
-------------------------------------------------------------------------------
local pumas = require('pumas')

describe('dcs', function ()
    it('should have a default getter', function ()
        assert.is.equal(pumas.dcs['bremsstrahlung KKP'],
            pumas.dcs.bremsstrahlung)
        assert.is.equal(pumas.dcs['pair_production KKP'],
            pumas.dcs.pair_production)
        assert.is.equal(pumas.dcs['photonuclear DRSS'],
            pumas.dcs.photonuclear)
    end)

    it('should cache fetched results', function ()
        assert.is.equal(pumas.dcs['bremsstrahlung KKP'],
            pumas.dcs._lib['bremsstrahlung KKP'])
    end)

    it('should get alternative models', function ()
        local dcs0, dcs1

        dcs0 = pumas.dcs['bremsstrahlung ABB']
        assert.not_nil(dcs0)
        assert.is.not_equal(pumas.dcs.bremsstrahlung, dcs0)

        dcs1 = pumas.dcs['bremsstrahlung SSR']
        assert.not_nil(dcs1)
        assert.is.not_equal(pumas.dcs.bremsstrahlung, dcs1)
        assert.is.not_equal(dcs0, dcs1)

        dcs0 = pumas.dcs['pair_production SSR']
        assert.not_nil(dcs0)
        assert.is.not_equal(pumas.dcs.pair_production, dcs0)
    end)

    it('should catch get errors', function ()
        assert.has_error(
            function () return pumas.dcs[1] end,
            "bad key for 'dcs' (expected a string, got a number)")

        assert.has_error(
            function () return pumas.dcs.toto end,
            "bad attribute 'toto' for 'dcs' (invalid process)")

        assert.has_error(
            function () return pumas.dcs['bremsstrahlung TOTO'] end,
            "bad key for 'dcs' \z
            (model TOTO not found for bremsstrahlung process)")
    end)

    it('should register new models', function ()
        local dummy = function () return 0 end
        pumas.dcs['bremsstrahlung DUMMY'] = dummy

        assert.is.equal(dummy, pumas.dcs._lib['bremsstrahlung DUMMY'])
        assert.is.equal(dummy, pumas.dcs['bremsstrahlung DUMMY'])
    end)

    it('should catch register errors', function ()
        local dummy = function () return 0 end

        assert.has_error(
            function () pumas.dcs[1] = dummy end,
            "bad key for 'dcs' (expected a string, got a number)")

        assert.has_error(
            function () pumas.dcs.toto = dummy end,
            "bad attribute 'toto' for 'dcs' (invalid process)")

        assert.has_error(
            function () pumas.dcs['bremsstrahlung'] = dummy end,
            "bad key for 'dcs' (missing model name for bremsstrahlung process)")

        assert.has_error(
            function () pumas.dcs['bremsstrahlung KKP'] = dummy end,
            "bad key for 'dcs' \z
            (model KKP already registered for bremsstrahlung process)")

        assert.has_error(
            function () pumas.dcs['bremsstrahlung DUMMY'] = dummy end,
            "bad key for 'dcs' \z
            (model DUMMY already registered for bremsstrahlung process)")
    end)
end)
