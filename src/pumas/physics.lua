-------------------------------------------------------------------------------
-- Manage PUMAS Physics
-- Author: Valentin Niess
-- License: GNU LGPL-3.0
-------------------------------------------------------------------------------
local context = require('pumas.context')
local physics_ = require('pumas.physics.physics')

local physics = {}

physics.build = require('pumas.physics.build')
physics.Physics = physics_.Physics


-------------------------------------------------------------------------------
-- Register the subpackage
-------------------------------------------------------------------------------
function physics.register_to (t)
    t.build = physics.build
    t.Physics = physics.Physics

    -- Register back to context as well. This is to avoid a cross-reference
    -- loop.
    context._physics = physics
end


-------------------------------------------------------------------------------
-- Return the package
-------------------------------------------------------------------------------
return physics
