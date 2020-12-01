-------------------------------------------------------------------------------
-- Geometries for PUMAS
-- Author: Valentin Niess
-- License: GNU LGPL-3.0
-------------------------------------------------------------------------------
local earth = require('pumas.geometry.earth')
local infinite = require('pumas.geometry.infinite')
local polytope = require('pumas.geometry.polytope')
local topography = require('pumas.geometry.topography')

local geometry = {}

geometry.EarthGeometry = earth.EarthGeometry
geometry.InfiniteGeometry = infinite.InfiniteGeometry
geometry.PolytopeGeometry = geometry.PolytopeGeometry
geometry.TopographyData = topography.TopographyData


-------------------------------------------------------------------------------
-- Register the subpackage
-------------------------------------------------------------------------------
function geometry.register_to (t)
    for k, v in pairs(geometry) do
        t[k] = v
    end
end


-------------------------------------------------------------------------------
-- Return the package
-------------------------------------------------------------------------------
return geometry
