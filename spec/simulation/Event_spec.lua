local pumas = require('pumas')
local metatype = require('pumas.metatype')


describe('Event', function ()
    describe('constructor', function ()
        it('should initialise with proper defaults', function ()
            local e = pumas.Event()
            assert.is_true(e.none)
            assert.is_false(e.start)
            assert.is_false(e.limit)
            assert.is_false(e.vertex)
            assert.is.equal('Event', metatype(e))
        end)

        it('should set proper flags', function ()
            local e0 = pumas.Event('start', 'limit')
            assert.is_false(e0.none)
            assert.is_true(e0.start)
            assert.is_true(e0.limit)
            assert.is_false(e0.vertex)
            assert.is.equal('Event', metatype(e0))

            local e1 = pumas.Event(e0)
            assert.is.equal(e0._value, e1._value)
            assert.is_false(e1.none)
            assert.is_true(e1.start)
            assert.is_true(e1.limit)
            assert.is_false(e1.vertex)
            assert.is.equal('Event', metatype(e1))

            e0.none = true
            assert.is.not_equal(e0, e1)
        end)
    end)

    describe('attributes', function ()
        it('can be set properly', function ()
            local e = pumas.Event()

            e.limit = true
            assert.is_false(e.none)
            assert.is_true(e.limit)
            assert.is_true(e.limit_distance)
            assert.is_true(e.limit_grammage)
            assert.is_true(e.limit_energy)
            assert.is_true(e.limit_time)

            e.limit_distance = false
            assert.is_false(e.none)
            assert.is_true(e.limit)
            assert.is_false(e.limit_distance)
            assert.is_true(e.limit_grammage)
            assert.is_true(e.limit_energy)
            assert.is_true(e.limit_time)

            e.none = true
            assert.is_true(e.none)
            assert.is_false(e.limit)
            assert.is_false(e.limit_grammage)
            assert.is_false(e.limit_energy)
            assert.is_false(e.limit_time)
        end)
    end)

    describe('clear', function ()
        it('should properly clear event(s)', function ()
            local e = pumas.Event('limit', 'vertex', 'medium')
            e:clear()
            assert.is.equal(0, e._value)
        end)

        it('should catch errors', function ()
            local e = pumas.Event('medium')

            assert.has_error(
                function () e.clear() end,
                "bad number of argument(s) to 'clear' (expected 1, got 0)")

            assert.has_error(
                function () e.clear(1) end,
                "bad argument #1 to 'clear' \z
                (expected an Event table, got a number)")
        end)
    end)

    describe('clone', function ()
        it('should properly clone an event', function ()
            local e0 = pumas.Event('limit', 'vertex', 'medium')
            local e1 = e0:clone()
            assert.is.equal(e0._value, e1._value)
        end)

        it('should catch errors', function ()
            local e = pumas.Event('medium')

            assert.has_error(
                function () e.clone() end,
                "bad number of argument(s) to 'clone' (expected 1, got 0)")

            assert.has_error(
                function () e.clone(1) end,
                "bad argument #1 to 'clone' \z
                (expected an Event table, got a number)")
        end)
    end)
end)
