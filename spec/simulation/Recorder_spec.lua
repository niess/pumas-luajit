local pumas = require('pumas')
local metatype = require('pumas.metatype')


describe('Recorder', function ()
    describe('constructor', function ()
        it('should have proper defaults', function ()
            local r = pumas.Recorder()
            assert.is.equal(1, r.period)
            assert.is.equal('function', type(r.record))
            assert.is.equal('Recorder', metatype(r))
        end)

        it('should properly set attribute(s)', function ()
            local f = function () end
            local r = pumas.Recorder(f, 3)
            assert.is.equal(3, r.period)
            assert.is.equal(f, r.record)
            assert.is.equal('Recorder', metatype(r))
        end)

        it('should catch errors', function ()
            assert.has_error(
                function () pumas.Recorder(1) end,
                "bad argument #1 to 'Recorder' \z
                (expected a function, got a number)")

            assert.has_error(
                function () pumas.Recorder(function () end, 'toto') end,
                "bad argument #2 to 'Recorder' \z
                (expected a number, got a string)")
        end)
    end)

    describe('attributes', function ()
        it('should be properly get and set', function ()
            local r = pumas.Recorder()
            local f = function () end
            r.record = f
            r.period = 3
            assert.is.equal(3, r.period)
            assert.is.equal(f, r.record)
        end)

        it('should catch errors', function ()
            local r = pumas.Recorder()

            assert.has_error(
                function () r.record = 1 end,
                "bad attribute 'record' for 'Recorder' \z
                (expected a function, got a number)")

            assert.has_error(
                function () r.period = 'toto' end,
                "bad attribute 'period' for 'Recorder' \z
                (expected a number, got a string)")
        end)
    end)

end)
