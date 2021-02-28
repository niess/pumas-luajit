-- Build materials tables for the `pumas` examples
--
-- A set of default materials is provided from the pumas.materials table.
-- Naming and properties follow the Particle Data Group (PDG),
-- Ref: http://pdg.lbl.gov/2020/AtomicNuclearProperties/index.html.
--
-- Custom materials can be defined and added to the pumas.materials table as
-- well.

local pumas = require('pumas')


print('building materials tables for the `pumas` examples...')

pumas.build{
    materials = {'StandardRock', 'Water', 'Air'},
    composites = {
        WetRock = {StandardRock = 0.7, Water = 0.3}
    },
    path = 'share/materials/standard'
}

print('materials tables have been dumped to share/materials/standard')
