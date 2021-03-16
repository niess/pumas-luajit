local pumas = require('pumas')
local metatype = require('pumas.metatype')
local util = require('spec.util')


describe('TopographyDataset', function ()
    describe('constructor', function ()
        it('should accept variable aguments', function ()
            local d = pumas.TopographyData('spec/map-2x2.png', 2)
            local s = pumas.TopographyDataset('spec/map-2x2.png', 1, d)
            assert.is.equal(0, s[1].offset)
            assert.is.equal(1, s[2].offset)
            assert.is.not_equal(d, s[3])
            assert.is.equal(d.offset, s[3].offset)
            assert.is.equal(d.path, s[3].path)
            assert.is.equal(d._c, s[3]._c)
        end)

        it('should accept a table agument', function ()
            local d = pumas.TopographyData('spec/map-2x2.png', 2)
            local s = pumas.TopographyDataset{'spec/map-2x2.png', 1, d}
            assert.is.equal(0, s[1].offset)
            assert.is.equal(1, s[2].offset)
            assert.is.not_equal(d, s[3])
            assert.is.equal(d.offset, s[3].offset)
            assert.is.equal(d.path, s[3].path)
            assert.is.equal(d._c, s[3]._c)
        end)

        it('should return a TopographyDataset table', function ()
            local s = pumas.TopographyDataset(0, 1, 2)
            assert.is.equal('TopographyDataset', metatype(s))
        end)
    end)

    describe('__len', function ()
        it('should return the number of items', function ()
            local s = pumas.TopographyDataset(0, 1, 2)
            assert.is.equal(3, #s)
        end)
    end)

    describe('clone', function ()
        it('should perform a shallow copy', function ()
            local s0 = pumas.TopographyDataset('spec/map-2x2.png', 1)
            local s1 = s0:clone()
            assert.is.not_equal(s0, s1)
            assert.is.equal(#s0, #s1)
            for i = 1, 2 do
                assert.is.not_equal(s0[i], s1[i])
                assert.is.equal(s0[i].path, s1[i].path)
                assert.is.equal(s0[i].offset, s1[i].offset)
                assert.is.equal(rawget(s0[i], '_c'), rawget(s1[i], '_c'))
            end
        end)
    end)

    describe('elevation', function ()
        it('should provide elevation', function ()
            local s = pumas.TopographyDataset('spec/map-2x2.png', 2)
            assert.is.equal(1, util.round(s:elevation(45.5, 3.5), 1))
            assert.is.equal(2, s:elevation(0, 0))
        end)
    end)

    describe('__add', function ()
        it('should return a clone', function ()
            local s0 = pumas.TopographyDataset('spec/map-2x2.png', 2)
            local s1 = s0 + 1
            assert.is.not_equal(s0, s1)
            assert.is.equal(#s0, #s1)
            for i = 1, 2 do
                assert.is.not_equal(s0[i], s1[i])
                assert.is.equal(s0[i].path, s1[i].path)
                assert.is.equal(s0[i].offset + 1, s1[i].offset)
                assert.is.equal(rawget(s0[i], '_c'), rawget(s1[i], '_c'))
            end
        end)
    end)

    describe('__sub', function ()
        it('should return a clone', function ()
            local s0 = pumas.TopographyDataset('spec/map-2x2.png', 2)
            local s1 = s0 - 1
            assert.is.not_equal(s0, s1)
            assert.is.equal(#s0, #s1)
            for i = 1, 2 do
                assert.is.not_equal(s0[i], s1[i])
                assert.is.equal(s0[i].path, s1[i].path)
                assert.is.equal(s0[i].offset - 1, s1[i].offset)
                assert.is.equal(rawget(s0[i], '_c'), rawget(s1[i], '_c'))
            end
        end)
    end)

    describe('ipairs', function ()
        it('should iterate properly', function ()
            local path = {'spec/map-2x2.png'}
            local offset = {0, 1}
            local s = pumas.TopographyDataset('spec/map-2x2.png', 1)
            for i, si in s:ipairs() do
                assert.is.equal(path[i], si.path)
                assert.is.equal(offset[i], si.offset)
            end
        end)
    end)
end)
