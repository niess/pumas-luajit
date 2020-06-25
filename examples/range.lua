-- Load materials tabulations
PUMAS.load('share/materials/standard')

-- Build the geometry, a uniform medium of infinite extension
local medium = UniformMedium('StandardRock')
local geometry = InfiniteGeometry(medium)

-- Configure a simulation context
local context = Context {
    forward = true,
    longitudinal = true,
    scheme = SCHEME_HYBRID,
    geometry = geometry,
}

-- Initial muon state
local initial = State {
    kinetic = 1E+03,
    weight = 1,
    position = {0, 0, 0},
    direction = {0, 0, -1}
}

-- Run the Monte Carlo
local s1, s2, n = 0, 0, 10000
local state = State()
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
