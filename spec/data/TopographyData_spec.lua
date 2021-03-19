-------------------------------------------------------------------------------
-- Spec of the pumas.TopographyData metatype
-- Author: Valentin Niess
-- License: GNU LGPL-3.0
-------------------------------------------------------------------------------
local pumas = require('pumas')
local metatype = require('pumas.metatype')
local util = require('spec.util')


describe('TopographyData', function ()
    describe('constructor', function ()
        it('should default to a flat topography', function ()
            local d = pumas.TopographyData()
            assert.is.equal(nil, d.path)
            assert.is.equal(0, d.offset)
        end)

        it('should properly load a map', function ()
            local d0 = pumas.TopographyData('spec/map-2x2.png')
            assert.is.equal('spec/map-2x2.png', d0.path)
            assert.is.equal(0, d0.offset)

            local d1 = pumas.TopographyData('spec/map-2x2.png', 1)
            assert.is.equal('spec/map-2x2.png', d1.path)
            assert.is.equal(1, d1.offset)
        end)

        it('should properly get and set the offset attribute', function ()
            local d = pumas.TopographyData()
            d.offset = 1
            assert.is.equal(1, d.offset)
        end)

        it('should have a readonly path attribute', function ()
            local d = pumas.TopographyData()
            assert.has_error(function ()
                d.path = 'toto'
            end, "cannot modify 'path' for 'TopographyData'")
        end)

        it('should initialise from another instance', function ()
            local d0 = pumas.TopographyData(1)

            local d1 = pumas.TopographyData(d0)
            assert.is.equal(d0.path, d1.path)
            assert.is.equal(1, d1.offset)

            local d2 = pumas.TopographyData(d0, -1)
            assert.is.equal(d0.path, d2.path)
            assert.is.equal(-1, d2.offset)
        end)

        it('should return a TopographyData table', function ()
            local d = pumas.TopographyData()
            assert.is.equal('TopographyData', metatype(d))
        end)
    end)

    describe('clone', function ()
        it('should perform a shallow copy', function ()
            local d0 = pumas.TopographyData('spec/map-2x2.png', 1)
            local d1 = d0:clone()
            assert.is.not_equal(d0, d1)
            assert.is.equal(d0.path, d1.path)
            assert.is.equal(d0.offset, d1.offset)
            assert.is.equal(d0._c, d1._c)
        end)
    end)

    describe('elevation', function ()
        it('should provide elevation', function ()
            local d0 = pumas.TopographyData('spec/map-2x2.png', 1)
            assert.is.equal(2, util.round(d0:elevation(45.5, 3.5), 1))
            assert.is.equal(nil, d0:elevation(0, 0))

            local d1 = pumas.TopographyData(1)
            assert.is.equal(1, d1:elevation(0, 0))
        end)
    end)

    describe('__add', function ()
        it('should return a clone', function ()
            local d0 = pumas.TopographyData('spec/map-2x2.png', 1)
            local d1 = d0 + 1
            assert.is.not_equal(d0, d1)
            assert.is.equal(d0.path, d1.path)
            assert.is.equal(d0.offset + 1, d1.offset)
            assert.is.equal(d0._c, d1._c)
        end)
    end)

    describe('__sub', function ()
        it('should return a clone', function ()
            local d0 = pumas.TopographyData('spec/map-2x2.png', 2)
            local d1 = d0 - 1
            assert.is.not_equal(d0, d1)
            assert.is.equal(d0.path, d1.path)
            assert.is.equal(d0.offset - 1, d1.offset)
            assert.is.equal(d0._c, d1._c)
        end)
    end)
end)
