local pumas = require('pumas')


describe('constants', function ()
    it('should be readonly', function ()
        assert.has_error(function ()
            pumas.constants.MUON_MASS = 1
        end, "cannot modify 'MUON_MASS' for 'constants'")
    end)
end)
