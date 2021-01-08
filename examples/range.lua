local pumas = require('pumas')

-- Load materials tabulations
local physics = pumas.Physics('share/materials/standard')

-- Create an hybrid simulation context a la MuM
local context = physics:Context('longitudinal hybrid')

-- Build the geometry, a uniform medium of infinite extension
local medium = pumas.UniformMedium('StandardRock')
context.geometry = pumas.InfiniteGeometry(medium)

-- Initial muon state
local initial = pumas.State{kinetic = 1E+03} -- GeV

-- Run the Monte Carlo
local s1, s2, n = 0, 0, 10000
local state = pumas.State()
for i = 1, n do
    state:set(initial)
    context:transport(state)

    s1 = s1 + state.distance
    s2 = s2 + state.distance * state.distance
end

-- Compute statistics and print the result
local range = s1 / n
local sigma = math.sqrt((s2 / n - range * range) / n)
print(string.format('range = %.5E +- %.5E m', range, sigma))
