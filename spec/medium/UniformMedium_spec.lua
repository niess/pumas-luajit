-------------------------------------------------------------------------------
-- Spec of the pumas.UniformMedium metatype
-- Author: Valentin Niess
-- License: GNU LGPL-3.0
-------------------------------------------------------------------------------
local pumas = require('pumas')
local metatype = require('pumas.metatype')


describe('UniformMedium', function ()
    describe('constructor', function ()
        it('should set proper defaults', function ()
            local m = pumas.UniformMedium('StandardRock')
            assert.is.equal('StandardRock', m.material)
            assert.is.equal(2.65E+03, m.density)
            assert.is.equal(0, m.magnet[0])
            assert.is.equal(0, m.magnet[1])
            assert.is.equal(0, m.magnet[2])
            assert.is_nil(m.name)
            assert.is.equal('Medium', metatype(m))
        end)

        it('should properly set attributes', function ()
            local m = pumas.UniformMedium(
                'StandardRock', 2.0E+03, {1, 2, 3}, 'rock')
            assert.is.equal('StandardRock', m.material)
            assert.is.equal(2.0E+03, m.density)
            assert.is.equal(1, m.magnet[0])
            assert.is.equal(2, m.magnet[1])
            assert.is.equal(3, m.magnet[2])
            assert.is.equal('rock', m.name)
            assert.is.equal('Medium', metatype(m))
        end)

        it('should catch errors', function ()
            assert.has_error(
                function () pumas.UniformMedium(1) end,
                "bad argument #1 to 'UniformMedium' \z
                (expected a string, got a number)")

            assert.has_error(
                function () pumas.UniformMedium('Water', 'toto') end,
                "bad argument #2 to 'UniformMedium' \z
                (expected a number, got a string)")

            assert.has_error(
                function () pumas.UniformMedium('Water', nil, 'toto') end,
                "bad argument #3 to 'UniformMedium'")

            assert.has_error(
                function () pumas.UniformMedium('Water', nil, nil, 1) end,
                "bad argument #4 to 'UniformMedium' \z
                (expected a string, got a number)")
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

        it('should have an optional name', function ()
            local m = pumas.UniformMedium('StandardRock')
            assert.is_nil(m.name)

            m.name = 'Test'
            assert.is.equal('Test', m.name)

            m.name = nil
            assert.is_nil(m.name)
        end)

        it('should catch errors', function ()
            local m = pumas.UniformMedium('StandardRock')

            assert.has_error(
                function () m.name = 1 end,
                "bad attribute 'name' for 'UniformMedium' \z
                (expected a string, got a number)")

            assert.has_error(
                function () m.toto = 1 end,
                "'UniformMedium' has no member named 'toto'")
        end)
    end)
end)
