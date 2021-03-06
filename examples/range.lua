local pumas = require('pumas')

-- Load materials tabulations
local physics = pumas.Physics('share/materials/examples')

-- Create an hybrid simulation context a la MUM
local simulation = physics:Context('longitudinal hybrid')

-- Build the geometry, a uniform medium of infinite extension
simulation.geometry = pumas.InfiniteGeometry('StandardRock')

-- Initial muon state
local initial_state = pumas.State{energy = 1E+03} -- GeV

-- Run the Monte Carlo
local s1, s2, n = 0, 0, 10000
local state = pumas.State()
for _ = 1, n do
    state:set(initial_state)
    simulation:transport(state)

    s1 = s1 + state.distance
    s2 = s2 + state.distance * state.distance
end

-- Compute statistics and print the result
local range = s1 / n
local sigma = math.sqrt((s2 / n - range * range) / n)
print(string.format('range = %.5E +- %.5E m', range, sigma))
