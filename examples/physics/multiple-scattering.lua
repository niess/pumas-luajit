-------------------------------------------------------------------------------
-- Simulate the multiple scattering distribution of muons for some experimental
-- configurations
--
-- The following configurations have been implemented:
--
--   1. HYPERON, Akimenko et al. (1996) :
--      - 7.3 GeV /c muon beam on a 14.36 cm thick Cu target.
--
--   2. MUSCAT, Attwood et al. (2006) :
--      - 172 MeV/c muon beam on 1.5 mm of Al or 0.24 mm of Fe.
--
-- Reference:
--   - Akimenko et al. (1996),
--     https://doi.org/10.1016/0168-9002(86)90990-3
--
--   - Attwood et al. (2006),
--     https://doi.org/10.1016/j.nimb.2006.05.006
--
-- Author: Valentin Niess
-------------------------------------------------------------------------------
local pumas = require('pumas')


-------------------------------------------------------------------------------
-- Parse the setup from the command line
-------------------------------------------------------------------------------
local setup = arg[1] or 'Al'


-------------------------------------------------------------------------------
-- Build the scattering target
-------------------------------------------------------------------------------
local bins, material, momentum, thickness
if setup == 'Cu' then
    -- Akimenko et al. (1984)
    material, thickness, momentum = 'Copper', 1.436E-02, 7.3
    bins = {1E-03, 2E-03, 3E-03, 4E-03, 5E-03, 6E-03, 7E-03, 8E-03, 9E-03,
        13E-03, 17E-03, 21E-03, 25E-03, 29E-03, 7.}
else
    -- Attwood et al. (2006)
    bins = {0.00269, 0.00895, 0.0162, 0.0248, 0.0347, 0.0463, 0.0597, 0.0754,
        0.0938, 0.1151, 7.}
    momentum = 0.172

    if setup == 'Al' then
        material, thickness = 'Aluminum', 1.5E-03
    elseif setup == 'Fe' then
        material, thickness = 'Iron', 0.24E-03
    else
        error("bad setup '"..setup.."'")
    end
end

local function Box (center, hx, hy, hz)
    local x0, y0, z0 = unpack(center)

    return {
      x0 + hx, 0, 0,  1,  0,  0,
      0, y0 + hy, 0,  0,  1,  0,
      0, 0, z0 + hz,  0,  0,  1,
      x0 - hx, 0, 0, -1,  0,  0,
      0, y0 - hy, 0,  0, -1,  0,
      0, 0, z0 - hz,  0,  0, -1
    }
end

local geometry = pumas.PolyhedronGeometry{material,
    Box({0, 0, 0.5 * thickness}, 10, 10, 0.5 * thickness)}


-------------------------------------------------------------------------------
-- Tabulate the physics
-------------------------------------------------------------------------------
pumas.build{materials = {material}, path = 'share/materials/elastic'}


-------------------------------------------------------------------------------
-- Create a detailed simulation context
-------------------------------------------------------------------------------
local simulation = pumas.Context{
    physics = 'share/materials/elastic',
    geometry = geometry}


-------------------------------------------------------------------------------
-- Initial muon state
-------------------------------------------------------------------------------
local mass = pumas.constants.MUON_MASS
local energy = math.sqrt(momentum^2 + mass^2) - mass
local initial_state = pumas.State{energy = energy}


-------------------------------------------------------------------------------
-- Run the Monte Carlo
-------------------------------------------------------------------------------
local counts = {}
for i = 1,#bins do counts[i] = 0 end

local n = 10000000
local state = pumas.State()
for _ = 1, n do
    state:set(initial_state)
    simulation:transport(state)

    local epsilon = 1E-09
    if (state.energy > 0.1E-03) and
       (state.position[2] >= thickness - epsilon) then
        local theta
        if setup == 'Cu' then
            local rho = math.sqrt(state.direction[0]^2 + state.direction[1]^2)
            theta = math.atan2(rho, state.direction[2])
        else
            theta = math.atan2(state.direction[1], state.direction[2])
            theta = math.abs(theta)
        end
        for i, v in ipairs(bins) do
            if theta < v then
                counts[i] = counts[i] + 1
                break
            end
        end
    end
end


-------------------------------------------------------------------------------
-- Print the result
-------------------------------------------------------------------------------
print('# angle       pdf      uncert.')
print('# (rad)    (rad^-1)   (rad^-1)')
local xlow = 0.
for i, xi in ipairs(bins) do
    local a
    if setup == 'Cu' then
        a = math.pi * (xi^2 - xlow^2)
    else
        a = 2 * (xi - xlow)
    end
    local norm = 1. / (n * a)
    local yi = counts[i]
    xlow = xi
    print(string.format('%.4f   %.5E %.5E',
        xi, yi * norm, math.sqrt(yi) * norm))
end
