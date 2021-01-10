-------------------------------------------------------------------------------
-- Coordinates systems for PUMAS
-- Author: Valentin Niess
-- License: GNU LGPL-3.0
-------------------------------------------------------------------------------
local frame = require('pumas.coordinates.frame')
local transform = require('pumas.coordinates.transform')
local type_ = require('pumas.coordinates.type')

local coordinates = {}

coordinates.LocalFrame = frame.LocalFrame
coordinates.Transform = transform.Transform
for k, v in pairs(type_) do
    coordinates[k] = v
end


-------------------------------------------------------------------------------
-- Register the subpackage
-------------------------------------------------------------------------------
function coordinates.register_to (t)
    for k, v in pairs(coordinates) do
        if k ~= 'register_to' then
            t[k] = v
        end
    end
end


-------------------------------------------------------------------------------
-- Return the package
-------------------------------------------------------------------------------
return coordinates
