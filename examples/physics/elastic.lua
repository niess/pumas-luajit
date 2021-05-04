local pumas = require('pumas')

local energy, thickness = 1, 25E-06

local simulation = pumas.Context{
    physics = 'share/materials/examples',
    mode = 'forward virtual',
    geometry = 'StandardRock'}
simulation.limit.distance = thickness

local material = simulation.physics.materials['StandardRock']
local lambda1 = material:scattering_length(energy) / material.density
print(string.format('%.5E', lambda1))
os.exit(0)

simulation.accuracy = 1E-02 * thickness / lambda1

-- Initial muon state
local initial_state = pumas.State{energy = energy}

-- Run the Monte Carlo
local n = 100000
local state = pumas.State()
for _ = 1, n do
    state:set(initial_state)
    simulation:transport(state)
    print(string.format('%12.5E %12.5E  %12.5E %12.5E %12.5E',
        state.direction[0], state.direction[1], state.position[0],
        state.position[1], state.position[2]))
    io.flush()
end
