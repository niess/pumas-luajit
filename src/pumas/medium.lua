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
medium.update = base.update

medium.GradientMedium = gradient.GradientMedium
medium.transparent_medium = transparent.transparent_medium
medium.UniformMedium = uniform.UniformMedium


-------------------------------------------------------------------------------
-- Register the subpackage
-------------------------------------------------------------------------------
function medium.register_to (t)
    t.GradientMedium = medium.GradientMedium
    t.transparent_medium = medium.transparent_medium
    t.UniformMedium = medium.UniformMedium
end


-------------------------------------------------------------------------------
-- Return the package
-------------------------------------------------------------------------------
return medium
