local pumas = require('pumas')

-- Simulation settings
local mode = 'forward longitudinal csda'
local n_events = 100000
local energy_min, energy_max = 1E-02, 1E+06
local distance = 1E+00

-- Set the primary flux model
local flux = pumas.MuonFlux{model = 'gccly', axis = {0, 0, 1}}

-- Create a simulation context
local is_forward = mode:find('forward')
local energy_limit
if is_forward then
    energy_limit = energy_min
else
    energy_limit = energy_max
end

local simulation = pumas.Context{
    physics = 'share/materials/examples',
    mode = mode,
    limit = {distance = distance, energy = energy_limit},
    geometry = 'StandardRock'
}

-- Set the initial state for Monte Carlo particles
local initial_state = pumas.State{
    position = {0, 0, 0},
    direction = {0, 0, -1}
}

-- Loop over events
local state = pumas.State()
local lne = math.log(energy_max / energy_min)
local s, s2 = 0, 0
for i = 1, n_events do
    state:set(initial_state)

    -- Randomise the kinetic energy
    state.energy = energy_min * math.exp(lne * simulation:random())
    state.weight = state.weight * lne * state.energy

    -- Randomise the electric charge
    if simulation:random() < 0.5 then
        state.charge = -1
    else
        state.charge = 1
    end
    state.weight = state.weight * 2

    -- Sample the primary flux (in forward mode)
    if is_forward then
        flux:sample(state)
    end

    -- Do the transport
    simulation:transport(state)

    if (state.energy > energy_min) and
       (state.energy < energy_max) and
       (state.weight > 0)
       then
        -- Backward sample the primary flux
        if not is_forward then
            -- Reset the particle position & direction in order to match the
            -- primary flux model. Note that those are arbitrary in this example
            -- but there must be consistent with the primary model.
            state.position = initial_state.position
            state.direction = initial_state.direction

            flux:sample(state)
        end

        s = s + state.weight
        s2 = s2 + state.weight * state.weight
    end
end

-- Print summary statistics
s = s / n_events
s2 = s2 / n_events

print(string.format('%.5E +- %.5E', s, math.sqrt((s2 - s * s) / n_events)))
