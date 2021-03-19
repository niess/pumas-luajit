-------------------------------------------------------------------------------
-- Spec of the pumas.Physics metatype
-- Author: Valentin Niess
-- License: GNU LGPL-3.0
-------------------------------------------------------------------------------
local pumas = require('pumas')
local metatype = require('pumas.metatype')
local physics = require('spec.physics')
local util = require('spec.util')


describe('Physics', function ()
    describe('constructor', function ()
        it('should also load from a MDF', function ()
            local p = pumas.Physics{
                mdf = physics.path..'/tau/materials.xml',
                dedx = physics.path..'/tau',
                particle = 'tau'}
            assert.is.equal('tau', (p.particle.name))
            assert.is.equal(pumas.constants.TAU_MASS, (p.particle.mass))
            assert.is.equal(pumas.constants.TAU_C_TAU, (p.particle.lifetime))
            assert.is.equal(1, util.getn(physics.muon.composites))
            assert.is.equal(3, util.getn(physics.muon.elements))
            assert.is.equal(2, util.getn(physics.muon.materials))
            assert.is.equal('Physics', metatype(p))
        end)

        it('should return a proper metatype', function ()
            assert.is.equal('Physics', metatype(physics.muon))
        end)
    end)

    describe('attributes', function ()
        it('should be correct', function ()
            assert.is.equal('Readonly', getmetatable(physics.muon.composites))
            assert.is.equal(1, util.getn(physics.muon.composites))
            assert.is.equal('TabulatedMaterial',
                metatype(physics.muon.composites['WetRock']))

            assert.is.equal('Readonly', getmetatable(physics.muon.dcs))
            assert.is.equal(3, util.getn(physics.muon.dcs))

            assert.is.equal('Readonly', getmetatable(physics.muon.elements))
            assert.is.equal(3, util.getn(physics.muon.elements))
            for _, e in physics.muon.elements:pairs() do
                assert.is.equal('Readonly', getmetatable(e))
                assert.is.equal('Element', metatype(e))
            end

            assert.is.equal('Readonly', getmetatable(physics.muon.materials))
            assert.is.equal(2, util.getn(physics.muon.materials))
            for _, m in physics.muon.materials:pairs() do
                assert.is.equal('TabulatedMaterial', metatype(m))
            end

            assert.is.equal('Readonly', getmetatable(physics.muon.particle))
            assert.is.equal('muon', physics.muon.particle.name)
            assert.is.equal(
                pumas.constants.MUON_MASS, physics.muon.particle.mass)
            assert.is.equal(pumas.constants.MUON_C_TAU,
                physics.muon.particle.lifetime)
        end)

        it('should not be mutable', function ()
            assert.has_error(
                function () physics.muon.materials = 1 end,
                "cannot modify 'materials' for 'Physics'")
            physics.muon.materials = nil

            assert.has_error(
                function () physics.muon.materials['Water'] = nil end,
                "cannot modify 'Water' for 'materials'")

            assert.has_error(
                function () physics.muon.composites = 1 end,
                "cannot modify 'composites' for 'Physics'")
            physics.muon.composites = nil

            assert.has_error(
                function () physics.muon.composites['WetRock'] = nil end,
                "cannot modify 'WetRock' for 'composites'")
        end)
    end)

    describe('dcs', function ()
        it('should return a value', function ()
            for _, process in ipairs{'bremsstrahlung', 'pair_production',
                'photonuclear'} do
                local d = physics.muon.dcs[process](
                    1, 1, physics.muon.particle.mass, 1E+03, 10)
                assert.is.equal('number', type(d))
                assert.is.equal(true, d > 0)
            end
        end)
    end)

    describe('Context', function ()
        it('should create a new context from a mode string', function ()
            local c = physics.muon:Context('backward hybrid')
            assert.is.equal('Context', metatype(c))
            assert.is.equal(
                'backward full_space hybrid weight', tostring(c.mode))
        end)

        it('should throw on error on missing self', function ()
            assert.has_error(
                function () physics.muon.Context('backward hybrid') end,
                "bad argument #1 to 'Context' (expected an options or \z
                Physics table, got a string)")
            assert.has_error(
                function () physics.muon.Context() end,
                "bad number of argument(s) to 'Context' \z
                (expected 1 or 2, got 0)")
        end)
    end)

    describe('dump', function ()
        it('should create a proper binary dump', function ()
            physics.muon:dump('test.dump')
            local f = io.open('test.dump', 'rb')
            assert.is.not_equal(nil, f)
            f:close()

            local tmp = pumas.Physics('test.dump')
            assert.is.equal(#physics.muon.elements, #tmp.elements)
            assert.is.equal(#physics.muon.materials, #tmp.materials)
            assert.is.equal(#physics.muon.composites, #tmp.composites)

            os.remove('test.dump')
        end)

        it('should throw on error on invalid path', function ()
            assert.has_error(
                function () physics.muon:dump('toto/test.dump') end,
                "bad argument #2 to 'dump' \z
                (could not open file toto/test.dump)")
        end)

        it('should throw on error on missing self', function ()
            assert.has_error(
                function () physics.muon.dump('test.dump') end,
                "bad number of argument(s) to 'dump' (expected 2, got 1)")
        end)

        it('should throw on error on missing path', function ()
            assert.has_error(
                function () physics.muon:dump() end,
                "bad number of argument(s) to 'dump' (expected 2, got 1)")
        end)
    end)
end)
