local pumas = require('pumas')
local metatype = require('pumas.metatype')
local util = require('spec.util')


describe('Material', function ()
    describe('constructor', function ()
        it('should return a Material with proper attributes', function ()
            local wH, wO, m = 0.111894, 0.888106

            m = pumas.Material{density = 1E+03, formula = 'H2O'}
            assert.is.equal(1E+03, m.density)
            assert.is.equal('liquid', m.state)
            assert.is.equal(2, util.getn(m.elements))
            assert.is.equal(util.round(wH, 3), util.round(m.elements['H'], 3))
            assert.is.equal(util.round(wO, 3), util.round(m.elements['O'], 3))
            assert.is.equal('Material', metatype(m))

            local elements = {H = wH, O = wO}
            m = pumas.Material{density = 1E+03, elements = elements,
                state = 'solid', I = 4}
            assert.is.equal(1E+03, m.density)
            assert.is.equal('solid', m.state)
            assert.is.not_equal(elements, m.elements)
            assert.is.equal(2, util.getn(m.elements))
            assert.is.equal(wH, m.elements['H'])
            assert.is.equal(wO, m.elements['O'])
            assert.is.equal(m.I, 4)
            assert.is.equal('Material', metatype(m))

            local data = require('pumas.data.materials')['Acetone']
            m = pumas.Material(data)
            assert.is.equal('Material', metatype(m))
            for k0, v0 in pairs(data) do
                if k0 == 'ZoA' then
                    assert.is.equal(util.round(v0), util.round(m[k0]))
                elseif k0 == 'elements' then
                    assert.is.not_equal(v0, m[k0])
                    for k1, v1 in pairs(v0) do
                        assert.is.equal(v1, m.elements[k1])
                    end
                else
                    assert.is.equal(v0, m[k0])
                end
            end

            local m0 = pumas.Material(m)
            assert.is.equal('Material', metatype(m0))
        end)

        it('should raise errors on bad argument(s)', function ()
            assert.has_error(
                function () pumas.Material() end,
                "bad number of argument(s) to 'Material' (expected 1, got 0)")
            assert.has_error(
                function () pumas.Material{density = 0} end,
                "bad argument 'density' to 'Material' \z
                (expected a positive number, got 0 kg / m^2)")
            assert.has_error(
                function () pumas.Material{density = 'toto'} end,
                "bad argument 'density' to 'Material' \z
                (expected a number, got a string)")
            assert.has_error(
                function () pumas.Material{density = 1} end,
                "bad argument(s) to 'Material' \z
                (missing 'composition' or 'formula')")
            assert.has_error(
                function () pumas.Material{formula = 'H2O'} end,
                "bad argument 'density' to 'Material' \z
                (expected a number, got nil)")
            assert.has_error(
                function () pumas.Material{elements = {Rk = 1}} end,
                "bad argument 'density' to 'Material' \z
                (expected a number, got nil)")
        end)
    end)
end)
