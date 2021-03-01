local pumas = require('pumas')


describe('MuonFlux', function ()
    describe('constructor', function ()
        it('should have defaults', function ()
            local flux = pumas.MuonFlux()
            assert.is.equal('mceq', flux.model)
            assert.is.equal(nil, flux.altitude)
        end)

        it('should have defaults', function ()
            local flux = pumas.MuonFlux()
            assert.is.equal('mceq', flux.model)
            assert.is.equal(nil, flux.altitude)
        end)
    end)

    describe('spectrum', function ()
        it('should work ...', function ()
        end)
    end)
end)
