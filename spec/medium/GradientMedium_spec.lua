local pumas = require('pumas')
local metatype = require('pumas.metatype')
local util = require('spec.util')


describe('GradientMedium', function ()
    describe('constructor', function ()
        it('should set proper defaults', function ()
            local m = pumas.GradientMedium('StandardRock', {lambda = -1})
            assert.is.equal('StandardRock', m.material)
            assert.is.equal(-1, m.lambda)
            assert.is.equal('vertical', m.axis)
            assert.is.equal(0, m.magnet[0])
            assert.is.equal(0, m.magnet[1])
            assert.is.equal(0, m.magnet[2])
            assert.is.equal(pumas.materials['StandardRock'].density, m.rho0)
            assert.is.equal(0, m.z0)
            assert.is.equal('exponential', m.type)
        end)

        it('should properly set attributes', function ()
            local m = pumas.GradientMedium('StandardRock', {
                lambda = -1, axis = {0, 0, 1}, magnet = {1, 2, 3},
                rho0 = 1E+03, z0 = 100, ['type'] = 'linear'})
            assert.is.equal('StandardRock', m.material)
            assert.is.equal(-1, m.lambda)
            assert.is.equal(0, m.axis[0])
            assert.is.equal(0, m.axis[1])
            assert.is.equal(1, m.axis[2])
            assert.is.equal(1, m.magnet[0])
            assert.is.equal(2, m.magnet[1])
            assert.is.equal(3, m.magnet[2])
            assert.is.equal(1E+03, m.rho0)
            assert.is.equal(100, m.z0)
            assert.is.equal('linear', m.type)
        end)
    end)

    describe('attributes', function ()
        it('should be mutable', function ()
            local m = pumas.GradientMedium('StandardRock', {lambda = -1})

            m.lambda = -2
            assert.is.equal(-2, m.lambda)

            m.axis = {0, 0, 1}
            assert.is.equal(0, m.axis[0])
            assert.is.equal(0, m.axis[1])
            assert.is.equal(1, m.axis[2])

            m.magnet = {1, 2, 3}
            assert.is.equal(1, m.magnet[0])
            assert.is.equal(2, m.magnet[1])
            assert.is.equal(3, m.magnet[2])

            m.rho0 = 1E+03
            assert.is.equal(1E+03, m.rho0)

            m.z0 = 100
            assert.is.equal(100, m.z0)

            m.type = 'linear'
            assert.is.equal('linear', m.type)
        end)
    end)

    describe('density', function ()
        it('should be correct', function ()
            local m = pumas.GradientMedium('StandardRock', {
                lambda = -1000, axis = {0, 0, 1}, ['type'] = 'linear'})
            local s = pumas.State{position = {0, 0, 500}}
            local c = pumas.CartesianPoint(s.position)

            assert.is.equal(1.325E+03, m:density(s))
            assert.is.equal(1.325E+03, m:density(s.position))
            assert.is.equal(1.325E+03, m:density(c))
            assert.is.equal(1.325E+03, m:density({0, 0, 500}))

            m.axis = 'vertical'
            c = pumas.GeodeticPoint(45, 3, 500)
            assert.is.equal(1.325E+03, util.round(m:density(c), 7))

            m.type = 'exponential'
            assert.is.equal(
                util.round(2.65E+03 * math.exp(-0.5), 3),
                util.round(m:density(c), 3))
        end)
    end)
end)
