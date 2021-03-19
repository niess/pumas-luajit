-------------------------------------------------------------------------------
-- Build material tables for the tests
-- Author: Valentin Niess
-- License: GNU LGPL-3.0
-------------------------------------------------------------------------------
local pumas = require('pumas')

local physics = {}


-------------------------------------------------------------------------------
-- Path where to store material tables
-------------------------------------------------------------------------------
physics.path = 'share/materials/spec'


-------------------------------------------------------------------------------
-- Build the physics tables for the tests
-------------------------------------------------------------------------------
pumas.build{
    materials = {'StandardRock', 'Water'},
    composites = {WetRock = {StandardRock = 0.7, Water = 0.3}},
    energies = {1E-03, 1, 1E+03},
    path = physics.path..'/muon'}

physics.muon = pumas.Physics(physics.path..'/muon')


pumas.build{
    materials = {'StandardRock', 'Water'},
    composites = {WetRock = {StandardRock = 0.7, Water = 0.3}},
    energies = {1E+03, 1E+06, 1E+09},
    particle = 'tau',
    path = physics.path..'/tau'}

physics.tau = pumas.Physics(physics.path..'/tau')


-------------------------------------------------------------------------------
-- Return the package
-------------------------------------------------------------------------------
return physics
