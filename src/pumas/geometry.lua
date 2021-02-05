-------------------------------------------------------------------------------
-- Geometries for PUMAS
-- Author: Valentin Niess
-- License: GNU LGPL-3.0
-------------------------------------------------------------------------------
local earth = require('pumas.geometry.earth')
local infinite = require('pumas.geometry.infinite')
local layer = require('pumas.geometry.layer')
local polyhedron = require('pumas.geometry.polyhedron')
local topography = require('pumas.geometry.topography')

local geometry = {}

geometry.EarthGeometry = earth.EarthGeometry
geometry.InfiniteGeometry = infinite.InfiniteGeometry
geometry.PolyhedronGeometry = polyhedron.PolyhedronGeometry
geometry.TopographyData = topography.TopographyData
geometry.TopographyDataset = topography.TopographyDataset
geometry.TopographyLayer = layer.TopographyLayer


-------------------------------------------------------------------------------
-- Register the subpackage
-------------------------------------------------------------------------------
function geometry.register_to (t)
    t.EarthGeometry = geometry.EarthGeometry
    t.InfiniteGeometry = geometry.InfiniteGeometry
    t.PolyhedronGeometry = geometry.PolyhedronGeometry
    t.TopographyData = geometry.TopographyData
    t.TopographyDataset = geometry.TopographyDataset
    t.TopographyLayer = geometry.TopographyLayer
end


-------------------------------------------------------------------------------
-- Return the package
-------------------------------------------------------------------------------
return geometry
