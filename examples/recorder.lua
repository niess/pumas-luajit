local pumas = require('pumas')

-- Build the geometry, an Earth fully covered with sea
local media = {}
media.atmosphere = pumas.GradientMedium('Air', {lambda = -1E+04})
media.sea = pumas.UniformMedium('Water')
media.seabed = pumas.UniformMedium('StandardRock')

local top_altitude, bottom_altitude = 100, -100
local geometry = pumas.EarthGeometry{
    {medium = media.atmosphere, data = top_altitude   },
    {medium = media.sea,        data = 0              },
    {medium = media.seabed,     data = bottom_altitude}
}

-- Initialise the Monte Carlo state below the sea bed
local latitude, longitude, altitude = 45, 3, bottom_altitude - 0.5
local position = pumas.GeodeticPoint(latitude, longitude, altitude)
local frame = pumas.LocalFrame(position)
local deg = math.pi / 180
local direction = pumas.HorizontalVector{
    azimuth = 0 * deg, elevation = -10 * deg, norm = 1, frame = frame}

local state = pumas.State{
    position = position,
    direction = direction
}

-- Create a backward simulation context with a detailed transport
local simulation = pumas.Context{
    physics = 'share/materials/standard',
    mode = 'backward detailed',
    geometry = geometry,
    random_seed = 0
}

-- Set a callback for printing Monte Carlo steps
local media_names = {}
for k, v in pairs(media) do
    media_names[v] = k
end

simulation.recorder = function (state, medium, event)
    if event.none then return end

    local geodetic = pumas.GeodeticPoint(state.position)
    local u0 = direction:get()
    local deflection = math.acos(state.direction[0] * u0[0] +
                                 state.direction[1] * u0[1] +
                                 state.direction[2] * u0[2]) * 180 / math.pi

    local medium_name = media_names[medium]

    print(string.format('%-10s  %.3E %10.3f %.5E %.5E  %s', medium_name,
                                                            state.energy,
                                                            geodetic.altitude,
                                                            state.distance,
                                                            deflection,
                                                            event))
end


-- Do the transport
print([[
medium       energy     altitude   distance   deflection  event
              (GeV)        (m)       (m)         (deg)
]])
simulation:transport(state)
