-------------------------------------------------------------------------------
-- Transport media for PUMAS
-- Author: Valentin Niess
-- License: GNU LGPL-3.0
-------------------------------------------------------------------------------
local base = require('pumas.medium.base')
local gradient = require('pumas.medium.gradient')
local transparent = require('pumas.medium.transparent')
local uniform = require('pumas.medium.uniform')

local medium = {}

medium.get = base.get

medium.MEDIUM_TRANSPARENT = transparent.MEDIUM_TRANSPARENT
medium.GradientMedium = gradient.GradientMedium
medium.UniformMedium = uniform.UniformMedium


-------------------------------------------------------------------------------
-- Register the subpackage
-------------------------------------------------------------------------------
function medium.register_to (t)
    for k, v in pairs(medium) do
        -- Register only metatypes and globals
        local c = k:sub(1,1)
        if (c >= 'A') and (c <= 'Z') then
            t[k] = v
        end
    end
end


-------------------------------------------------------------------------------
-- Return the package
-------------------------------------------------------------------------------
return medium
