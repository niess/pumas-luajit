-------------------------------------------------------------------------------
-- Spec of the pumas.version sub-package
-- Author: Valentin Niess
-- License: GNU LGPL-3.0
-------------------------------------------------------------------------------
local pumas = require('pumas')


describe('version', function ()
    it('should return a string', function ()
        assert.is.equal('string', type(pumas.version))
    end)
end)
