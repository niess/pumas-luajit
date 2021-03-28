-------------------------------------------------------------------------------
-- Spec of the pumas.constants table
-- Author: Valentin Niess
-- License: GNU LGPL-3.0
-------------------------------------------------------------------------------
local pumas = require('pumas')


describe('constants', function ()
    it('should contain all constants', function ()
        assert.not_nil(pumas.constants.AVOGADRO_NUMBER)
        assert.not_nil(pumas.constants.ELECTRON_MASS)
        assert.not_nil(pumas.constants.MUON_C_TAU)
        assert.not_nil(pumas.constants.MUON_MASS)
        assert.not_nil(pumas.constants.NEUTRON_MASS)
        assert.not_nil(pumas.constants.PROTON_MASS)
        assert.not_nil(pumas.constants.TAU_C_TAU)
        assert.not_nil(pumas.constants.TAU_MASS)
    end)

    it('should be readonly', function ()
        assert.has_error(function ()
            pumas.constants.MUON_MASS = 1
        end, "cannot modify 'MUON_MASS' for 'constants'")
    end)
end)
