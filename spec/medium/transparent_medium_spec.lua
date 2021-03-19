-------------------------------------------------------------------------------
-- Spec of the pumas.transparent_medium instance
-- Author: Valentin Niess
-- License: GNU LGPL-3.0
-------------------------------------------------------------------------------
local pumas = require('pumas')


describe('transparent_medium', function ()
    it('should have proper attributes', function ()
        local m = pumas.transparent_medium
        assert.is.equal(0, m.density)
        assert.is.equal(nil, m.magnet)
        assert.is.equal(nil, m.material)
    end)

    it('should not be mutable', function ()
        local m = pumas.transparent_medium
        assert.has_error(function ()
            m.density = 1
        end, "cannot modify 'density' for 'TransparentMedium'")
        assert.has_error(function ()
            m.material = 'Transparent'
        end, "cannot modify 'material' for 'TransparentMedium'")
        assert.has_error(function ()
            m.magnet = {1, 2, 3}
        end, "cannot modify 'magnet' for 'TransparentMedium'")
        assert.has_error(function ()
            m.path = 1
        end, "'TransparentMedium' has no member named 'path'")
    end)
end)
