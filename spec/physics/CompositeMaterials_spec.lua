-------------------------------------------------------------------------------
-- Spec of the pumas.CompositeMaterial metatype
-- Author: Valentin Niess
-- License: GNU LGPL-3.0
-------------------------------------------------------------------------------
local metatype = require('pumas.metatype')
local physics = require('spec.physics')


describe('CompositeMaterials', function ()
    it('fractions should be correct', function ()
        local c = physics.muon.composites['WetRock'].materials
        assert.is.equal(0.7, c['StandardRock'])
        assert.is.equal(0.3, c['Water'])
    end)

    it('should have a fixed structure', function ()
        local c = physics.muon.composites['WetRock'].materials
        assert.has_error(function () c['Honey'] = 1 end,
            "'CompositeMaterials' has no member named 'Honey'")
    end)

    it('should let one change the fractions values', function ()
        local c = physics.muon.composites['WetRock'].materials

        c['StandardRock'] = 0.2
        assert.is.equal(0.2, c['StandardRock'])

        c['Water'] = 0.8
        assert.is.equal(0.8, c['Water'])
    end)

    it('should update when changing the fractions values', function ()
        local t = physics.muon.composites['WetRock']
        local c = t.materials
        local density = t.density
        local elements_ref = t.elements
        local elements = {}
        for k, v in t.elements:pairs() do elements[k] = v end
        local dedx = t:energy_loss(1)
        local grammage_ref = t.table.csda.grammage
        local grammage = t.table.csda.grammage[3]

        c['StandardRock'] = 0.7
        c['Water'] = 0.3
        assert.is.not_equal(density, t.density)
        assert.is.equal(c, t.materials)
        assert.is.equal(elements_ref, t.elements)
        assert.is.equal(elements_ref['H'], t.elements['H'])
        assert.is.equal(elements_ref['O'], t.elements['O'])
        assert.is.equal(elements_ref['Rk'], t.elements['Rk'])
        assert.is.not_equal(elements['H'], t.elements['H'])
        assert.is.not_equal(elements['O'], t.elements['O'])
        assert.is.not_equal(elements['Rk'], t.elements['Rk'])
        assert.is.equal(0.7, t.elements['Rk'])
        assert.is.equal(0.3, t.elements['H'] + t.elements['O'])
        assert.is.not_equal(dedx, t:energy_loss(1))
        assert.is.equal(grammage_ref, t.table.csda.grammage)
        assert.is.not_equal(grammage, t.table.csda.grammage[3])
    end)

    it('should be iterable with pairs', function ()
        local c = physics.muon.composites['WetRock'].materials

        local n, t = 0, {}
        for material, fraction in c:pairs() do
            n = n + 1
            t[material] = fraction
        end

        assert.is.equal(2, n)
        assert.is.equal(t['StandardRock'], c['StandardRock'])
        assert.is.equal(t['Water'], c['Water'])
    end)

    it('should have the right metatype', function ()
        local c = physics.muon.composites['WetRock'].materials
        assert.is.equal('CompositeMaterials', metatype(c))
    end)
end)
