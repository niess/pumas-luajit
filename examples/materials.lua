-- Generate Physics tabulations of materials for PUMAS
--
-- A set of default materials is provided from the MATERIALS global table.
-- Naming and properties follow the Particle Data Group (PDG),
-- Ref: http://pdg.lbl.gov/2020/AtomicNuclearProperties/index.html.
--
-- Custom materials can be defined and added to the MATERIALS table as well.

local gettime = require('socket').gettime -- XXX move this to pumas?
local pumas = require('pumas')

print('building material tables for the examples ...')
local t0 = gettime()

pumas.PUMAS.build({ -- XXX is the PUMAS table really needed?
    materials = {'StandardRock', 'WaterLiquid', 'AirDry1Atm'},
    composites = {WetRock = {{'StandardRock', 0.788},
                             {'WaterLiquid', 0.212}}},
    path = 'share/materials/standard'
})

print('done in ' .. gettime() - t0 .. ' s')

-- Print a list of available materials
print([[

   material name                       density
   (PDG scheme)                        (g/cm^3)
]])
for k, v in pairs(pumas.MATERIALS) do
    print(string.format('%-37s %8.5f', k, v.density * 1E-03))
end
