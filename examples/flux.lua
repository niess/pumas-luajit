local pumas = require('pumas')

-- Settings for the simulation
local latitude, longitude = 45, 3
local top_altitude = 1600

-- Build the geometry, an Earth with a flat topography
local atmosphere = pumas.GradientMedium('Air', {
    ['type'] = 'exponential', axis = 'vertical', lambda = -1E+04,
    z0 = 0, rho0 = 1.205})
local geometry = pumas.EarthGeometry{medium = atmosphere, data = top_altitude}

-- Wrap the primary flux model
--
-- The flux models use geodetic coordinates (altitude, zenith angle, ...) but
-- the Monte Carlo uses Cartesian ECEF ones. This wrapper does the coordinates
-- conversion from the Monte-Carlo to the flux model.
local flux
do
    local position = pumas.GeodeticPoint()
    local direction = pumas.CartesianVector()

    -- Tabulated flux model from CORSIKA simulations
    local flux_model = pumas.MuonFlux('tabulation', {altitude = top_altitude})

    function flux (state)
        position:set(state.position)
        if math.abs(position.altitude - top_altitude) > 1E-03 then return 0 end
        local frame = pumas.LocalFrame(position)
        direction:set(state.direction):transform(frame)
        return flux_model(state.kinetic, -direction.z, state.charge)
    end
end

-- Create a backward simulation context
local context = pumas.Context{
    physics = 'share/materials/standard',
    mode = 'backward longitudinal hybrid',
    limit = {kinetic = 1E+08},
    geometry = geometry
}

-- Set the initial state for Monte Carlo particles
local position = pumas.GeodeticPoint(latitude, longitude, 0)
local frame = pumas.LocalFrame(position)
local deg = math.pi / 180
local direction = pumas.HorizontalVector{
    azimuth = 0 * deg, elevation = -90 * deg, norm = 1, frame = frame}

local initial = pumas.State{
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

    initial.kinetic = 1E-02 * math.exp((ik - 1) * math.log(1E+08) / 80)
    local state = pumas.State()

    local s, s2, n = 0, 0, 10000
    for _ = 1, n do
        state:set(initial)

        -- Randomise the charge
        if context:random() < 0.5 then
            state.charge = -1
        else
            state.charge = 1
        end
        state.weight = state.weight * 2

        -- Do the transport
        context:transport(state)

        -- Update the flux
        local f = flux(state) * state.weight
        s = s + f
        s2 = s2 + f * f
    end
    s = s / n
    s2 = s2 / n

    local dt = os.clock() - t0

    print(string.format('%.5E  %.5E %.5E  %.5E', initial.kinetic, s,
                        math.sqrt((s2 - s * s) / n), dt))
    io.flush()
end
