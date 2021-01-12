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
geometry.PolytopeGeometry = polytope.PolytopeGeometry
geometry.TopographyData = topography.TopographyData
geometry.TopographyDataSet = topography.TopographyDataSet


-------------------------------------------------------------------------------
-- Register the subpackage
-------------------------------------------------------------------------------
function geometry.register_to (t)
    t.EarthGeometry = geometry.EarthGeometry
    t.InfiniteGeometry = geometry.InfiniteGeometry
    t.PolytopeGeometry = geometry.PolytopeGeometry
    t.TopographyData = geometry.TopographyData
    t.TopographyDataSet = geometry.TopographyDataSet
end


-------------------------------------------------------------------------------
-- Return the package
-------------------------------------------------------------------------------
return geometry
