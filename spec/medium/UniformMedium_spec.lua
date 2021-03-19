-------------------------------------------------------------------------------
-- Spec of the pumas.UniformMedium metatype
-- Author: Valentin Niess
-- License: GNU LGPL-3.0
-------------------------------------------------------------------------------
local pumas = require('pumas')


describe('UniformMedium', function ()
    describe('constructor', function ()
        it('should set proper defaults', function ()
            local m = pumas.UniformMedium('StandardRock')
            assert.is.equal('StandardRock', m.material)
            assert.is.equal(2.65E+03, m.density)
            assert.is.equal(0, m.magnet[0])
            assert.is.equal(0, m.magnet[1])
            assert.is.equal(0, m.magnet[2])
        end)

        it('should properly set attributes', function ()
            local m = pumas.UniformMedium('StandardRock', 2.0E+03, {1, 2, 3})
            assert.is.equal('StandardRock', m.material)
            assert.is.equal(2.0E+03, m.density)
            assert.is.equal(1, m.magnet[0])
            assert.is.equal(2, m.magnet[1])
            assert.is.equal(3, m.magnet[2])
        end)
    end)

    describe('attributes', function ()
        it('should be mutable', function ()
            local m = pumas.UniformMedium('StandardRock')

            m.density = 2E+03
            assert.is.equal(2E+03, m.density)

            m.magnet = {1, 2, 3}
            assert.is.equal(1, m.magnet[0])
            assert.is.equal(2, m.magnet[1])
            assert.is.equal(3, m.magnet[2])

            m.magnet = pumas.CartesianVector(2, 3, 1)
            assert.is.equal(2, m.magnet[0])
            assert.is.equal(3, m.magnet[1])
            assert.is.equal(1, m.magnet[2])
        end)
    end)
end)
