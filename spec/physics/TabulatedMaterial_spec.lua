local pumas = require('pumas')
local metatype = require('pumas.metatype')
local util = require('spec.util')


-- Load the examples physics
local physics = pumas.Physics('share/materials/standard')
local materials = {
    physics.materials['StandardRock'], physics.materials['Water'],
    physics.composites['WetRock']}


describe('TabulatedMaterial', function ()
    it('attributes should be correct', function ()
        local name = {'StandardRock', 'Water', 'WetRock'}
        local composite = {false, false, true}
        for i, m in ipairs(materials) do
            assert.is.equal(name[i], m.name)
            assert.is.equal(physics, m.physics)
            assert.is.equal(composite[i], m.composite)

            if m.composite then
                assert.is.equal('CompositeMaterials', metatype(m.materials))

                assert.is.equal('number', type(m.I))
                assert.is.equal('number', type(m.ZoA))
                assert.is.equal(nil, m.state)
                assert.is.equal(nil, m.a)
                assert.is.equal(nil, m.k)
                assert.is.equal(nil, m.x0)
                assert.is.equal(nil, m.x1)
                assert.is.equal(nil, m.Cbar)
                assert.is.equal(nil, m.delta0)
            else
                local m0 = pumas.materials[name[i]]
                assert.is.equal(nil, m.materials)
                assert.is.equal(nil, m.state)
                assert.is.equal(m0.I, m.I)
                assert.is.equal(util.round(m0.ZoA, 7), util.round(m.ZoA, 7))
                assert.is.equal(m0.a, m.a)
                assert.is.equal(m0.k, m.k)
                assert.is.equal(m0.x0, m.x0)
                assert.is.equal(m0.x1, m.x1)
                assert.is.equal(m0.Cbar, m.Cbar)
                assert.is.equal(m0.delta0, m.delta0)
            end

            assert.is.equal('Readonly', getmetatable(m.elements))

            assert.is.equal('Readonly', getmetatable(m.table))
            for _, mode in ipairs{'csda', 'hybrid', 'detailed'} do
                local t = m.table[mode]
                assert.is.equal('Readonly', getmetatable(t))
                for _, property in ipairs{'kinetic_energy', 'energy_loss',
                    'grammage', 'proper_time'} do
                    local tt = t[property]
                    assert.is.equal('Readonly', getmetatable(tt))
                    assert.is.equal(146, #tt)
                end
                if mode == 'csda' then
                    assert.is.equal(nil, t['cross_section'])
                else
                    local tt = t['cross_section']
                    assert.is.equal('Readonly', getmetatable(tt))
                    assert.is.equal(146, #tt)
                end
            end
        end
    end)

    it('attributes should not be mutable (except table)', function ()
        for _, m in ipairs(materials) do
            assert.has_error(function () m.density = 1E+03 end,
                "cannot modify 'density' for 'TabulatedMaterial'")
            assert.has_error(function () m.physics = nil end,
                "cannot modify 'physics' for 'TabulatedMaterial'")
            assert.has_error(function () m.name = nil end,
                "cannot modify 'name' for 'TabulatedMaterial'")
            assert.has_error(function () m.composite = nil end,
                "cannot modify 'composite' for 'TabulatedMaterial'")
            assert.has_error(function () m.materials = nil end,
                "cannot modify 'materials' for 'TabulatedMaterial'")
            assert.has_error(function () m.elements = nil end,
                "cannot modify 'elements' for 'TabulatedMaterial'")
        end
    end)

    it('atomic elements fractions should be correct', function ()
        local wH, wO, e = 0.111894, 0.888106

        e = physics.materials['StandardRock'].elements
        assert.is.equal('Readonly', getmetatable(e))
        assert.is.equal(1, util.getn(e))
        assert.is.equal(1, e['Rk'])

        e = physics.materials['Water'].elements
        assert.is.equal('Readonly', getmetatable(e))
        assert.is.equal(2, util.getn(e))
        assert.is.equal(wH, util.round(e['H'], 6))
        assert.is.equal(wO, util.round(e['O'], 6))

        e = physics.composites['WetRock'].elements
        assert.is.equal('Readonly', getmetatable(e))
        assert.is.equal(3, util.getn(e))
        assert.is.equal(0.7, e['Rk'])
        assert.is.equal(0.3, util.round(e['H'] / wH))
        assert.is.equal(0.3, util.round(e['O'] / wO))

        assert.has_error(function () e['H'] = 0.1 end,
            "cannot modify 'H' for 'elements'")
    end)

    it('should have the right metatype', function ()
        for _, m in ipairs(materials) do
            assert.is.equal('TabulatedMaterial', metatype(m))
        end
    end)

    describe('cross_section', function ()
        it('should be consistent', function ()
            for _, m in ipairs(materials) do
                assert.is.equal(m.table.hybrid.cross_section[50],
                    m:cross_section(1))
            end
        end)
    end)

    describe('energy_loss', function ()
        it('should be consistent', function ()
            for _, m in ipairs(materials) do
                assert.is.equal(m.table.csda.energy_loss[50],
                    m:energy_loss(1))
                assert.is.equal(m.table.hybrid.energy_loss[50],
                    m:energy_loss(1, 'hybrid'))
            end
        end)
    end)

    describe('grammage', function ()
        it('should be consistent', function ()
            for _, m in ipairs(materials) do
                assert.is.equal(m.table.csda.grammage[50],
                    m:grammage(1))
                assert.is.equal(m.table.hybrid.grammage[50],
                    m:grammage(1, 'hybrid'))
            end
        end)
    end)

    describe('magnetic rotation', function ()
        it('should return some number', function ()
            for _, m in ipairs(materials) do
                assert.is.equal('number', type(m:magnetic_rotation(1)))
            end
        end)
    end)

    describe('proper_time', function ()
        it('should be consistent', function ()
            for _, m in ipairs(materials) do
                assert.is.equal(m.table.csda.proper_time[50],
                    m:proper_time(1))
                assert.is.equal(m.table.hybrid.proper_time[50],
                    m:proper_time(1, 'hybrid'))
            end
        end)
    end)

    describe('scattering length', function ()
        it('should return some number', function ()
            for _, m in ipairs(materials) do
                assert.is.equal('number', type(m:scattering_length(1)))
            end
        end)
    end)
end)
