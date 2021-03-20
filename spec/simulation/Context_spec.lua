-------------------------------------------------------------------------------
-- Spec of the pumas.Context metatype
-- Author: Valentin Niess
-- License: GNU LGPL-3.0
-------------------------------------------------------------------------------
local pumas = require('pumas')
local metatype = require('pumas.metatype')
local physics = require('spec.physics')
local util = require('spec.util')


describe('context', function ()
    describe('constructor', function ()
        it('should initialise with default attributes', function ()
            local contexts = {
                pumas.Context{physics = physics.tau},
                pumas.Context{physics = physics.path..'/tau'},
                physics.tau:Context()}

            for i, c in ipairs(contexts) do
                if i ~= 2 then
                    assert.is.equal(physics.tau, c.physics)
                else
                    assert.is.not_equal(physics.tau, c.physics)
                end
                assert.is_nil(c.geometry)
                assert.is_nil(c.limit.distance)
                assert.is_nil(c.limit.energy)
                assert.is_nil(c.limit.grammage)
                assert.is_nil(c.limit.time)
                assert.is.equal(
                    'forward full_space detailed decay', tostring(c.mode))
                assert.is.equal('forward', c.mode.direction)
                assert.is.equal('full_space', c.mode.scattering)
                assert.is.equal('detailed', c.mode.energy_loss)
                assert.is.equal('decay', c.mode.decay)
                assert.is.equal('number', type(c.random_seed))
                assert.is_nil(c.recorder)
                assert.is.equal('Context', metatype(c))
            end
        end)

        it('should properly set attributes', function ()
            local geometry = pumas.InfiniteGeometry('StandardRock')
            local c = physics.muon:Context{
                mode = 'backward hybrid',
                limit = {distance = 1, energy = 2, grammage = 3, time = 4},
                geometry = geometry,
                random_seed = 5,
                recorder = function () end}
            assert.is.equal(
                'backward full_space hybrid weight', tostring(c.mode))
            assert.is.equal('backward', c.mode.direction)
            assert.is.equal('full_space', c.mode.scattering)
            assert.is.equal('hybrid', c.mode.energy_loss)
            assert.is.equal('weight', c.mode.decay)
            assert.is.equal(1, c.limit.distance)
            assert.is.equal(2, c.limit.energy)
            assert.is.equal(3, c.limit.grammage)
            assert.is.equal(4, c.limit.time)
            assert.is.equal(geometry, c.geometry)
            assert.is.equal(5, c.random_seed)
            assert.is.not_equal(nil, c.recorder)
        end)

        it('should catch errors', function ()
            assert.has_error(
                function () physics.muon.Context() end,
                "bad number of argument(s) to 'Context' \z
                (expected 1 or 2, got 0)")

            assert.has_error(
                function () pumas.Context{} end,
                "bad argument 'physics' to 'Context' \z
                (expected a Physics table, got nil)")

            assert.has_error(
                function () physics.muon.Context('toto') end,
                "bad argument #1 to 'Context' \z
                (expected a (Physics) table, got a string)")

            assert.has_error(
                function () pumas.Context{physics = 1} end,
                "bad argument 'physics' to 'Context' \z
                (expected a Physics table, got a number)")
        end)
    end)

    describe('medium', function ()
        it('should return the medium', function ()
            local medium = pumas.UniformMedium('StandardRock')
            local geometry = pumas.InfiniteGeometry(medium)
            local context = physics.tau:Context{geometry = geometry}
            local state = pumas.State()
            assert.is.equal(medium, context:medium(state))
            assert.is.equal(medium, context:medium(pumas.CartesianPoint()))

            context.geometry = nil
            assert.is_nil(context:medium(state))
            assert.is_nil(context:medium(pumas.CartesianPoint()))
        end)

        it('should catch errors', function ()
            local context = physics.tau:Context{
                geometry = pumas.InfiniteGeometry('StandardRock')}

            assert.has_error(
                function () context.medium() end,
                "bad number of argument(s) to 'medium' (expected 2, got 0)")

            assert.has_error(
                function () context:medium() end,
                "bad number of argument(s) to 'medium' (expected 2, got 1)")

            assert.has_error(
                function () context.medium(pumas.CartesianPoint()) end,
                "bad number of argument(s) to 'medium' (expected 2, got 1)")

            assert.has_error(
                function () context:medium(1) end,
                "bad argument #2 to 'medium' \z
                (expected a Coordinates or State table, got a number)")
        end)
    end)

    describe('random', function ()
        it('should return random number(s)', function ()
            local context = physics.tau:Context()

            local v0 = context:random()
            assert.is.equal('number', type(v0))
            assert.is_true(v0 >= 0)
            assert.is_true(v0 <= 1)

            local v1 = context:random()
            assert.is.not_equal(v0, v1)

            local a = {context:random(10)}
            assert.is.equal('table', type(a))
            assert.is.equal(10, #a)
            for _, ai in ipairs(a) do
                assert.is.equal('number', type(ai))
                assert.is_true(ai >= 0)
                assert.is_true(ai <= 1)
            end
        end)

        it('should catch errors', function ()
            local context = physics.tau:Context{}
            assert.has_error(
                function () context.random() end,
                "bad number of argument(s) to 'random' \z
                (expected 1 or 2, got 0)")

            assert.has_error(
                function () context.random(1) end,
                "bad argument #1 to 'random' \z
                (expected a Context table, got a number)")

            assert.has_error(
                function () context:random(0) end,
                "bad argument #2 to 'random' \z
                (expected a strictly positive number, got 0)")

            assert.has_error(
                function () context:random('toto') end,
                "bad argument #2 to 'random' \z
                (expected a number, got a string)")
        end)
    end)

    describe('transport', function ()
        it('should work with user limits', function ()
            local c = physics.muon:Context('backward csda longitudinal')
            local m = pumas.UniformMedium('StandardRock')
            c.geometry = pumas.InfiniteGeometry(m)
            c.limit.energy = 2
            local s = pumas.State{energy = 1}
            local event, media = c:transport(s)
            assert.is.equal(2, util.round(s.energy))
            assert.is_true(event.limit)
            assert.is_true(event.limit_energy)
            assert.is_false(event.limit_distance)
            assert.is.equal(2, #media)
            assert.is.equal(m, media[1])
            assert.is.equal(m, media[2])

            c.limit.distance = 1
            c.limit.energy = nil
            s.distance = 0
            event, media = c:transport(s)
            assert.is.equal(1, util.round(s.distance))
            assert.is_true(event.limit_distance)
            assert.is.equal(2, #media)
            assert.is.equal(m, media[1])
            assert.is.equal(m, media[2])

            c.limit.distance = nil
            c.limit.grammage = 1
            s.grammage = 0
            event, media = c:transport(s)
            assert.is.equal(1, util.round(s.grammage))
            assert.is_true(event.limit_grammage)
            assert.is.equal(2, #media)
            assert.is.equal(m, media[1])
            assert.is.equal(m, media[2])

            c.limit.grammage = nil
            c.limit.time = 1
            s.time = 0
            event, media = c:transport(s)
            assert.is.equal(1, util.round(s.time))
            assert.is_true(event.limit_time)
            assert.is.equal(2, #media)
            assert.is.equal(m, media[1])
            assert.is.equal(m, media[2])
        end)

        it('should catch errors', function ()
            local c = physics.muon:Context('backward detailed longitudinal')
            local s = pumas.State()

            assert.has_error(
                function () c.transport() end,
                "bad number of argument(s) to 'transport' (expected 2, got 0)")

            assert.has_error(
                function () c:transport() end,
                "bad number of argument(s) to 'transport' (expected 2, got 1)")

            assert.has_error(
                function () c.transport(s) end,
                "bad number of argument(s) to 'transport' (expected 2, got 1)")

            assert.has_error(
                function () c:transport(1) end,
                "bad argument #2 to 'transport' \z
                (expected a State table, got a number)")

            assert.has_error(
                function () c.transport(1, s) end,
                "bad argument #1 to 'transport' \z
                (expected a Context table, got a number)")
        end)
    end)
end)
