local pumas = require('pumas')

-- Build the geometry, a uniform medium of infinite extension
local medium = pumas.UniformMedium('StandardRock')
local geometry = pumas.InfiniteGeometry(medium)

-- Load materials tabulations
local physics = pumas.Physics('share/materials/standard')

-- Create an hybrid simulation context a la MuM
local context = physics:Context('longitudinal hybrid')
context.geometry = geometry

-- Initial muon state
local initial = pumas.State{
    kinetic = 1E+03,
    weight = 1,
    position = {0, 0, 0},
    direction = {0, 0, -1}
}

-- Run the Monte Carlo
local s1, s2, n = 0, 0, 10000
local state = pumas.State()
for i = 1, n do
    state:set(initial)
    if context:random() < 0.5 then
        state.charge = -1
    else
        state.charge = 1
    end

    context:transport(state)

    s1 = s1 + state.distance
    s2 = s2 + state.distance * state.distance
end

-- Compute statistics and print the result
local range = s1 / n
local sigma = math.sqrt((s2 / n - range * range) / n)
print(string.format('range = %.5E +- %.5E m', range, sigma))
