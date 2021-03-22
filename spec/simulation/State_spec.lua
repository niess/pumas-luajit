-------------------------------------------------------------------------------
-- Spec of the pumas.State metatype
-- Author: Valentin Niess
-- License: GNU LGPL-3.0
-------------------------------------------------------------------------------
local pumas = require('pumas')
local metatype = require('pumas.metatype')


describe('State', function ()
    describe('Constructor', function ()
        it('should set proper defaults', function ()
            local s = pumas.State()
            assert.is.equal(0, s.charge)
            assert.is.equal(0, s.energy)
            assert.is.equal(0, s.position[0])
            assert.is.equal(0, s.position[1])
            assert.is.equal(0, s.position[2])
            assert.is.equal(0, s.direction[0])
            assert.is.equal(0, s.direction[1])
            assert.is.equal(0, s.direction[2])
            assert.is.equal(0, s.distance)
            assert.is.equal(0, s.grammage)
            assert.is.equal(0, s.time)
            assert.is.equal(0, s.weight)
            assert.is.equal(false, s.decayed)
            assert.is.equal('State', metatype(s))
        end)

        it('should properly set attributes', function ()
            local s = pumas.State{distance = 0}
            assert.is.equal(-1, s.charge)
            assert.is.equal(1, s.energy)
            assert.is.equal(0, s.position[0])
            assert.is.equal(0, s.position[1])
            assert.is.equal(0, s.position[2])
            assert.is.equal(0, s.direction[0])
            assert.is.equal(0, s.direction[1])
            assert.is.equal(1, s.direction[2])
            assert.is.equal(0, s.distance)
            assert.is.equal(0, s.grammage)
            assert.is.equal(0, s.time)
            assert.is.equal(1, s.weight)
            assert.is.equal(false, s.decayed)
            assert.is.equal('State', metatype(s))

            s = pumas.State{charge = 1, energy = 2, position = {3, 4, 5},
                direction = pumas.CartesianVector(6, 7, 8), distance = 9,
                grammage = 10, time = 11, weight = 12, decayed = true}
            assert.is.equal(1, s.charge)
            assert.is.equal(2, s.energy)
            assert.is.equal(3, s.position[0])
            assert.is.equal(4, s.position[1])
            assert.is.equal(5, s.position[2])
            assert.is.equal(6, s.direction[0])
            assert.is.equal(7, s.direction[1])
            assert.is.equal(8, s.direction[2])
            assert.is.equal(9, s.distance)
            assert.is.equal(10, s.grammage)
            assert.is.equal(11, s.time)
            assert.is.equal(12, s.weight)
            assert.is.equal(true, s.decayed)
            assert.is.equal('State', metatype(s))
        end)

        it('should properly copy', function ()
            local s0 = pumas.State{charge = 1, energy = 2, position = {3, 4, 5},
                direction = {6, 7, 8}, distance = 9, grammage = 10, time = 11,
                weight = 12, decayed = true}
            local s = pumas.State(s0)
            assert.is.not_equal(s0, s)
            assert.is.not_equal(s0._c, s._c)
            assert.is.equal(1, s.charge)
            assert.is.equal(2, s.energy)
            assert.is.equal(3, s.position[0])
            assert.is.equal(4, s.position[1])
            assert.is.equal(5, s.position[2])
            assert.is.equal(6, s.direction[0])
            assert.is.equal(7, s.direction[1])
            assert.is.equal(8, s.direction[2])
            assert.is.equal(9, s.distance)
            assert.is.equal(10, s.grammage)
            assert.is.equal(11, s.time)
            assert.is.equal(12, s.weight)
            assert.is.equal(true, s.decayed)
            assert.is.equal('State', metatype(s))
        end)

        it('should catch errors', function ()
            assert.has_error(
                function () pumas.State('toto') end,
                "bad argument #1 to 'State' \z
                (expected a (State) table, got a string)")
        end)
    end)

    describe('attributes', function ()
        it('should properly get and set', function ()
            local s = pumas.State()

            s.charge = 1
            assert.is.equal(1, s.charge)

            s.energy = 2
            assert.is.equal(2, s.energy)

            s.position = pumas.CartesianPoint(3, 4, 5)
            assert.is.equal(3, s.position[0])
            assert.is.equal(4, s.position[1])
            assert.is.equal(5, s.position[2])

            s.direction = {6, 7, 8}
            assert.is.equal(6, s.direction[0])
            assert.is.equal(7, s.direction[1])
            assert.is.equal(8, s.direction[2])

            s.distance = 9
            assert.is.equal(9, s.distance)

            s.grammage = 10
            assert.is.equal(10, s.grammage)

            s.time = 11
            assert.is.equal(11, s.time)

            s.weight = 12
            assert.is.equal(12, s.weight)

            s.decayed = true
            assert.is.equal(true, s.decayed)
        end)

        it('should catch errors', function ()
            local s = pumas.State()

            assert.has_error(
                function () s.charge = 'toto' end,
                "bad attribute 'charge' for 'State' \z
                (expected a number, got a string)")

            assert.has_error(
                function () s.energy = 'toto' end,
                "bad attribute 'energy' for 'State' \z
                (expected a number, got a string)")

            assert.has_error(
                function () s.distance = 'toto' end,
                "bad attribute 'distance' for 'State' \z
                (expected a number, got a string)")

            assert.has_error(
                function () s.grammage = 'toto' end,
                "bad attribute 'grammage' for 'State' \z
                (expected a number, got a string)")

            assert.has_error(
                function () s.time = 'toto' end,
                "bad attribute 'time' for 'State' \z
                (expected a number, got a string)")

            assert.has_error(
                function () s.weight = 'toto' end,
                "bad attribute 'weight' for 'State' \z
                (expected a number, got a string)")

            assert.has_error(
                function () s.decayed = 1 end,
                "bad attribute 'decayed' for 'State' \z
                (expected a boolean, got a number)")
        end)
    end)

    describe('clear', function ()
        it('should reset attributes', function ()
            local s = pumas.State{charge = 1, energy = 2, position = {3, 4, 5},
                direction = pumas.CartesianVector(6, 7, 8), distance = 9,
                grammage = 10, time = 11, weight = 12, decayed = true}
            s:clear()
            assert.is.equal(0, s.charge)
            assert.is.equal(0, s.energy)
            assert.is.equal(0, s.position[0])
            assert.is.equal(0, s.position[1])
            assert.is.equal(0, s.position[2])
            assert.is.equal(0, s.direction[0])
            assert.is.equal(0, s.direction[1])
            assert.is.equal(0, s.direction[2])
            assert.is.equal(0, s.distance)
            assert.is.equal(0, s.grammage)
            assert.is.equal(0, s.time)
            assert.is.equal(0, s.weight)
            assert.is.equal(false, s.decayed)
            assert.is.equal('State', metatype(s))
        end)

        it('should catch errors', function ()
            local s = pumas.State()

            assert.has_error(
                function () s.clear() end,
                "bad number of argument(s) to 'clear' (expected 1, got 0)")

            assert.has_error(
                function () s.clear(1) end,
                "bad argument #1 to 'clear' \z
                (expected a State table, got a number)")
        end)
    end)

    describe('clone', function ()
        it('should set attributes', function ()
            local s0 = pumas.State{charge = 1, energy = 2, position = {3, 4, 5},
                direction = pumas.CartesianVector(6, 7, 8), distance = 9,
                grammage = 10, time = 11, weight = 12, decayed = true}
            local s = s0:clone()
            assert.is.not_equal(s0, s)
            assert.is.not_equal(s0._c, s._c)
            assert.is.equal(1, s.charge)
            assert.is.equal(2, s.energy)
            assert.is.equal(3, s.position[0])
            assert.is.equal(4, s.position[1])
            assert.is.equal(5, s.position[2])
            assert.is.equal(6, s.direction[0])
            assert.is.equal(7, s.direction[1])
            assert.is.equal(8, s.direction[2])
            assert.is.equal(9, s.distance)
            assert.is.equal(10, s.grammage)
            assert.is.equal(11, s.time)
            assert.is.equal(12, s.weight)
            assert.is.equal(true, s.decayed)
            assert.is.equal('State', metatype(s))
        end)

        it('should catch errors', function ()
            local s = pumas.State()

            assert.has_error(
                function () s.clone() end,
                "bad number of argument(s) to 'clone' (expected 1, got 0)")

            assert.has_error(
                function () s.clone(1) end,
                "bad argument #1 to 'clone' \z
                (expected a State table, got a number)")
        end)
    end)

    describe('set', function ()
        it('should set attributes', function ()
            local s0 = pumas.State{charge = 1, energy = 2, position = {3, 4, 5},
                direction = pumas.CartesianVector(6, 7, 8), distance = 9,
                grammage = 10, time = 11, weight = 12, decayed = true}
            local s = pumas.State()
            s:set(s0)
            assert.is.equal(1, s.charge)
            assert.is.equal(2, s.energy)
            assert.is.equal(3, s.position[0])
            assert.is.equal(4, s.position[1])
            assert.is.equal(5, s.position[2])
            assert.is.equal(6, s.direction[0])
            assert.is.equal(7, s.direction[1])
            assert.is.equal(8, s.direction[2])
            assert.is.equal(9, s.distance)
            assert.is.equal(10, s.grammage)
            assert.is.equal(11, s.time)
            assert.is.equal(12, s.weight)
            assert.is.equal(true, s.decayed)
        end)

        it('should catch errors', function ()
            local s = pumas.State()

            assert.has_error(
                function () s.set() end,
                "bad number of argument(s) to 'set' (expected 2, got 0)")

            assert.has_error(
                function () s:set() end,
                "bad number of argument(s) to 'set' (expected 2, got 1)")

            assert.has_error(
                function () s:set(1) end,
                "bad argument #2 to 'set' \z
                (expected a State table, got a number)")

            assert.has_error(
                function () s.set(1, 2) end,
                "bad argument #1 to 'set' \z
                (expected a State table, got a number)")
        end)
    end)
end)
