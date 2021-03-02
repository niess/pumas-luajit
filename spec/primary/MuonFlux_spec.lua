local pumas = require('pumas')


describe('MuonFlux', function ()
    describe('constructor', function ()
        it('should have defaults', function ()
            local flux = pumas.MuonFlux()
            assert.is.equal('mceq', flux.model)
            assert.is.equal(nil, flux.altitude)
        end)

        it('should set altitude and sample accordingly', function ()
            local flux = pumas.MuonFlux{altitude = 1000}
            assert.is.equal('mceq', flux.model)
            assert.is.equal(1000, flux.altitude)

            local state = pumas.State()
            state.position = pumas.GeodeticPoint(45, 3, 1000)
            local frame = pumas.LocalFrame(state.position)
            state.direction = pumas.HorizontalVector(0, 0, 1, frame)
            local ok, f0 = flux:sample(state)
            local f1 = flux:spectrum(state.energy, 1, state.charge)
            assert.is.equal(true, ok)
            assert.is.equal(f1, f0)

            state.position = pumas.GeodeticPoint(45, 3, 0)
            ok = flux:sample(state)
            assert.is.equal(false, ok)
        end)

        it('should set axis and sample accordingly', function ()
            local flux = pumas.MuonFlux{altitude = 1000, axis = {0, 0, 1}}

            local state = pumas.State()
            state.position[2] = 1000
            state.direction[2] = -1
            local f1 = flux:spectrum(state.energy, 1, state.charge)
            local ok, f0 = flux:sample(state)
            assert.is.equal(true, ok)
            assert.is.equal(f1, f0)

            state.position[2] = 0
            ok = flux:sample(state)
            assert.is.equal(false, ok)
        end)

        it('should set origin and sample accordingly', function ()
            local flux0 = pumas.MuonFlux{origin = 500}
            local state = pumas.State()
            state.position = pumas.GeodeticPoint(45, 3, 1000)
            local frame = pumas.LocalFrame(state.position)
            state.direction = pumas.HorizontalVector(0, 0, 1, frame)
            local ok, f0 = flux0:sample(state)
            local f1 = flux0:spectrum(state.energy, 1, state.charge, 500)
            assert.is.equal(true, ok)
            assert.is.equal(f1, f0)

            local flux1 = pumas.MuonFlux{axis = {0, 0, 1}, origin = {0, 0, 500}}
            local state = pumas.State()
            state.position[2] = 1000
            state.direction[2] = -1
            local f1 = flux1:spectrum(state.energy, 1, state.charge, 500)
            local ok, f0 = flux1:sample(state)
            assert.is.equal(true, ok)
            assert.is.equal(f1, f0)
        end)

    end)

    describe('spectrum', function ()
        it('should work ...', function ()
        end)
    end)
end)
