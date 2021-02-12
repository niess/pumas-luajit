local pumas = require('pumas')

-- Settings for the simulation
local latitude, longitude = 45, 3
local top_altitude = 1600

-- Build the geometry, an Earth with a flat topography
local atmosphere = pumas.GradientMedium('Air', {
    ['type'] = 'exponential', axis = 'vertical', lambda = -1E+04,
    z0 = 0, rho0 = 1.205})
local geometry = pumas.EarthGeometry{medium = atmosphere, data = top_altitude}

-- Set the primary flux model
local flux = pumas.MuonFlux('tabulation', {altitude = top_altitude})

-- Create a backward simulation context
local simulation = pumas.Context{
    physics = 'share/materials/standard',
    mode = 'backward longitudinal hybrid',
    limit = {energy = 1E+08},
    geometry = geometry
}

-- Set the initial state for Monte Carlo particles
local position = pumas.GeodeticPoint(latitude, longitude, 0)
local frame = pumas.LocalFrame(position)
local deg = math.pi / 180
local direction = pumas.HorizontalVector{
    azimuth = 0 * deg, elevation = -90 * deg, norm = 1, frame = frame}

local initial_state = pumas.State{
    position = position,
    direction = direction
}

-- Loop over energies, using a logarithmic binning, and backward sample the
-- flux model
print([[
  energy        flux       sigma         time
   (GeV)     (GeV^-1 m^-2 s^-1 sr^-1)     (s)
]])

for ik = 1, 81 do
    local t0 = os.clock()

    initial_state.energy = 1E-02 * math.exp((ik - 1) * math.log(1E+08) / 80)
    local state = pumas.State()

    local s, s2, n = 0, 0, 10000
    for _ = 1, n do
        state:set(initial_state)

        -- Randomise the electric charge
        if simulation:random() < 0.5 then
            state.charge = -1
        else
            state.charge = 1
        end
        state.weight = state.weight * 2

        -- Do the backward transport
        simulation:transport(state)

        -- Sample the primary flux
        if flux:sample(state) then
            -- The particle reached the primary flux. Let us update the
            -- Monte Carlo estimate
            s = s + state.weight
            s2 = s2 + state.weight * state.weight
        end
    end
    s = s / n
    s2 = s2 / n

    local dt = os.clock() - t0

    print(string.format('%.5E  %.5E %.5E  %.5E', initial_state.energy, s,
                        math.sqrt((s2 - s * s) / n), dt))
    io.flush()
end
