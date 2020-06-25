local gettime = require 'socket' .gettime

-- Load materials tabulations
PUMAS.load('share/materials/standard')

-- Build the geometry, an Earth with a flat topography
local deg = math.pi / 180
local latitude, longitude = 45, 3
local geoid = TopographyData()
local air = GradientMedium('AirDry1Atm', 'exponential',
                           'vertical', -1E+04, 0, 1.205E-03)

local top_altitude = 1600
local geometry = EarthGeometry({air, geoid, top_altitude})

-- Wrap the primary flux model
--
-- The flux models use geodetic coordinates (altitude, zenith angle, ...) but
-- the Monte Carlo uses Cartesian ECEF ones. This wrapper does the coordinates
-- conversion from the Monte-Carlo to the flux model.
local flux
do
    local position = GeodeticPoint()
    local direction = CartesianVector()

    -- Tabulated flux model from CORSIKA simulations
    local flux_model = MuonFlux('tabulation', {altitude = top_altitude})

    function flux (state)
        position:set(state.position)
        if math.abs(position.altitude - top_altitude) > 1E-03 then return 0 end
        local frame = LocalFrame(position)
        direction:set(state.direction):transform(frame)
        return flux_model(state.kinetic, -direction.z, state.charge)
    end
end

-- Configure an hybrid simulation context, a la MUM
local context = Context {
    forward = false,
    longitudinal = true,
    scheme = SCHEME_HYBRID,
    kinetic_limit = 1E+08,
    geometry = geometry
}

-- Set the initial state for Monte Carlo particles
local position = GeodeticPoint(latitude, longitude, 0)
local frame = LocalFrame(position)
local direction = HorizontalVector{azimuth = 0 * deg, elevation = -90 * deg,
                                   norm = 1, frame = frame}

local initial = State {
    weight = 1,
    position = position:get(),
    direction = direction:get()
}

-- Loop over energies, using a logarithmic binning, and backward sample the
-- flux model
print([[
  energy        flux       sigma         time
   (GeV)     (GeV^-1 m^-2 s^-1 sr^-1)     (s)
]])

for ik = 1, 81 do
    local t0 = gettime()

    initial.kinetic = 1E-02 * math.exp((ik - 1) * math.log(1E+08) / 80)
    local state = State()

    local s, s2, n = 0, 0, 10000
    for i = 1, n do
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

    local dt = gettime() - t0

    print(string.format('%.5E  %.5E %.5E  %.5E', initial.kinetic, s,
                        math.sqrt((s2 - s * s) / n), dt))
    io.flush()
end
