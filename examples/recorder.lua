local pumas = require('pumas')

-- Load materials tabulations
pumas.PUMAS.load('share/materials/standard')

-- Build the geometry, an Earth fully covered with sea
local media = {}
media['Atmosphere'] = pumas.GradientMedium(
    'AirDry1Atm', 'exponential', 'vertical', -1E+04, 0, 1.205)
media['Seabed'] = pumas.UniformMedium('StandardRock')
media['Sea'] = pumas.UniformMedium('WaterLiquid')

local media_names = {}
for k, v in pairs(media) do
    media_names[v] = k
end

local geoid = pumas.TopographyData()
local geometry = pumas.EarthGeometry(
    {media['Seabed'], geoid, -100},
    {media['Sea'], geoid, 0},
    {media['Atmosphere'], geoid, 100}
)

-- Initialise the Monte Carlo state below the sea bed
local position = pumas.GeodeticPoint(45, 3, -100.5)
local frame = pumas.LocalFrame(position)
local deg = math.pi / 180
local direction = pumas.HorizontalVector{
    azimuth = 0 * deg, elevation = -10 * deg, norm = 1, frame = frame}

local state = pumas.State{
    charge = -1,
    kinetic = 1,
    weight = 1,
    position = position:get(),
    direction = direction:get()
}

-- Callback function used for printing Monte Carlo steps
local function print_step(state, medium, event)
    if event == pumas.EVENT_NONE then return end

    if bit.band(event, pumas.EVENT_STOP) == pumas.EVENT_STOP then
        event = pumas.event_tostring(event - pumas.EVENT_STOP)
    else
        event = pumas.event_tostring(event)
    end

    local geodetic = pumas.GeodeticPoint():set(state.position)
    local u0 = direction:get()
    local deflection = math.acos(state.direction[0] * u0[0] +
                                 state.direction[1] * u0[1] +
                                 state.direction[2] * u0[2]) * 180 / math.pi

    local medium_name = media_names[medium]

    print(string.format('%-10s  %.3E %10.3f %.5E %.5E  %s', medium_name,
                                                            state.kinetic,
                                                            geodetic.altitude,
                                                            state.distance,
                                                            deflection,
                                                            event))
end

-- Configure the simulation context for backward transport with a detailed
-- Physics
local context = pumas.Context {
    forward = false,
    longitudinal = false,
    scheme = pumas.SCHEME_DETAILED,
    geometry = geometry,
    random_seed = 0,
    recorder = pumas.Recorder(print_step)
}

-- Do the transport
print([[
medium       energy     altitude   distance   deflection  event
              (GeV)        (m)       (m)         (deg)
]])
context:transport(state)
