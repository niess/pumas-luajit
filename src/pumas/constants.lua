-------------------------------------------------------------------------------
-- PUMAS Physical constants
-- Author: Valentin Niess
-- License: GNU LGPL-3.0
-------------------------------------------------------------------------------
local ffi = require('ffi')
local clib = require('pumas.clib')
local readonly = require('pumas.readonly')

local constants = {}


-------------------------------------------------------------------------------
-- Get constants from the PUMAS library
-------------------------------------------------------------------------------
do
    local value = ffi.new('double [1]')

    for _, k in ipairs{'AVOGADRO_NUMBER', 'ELECTRON_MASS', 'MUON_C_TAU',
        'MUON_MASS', 'NEUTRON_MASS', 'PROTON_MASS', 'TAU_C_TAU', 'TAU_MASS'} do
        clib.pumas_constant(ffi.C['PUMAS_CONSTANT_'..k], value)
        constants[k] = tonumber(value[0])
    end
end


-------------------------------------------------------------------------------
-- Return the package
-------------------------------------------------------------------------------
return readonly.Readonly(constants, 'constants')
