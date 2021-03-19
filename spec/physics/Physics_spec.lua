local pumas = require('pumas')
local metatype = require('pumas.metatype')
local util = require('spec.util')


-- Load the examples physics
require('spec/build-physics')
local physics = pumas.Physics('share/materials/test/muon')


describe('Physics', function ()
    describe('constructor', function ()
        it('should also load from a MDF', function ()
            local p = pumas.Physics{
                mdf = 'share/materials/test/tau/materials.xml',
                dedx = 'share/materials/test/tau',
                particle = 'tau'}
            assert.is.equal('tau', (p.particle.name))
            assert.is.equal(pumas.constants.TAU_MASS, (p.particle.mass))
            assert.is.equal(pumas.constants.TAU_C_TAU, (p.particle.lifetime))
            assert.is.equal(1, util.getn(physics.composites))
            assert.is.equal(3, util.getn(physics.elements))
            assert.is.equal(2, util.getn(physics.materials))
            assert.is.equal('Physics', metatype(p))
        end)

        it('should return a proper metatype', function ()
            assert.is.equal('Physics', metatype(physics))
        end)
    end)

    describe('attributes', function ()
        it('should be correct', function ()
            assert.is.equal('Readonly', getmetatable(physics.composites))
            assert.is.equal(1, util.getn(physics.composites))
            assert.is.equal('TabulatedMaterial',
                metatype(physics.composites['WetRock']))

            assert.is.equal('Readonly', getmetatable(physics.dcs))
            assert.is.equal(3, util.getn(physics.dcs))

            assert.is.equal('Readonly', getmetatable(physics.elements))
            assert.is.equal(3, util.getn(physics.elements))
            for _, e in physics.elements:pairs() do
                assert.is.equal('Readonly', getmetatable(e))
                assert.is.equal('Element', metatype(e))
            end

            assert.is.equal('Readonly', getmetatable(physics.materials))
            assert.is.equal(2, util.getn(physics.materials))
            for _, m in physics.materials:pairs() do
                assert.is.equal('TabulatedMaterial', metatype(m))
            end

            assert.is.equal('Readonly', getmetatable(physics.particle))
            assert.is.equal('muon', physics.particle.name)
            assert.is.equal(pumas.constants.MUON_MASS, physics.particle.mass)
            assert.is.equal(pumas.constants.MUON_C_TAU,
                physics.particle.lifetime)
        end)

        it('should not be mutable', function ()
            assert.has_error(
                function () physics.materials = 1 end,
                "cannot modify 'materials' for 'Physics'")
            physics.materials = nil

            assert.has_error(
                function () physics.materials['Water'] = nil end,
                "cannot modify 'Water' for 'materials'")

            assert.has_error(
                function () physics.composites = 1 end,
                "cannot modify 'composites' for 'Physics'")
            physics.composites = nil

            assert.has_error(
                function () physics.composites['WetRock'] = nil end,
                "cannot modify 'WetRock' for 'composites'")
        end)
    end)

    describe('dcs', function ()
        it('should return a value', function ()
            for _, process in ipairs{'bremsstrahlung', 'pair_production',
                'photonuclear'} do
                local d = physics.dcs[process](
                    1, 1, physics.particle.mass, 1E+03, 10)
                assert.is.equal('number', type(d))
                assert.is.equal(true, d > 0)
            end
        end)
    end)

    describe('Context', function ()
        it('should create a new context from a mode string', function ()
            local c = physics:Context('backward hybrid')
            assert.is.equal('Context', metatype(c))
            assert.is.equal(
                'backward full_space hybrid weight', tostring(c.mode))
        end)

        it('should throw on error on missing self', function ()
            assert.has_error(
                function () physics.Context('backward hybrid') end,
                "bad argument #1 to 'Context' (expected an options or \z
                Physics table, got a string)")
            assert.has_error(
                function () physics.Context() end,
                "bad number of argument(s) to 'Context' \z
                (expected 1 or 2, got 0)")
        end)
    end)

    describe('dump', function ()
        it('should create a proper binary dump', function ()
            physics:dump('test.dump')
            local f = io.open('test.dump', 'rb')
            assert.is.not_equal(nil, f)
            f:close()

            local tmp = pumas.Physics('test.dump')
            assert.is.equal(#physics.elements, #tmp.elements)
            assert.is.equal(#physics.materials, #tmp.materials)
            assert.is.equal(#physics.composites, #tmp.composites)

            os.remove('test.dump')
        end)

        it('should throw on error on invalid path', function ()
            assert.has_error(
                function () physics:dump('toto/test.dump') end,
                "bad argument #2 to 'dump' \z
                (could not open file toto/test.dump)")
        end)

        it('should throw on error on missing self', function ()
            assert.has_error(
                function () physics.dump('test.dump') end,
                "bad number of argument(s) to 'dump' (expected 2, got 1)")
        end)

        it('should throw on error on missing path', function ()
            assert.has_error(
                function () physics:dump() end,
                "bad number of argument(s) to 'dump' (expected 2, got 1)")
        end)
    end)
end)
