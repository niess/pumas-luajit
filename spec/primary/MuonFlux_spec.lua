-------------------------------------------------------------------------------
-- Spec of the pumas.MuonFlux metatype
-- Author: Valentin Niess
-- License: GNU LGPL-3.0
-------------------------------------------------------------------------------
local pumas = require('pumas')
local util = require('spec.util')


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
            state = pumas.State()
            state.position[2] = 1000
            state.direction[2] = -1
            local f2 = flux1:spectrum(state.energy, 1, state.charge, 500)
            local ok1, f3 = flux1:sample(state)
            assert.is.equal(true, ok1)
            assert.is.equal(f2, f3)
        end)

        it('should set model properly', function ()
            for _, model in ipairs{'chirkin', 'gaisser', 'gccly', 'mceq',
                util.dummy_flux} do
                assert.is.equal(pumas.MuonFlux{model = model}['model'], model)
            end
        end)

        it('should set normalisation properly', function ()
            for _, model in ipairs{'chirkin', 'gaisser', 'gccly', 'mceq',
                util.dummy_flux} do
                local flux0 = pumas.MuonFlux{model = model, normalisation = 2}
                local flux1 = pumas.MuonFlux{model = model}
                assert.is.equal(2, flux0:spectrum(1, 1) / flux1:spectrum(1, 1))
            end
        end)

        it('should set gamma properly', function ()
            for _, model in ipairs{'chirkin', 'gaisser', 'gccly'} do
                local flux0 = pumas.MuonFlux{model = model, gamma = 2}
                local flux1 = pumas.MuonFlux{model = model, gamma = 3}
                local e = 1E+12
                local r = flux1:spectrum(e, 1) * e / flux0:spectrum(e, 1)
                assert.is.equal(1, util.round(r, 2))
            end
        end)

        it('should set charge ratio properly', function ()
            for _, model in ipairs{'chirkin', 'gaisser', 'gccly'} do
                local flux0 = pumas.MuonFlux{model = model, charge_ratio = 2}
                local r = flux0:spectrum(1, 1, 1) / flux0:spectrum(1, 1, -1)
                assert.is.equal(2, r)
            end
        end)

        it('should load a flux table properly', function()
            local data = util.muon_flux_data()..'/flux-mceq-yfm-gsf-usstd.table'
            local flux0 = pumas.MuonFlux{model = data}
            local flux1 = pumas.MuonFlux{model = 'mceq'}

            local f0 = flux0:spectrum(2, 1, 3, 4)
            local f1 = flux1:spectrum(2, 1, 3, 4)
            assert.is.equal(util.round(f1, 7), util.round(f0, 7))
        end)
    end)

    describe('sample', function ()
        it('should update the Monte Carlo weight', function ()
            local flux = pumas.MuonFlux{axis = {0, 0, 1}, altitude = 0}
            local state = pumas.State()
            state.direction = {0, 0, -1}
            local ok, f0 = flux:sample(state)
            local f1 = flux:spectrum(state.energy, 1, state.charge)
            assert.is.equal(true, ok)
            assert.is.equal(f1, f0)
            assert.is.equal(f1, state.weight)
        end)

        it('should check the altitude if provided', function ()
            local flux = pumas.MuonFlux{axis = {0, 0, 1}, altitude = 1000}
            local state = pumas.State()
            local ok = flux:sample(state)
            assert.is.equal(false, ok)
        end)
    end)

    describe('spectrum', function ()
        it('should accept different altitudes', function ()
            local flux = pumas.MuonFlux()
            local f0 = flux:spectrum(1, 1, nil, 0)
            local f1 = flux:spectrum(1, 1, nil, 1000)
            assert.is.equal(true, f0 < f1)
        end)
    end)
end)
