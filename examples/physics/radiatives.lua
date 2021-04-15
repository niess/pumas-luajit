-------------------------------------------------------------------------------
-- Tabulate the energy loss for radiative processes
-- Author: Valentin Niess
-------------------------------------------------------------------------------
local pumas = require('pumas')


-------------------------------------------------------------------------------
-- Parse the material name from command line argument(s)
-------------------------------------------------------------------------------
local material
do
    local name = arg[1] or 'StandardRock'
    material = pumas.materials[name]

    if material == nil then
        error("unknown material '"..name.."'")
    end
end


-------------------------------------------------------------------------------
-- List of DCS models to tabulate
-------------------------------------------------------------------------------
local models = {'bremsstrahlung KKP', 'bremsstrahlung ABB',
    'bremsstrahlung SSR', 'pair_production KKP', 'pair_production SSR',
    'photonuclear DRSS', 'photonuclear BM', 'photonuclear BBKS'}


-------------------------------------------------------------------------------
-- Compute beta = -1/E * dE/dx for a given atomic element and projectile
-- kinetic energy
-------------------------------------------------------------------------------
local function compute_beta(Z, A, K)
    local m = pumas.constants.MUON_MASS
    local E = K + m
    local xmin, xmax, n = 1E-06, 1, 241
    local dlx = math.log(xmax  / xmin) / (n - 1)
    local factor = E * pumas.constants.AVOGADRO_NUMBER / A * 1E+04 -- cm^2 / g
    local beta = {}
    for i, model in ipairs(models) do
        -- Compute beta as the 1st momentum of the DCS. A numeric integration
        -- with the trapeze method is done
        local I = 0.
        for j = 0, n - 1 do
            local x = xmin * math.exp(j * dlx)
            local q = E * x
            local fij = x * pumas.dcs[model](Z, A, m, K, q) * factor
            if (j == 0) or (j == n - 1) then
                fij = fij * 0.5
            end
            I = I + fij * x * dlx
        end
        beta[i] = I
    end
    return beta
end


-------------------------------------------------------------------------------
-- Tabulate beta values
-------------------------------------------------------------------------------
local Kmin, Kmax, n = 1E-01, 1E+09, 201
local dlk = math.log(Kmax  / Kmin) / (n - 1)
for i = 0, n - 1 do
    local K = Kmin * math.exp(i * dlk)
    local beta = {}
    for symbol, weight in pairs(material.elements) do
        local element = pumas.elements[symbol]
        local b = compute_beta(element.Z, element.A, K)
        for k, v in ipairs(b) do
            if not beta[k] then beta[k] = 0. end
            beta[k] = beta[k] + v * weight
        end
    end
    local t = {}
    for j, v in ipairs(beta) do
        t[j] = string.format('%.5E', v)
    end
    print(string.format('%.5E ', K)..table.concat(t, ' '))
end
