-------------------------------------------------------------------------------
-- Simulate the elastic scattering of muons through a thin target of standard
-- rock
--
-- PUMAS implements a mixed (condensed) Monte Carlo scheme for simulating the
-- multiuple scattering as detailed in Fernandez-Varea et al. (1993). In this
-- example all processes are disabled except the elastic scattering. This allows
-- comparison to a direct computation e.g. where all elastic collisions are
-- explicitly simulated.
--
-- References:
--   - Fernandez-Varea et al. (1993),
--     https://doi.org/10.1016/0168-583X(93)95827-R
--
-- Author: Valentin Niess
-------------------------------------------------------------------------------
local pumas = require('pumas')


-------------------------------------------------------------------------------
-- Simulation settings
-------------------------------------------------------------------------------
local muon_energy, path_length = 1, 25E-06
local theta_max, n_bins = 1E-03, 20         -- Histogram bins
local n_events = 1000000                    -- Number of Monte Carlo events


-------------------------------------------------------------------------------
-- Tune the elastic ratio for a thin target
--
-- The elastic ratio is set such that the interaction length for hard colisions
-- is 5% of the material thickness. In order to do so we need to compute the
-- first transport path length (lambda1) for the given material and projectile
-- energy, since the elastic ratio is normalized to the latter.
-------------------------------------------------------------------------------
local lambda1
do
    local material = pumas.materials['StandardRock']
    local cross_section = 0
    for symbol, weight in pairs(material.elements) do
        -- Loop over atomic constituants and update the macroscopic
        -- cross-section
        local element = pumas.elements[symbol]
        cross_section = cross_section +
            weight / pumas.elastic.length(1, element.Z, element.A,
                pumas.constants.MUON_MASS, muon_energy)
    end
    lambda1 = 1 / (cross_section * material.density)
end
local elastic_ratio = 5E-02 * path_length / lambda1


-------------------------------------------------------------------------------
-- Tabulate the physics with the tuned elastic ratio
-------------------------------------------------------------------------------
pumas.build{materials = {'StandardRock'}, path = 'share/materials/elastic',
    elastic_ratio = elastic_ratio}


-------------------------------------------------------------------------------
-- Create a virtual simulation context with energy loss processes disabled
-- but elastic scattering still enabled
-------------------------------------------------------------------------------
local simulation = pumas.Context{
    physics = 'share/materials/elastic',
    mode = 'virtual',
    geometry = 'StandardRock',
    limit = {distance = path_length}}


-------------------------------------------------------------------------------
-- Run the Monte Carlo
-------------------------------------------------------------------------------
local counts = {}
for i = 1, n_bins do counts[i] = 0 end

local initial_state = pumas.State{energy = muon_energy}
local state = pumas.State()
for _ = 1, n_events do
    state:set(initial_state)
    simulation:transport(state)

    -- Add the current event to the histogram
    local theta = math.atan2(state.direction[0], state.direction[2])
    if (theta >= -theta_max) and (theta < theta_max) then
        local i = math.floor((theta + theta_max) / (2 * theta_max) * n_bins) + 1
        counts[i] = counts[i] + 1
    end
end


-------------------------------------------------------------------------------
-- Print the result
-------------------------------------------------------------------------------
print('#    angle           pdf        uncert.')
print('#    (rad)        (rad^-1)     (rad^-1)')
local dx = 2 * theta_max / n_bins
local norm = 1 / (n_events * dx)
for i, yi in ipairs(counts) do
    local xi = (i - 0.5) * dx - theta_max
    print(string.format(' %12.5E   %12.5E %12.5E',
        xi, yi * norm, math.sqrt(yi) * norm))
end
