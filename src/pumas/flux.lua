-------------------------------------------------------------------------------
-- Open sky muon flux models for PUMAS
-- Author: Valentin Niess
-- License: GNU LGPL-3.0
-------------------------------------------------------------------------------
local clib = require('pumas.clib')
local coordinates = require('pumas.coordinates')
local error = require('pumas.error')
local metatype = require('pumas.metatype')
local physics = require('pumas.physics')

local flux = {}


-------------------------------------------------------------------------------
-- Flux scaling according to a constant charge ratio
-------------------------------------------------------------------------------
local function ChargeRatio (charge_ratio)
    return function (charge)
        if charge == nil then
            return 1
        elseif charge < 0 then
            return 1 / (1 + charge_ratio)
        else
            return charge_ratio / (1 + charge_ratio)
        end
    end
end


-------------------------------------------------------------------------------
-- Gaisser muon flux model
--
-- Ref: Particle Data Group (Cosmic Rays)
-------------------------------------------------------------------------------
local function GaisserFlux (normalisation, gamma, charge_ratio)
    local ratio = ChargeRatio(charge_ratio)

    return function (kinetic_energy, cos_theta, charge)
        if cos_theta < 0 then return 0 end
        local Emu = kinetic_energy + physics.MUON_MASS
        local ec = 1.1 * Emu * cos_theta
        local rpi = 1 + ec / 115
        local rK = 1 + ec / 850
        return normalisation * math.pow(Emu, -gamma) *
               (1 / rpi + 0.054 / rK) * ratio(charge)
    end
end


-------------------------------------------------------------------------------
-- Volkova's parameterization of cos(theta*)
-------------------------------------------------------------------------------
local cos_theta_star
do
    local p = { 0.102573, -0.068287, 0.958633, 0.0407253, 0.817285 }

    function cos_theta_star (cos_theta)
        local cs2 = (cos_theta * cos_theta + p[1] * p[1] +
                     p[2] * math.pow(cos_theta, p[3]) +
                     p[4] * math.pow(cos_theta, p[5])) /
                    (1 + p[1] * p[1] + p[2] + p[4])
        return (cs2 > 0) and math.sqrt(cs2) or 0
    end
end


-------------------------------------------------------------------------------
-- GCCLY flux model
--
-- Ref: https://arxiv.org/abs/1509.06176
-------------------------------------------------------------------------------
local function GcclyFlux (normalisation, gamma, charge_ratio)
    local gaisser = GaisserFlux(normalisation, gamma, charge_ratio)

    return function (kinetic_energy, cos_theta, charge)
        local cs = cos_theta_star(cos_theta)
        if cs < 0 then return 0 end
        local Emu = kinetic_energy + physics.MUON_MASS
        return math.pow(1 + 3.64 / (Emu * math.pow(cs, 1.29)), -gamma) *
               gaisser(kinetic_energy, cs, charge)
    end
end


-------------------------------------------------------------------------------
-- Chirkin's parameterization of average mass overburden as function of
-- x=cos(theta), in g/cm^2
-------------------------------------------------------------------------------
local mass_overburden
do
    local p = { -0.017326, 0.114236, 1.15043, 0.0200854, 1.16714 }

    function mass_overburden (x)
        return 1E+02 / (p[1] + p[2] * math.pow(x, p[3]) +
                        p[4] * math.pow((1 - x * x), p[5]))
    end
end


-------------------------------------------------------------------------------
-- Chirkin's parameterization of average muon path length as function of
-- x=cos(theta), in m
-------------------------------------------------------------------------------
local path_length
do
    local p = { 1.3144, 50.2813, 1.33545, 0.252313, 41.0344 }

    function path_length (x)
        return 1E+06 / (p[1] + p[2] * math.pow(x, p[3]) +
                        p[4] * math.pow((1 - x * x), p[5]))
    end
end


-------------------------------------------------------------------------------
-- Chirkin flux model
--
-- Ref: https://arxiv.org/abs/hep-ph/0407078
-------------------------------------------------------------------------------
local function ChirkinFlux (normalisation, gamma, charge_ratio)
    local gaisser = GaisserFlux(normalisation, gamma, charge_ratio)

    local a = 2.62E-03
    local b = 3.05E-06
    local astar = 0.487E-03
    local bstar = 8.766E-06
    local X0 = 114.8
    local c0 = astar - bstar * a / b
    c0 = c0 * c0
    local c1 = (astar * astar - c0) / a
    local c2 = bstar * bstar / b
    local d1 = 0.054

    return function (kinetic_energy, cos_theta, charge)
        local cs = cos_theta_star(cos_theta)
        if cs < 0 then return 0 end

        -- Calculate the effective initial energy, EI, and its derivative
        local EI, dEIdEf
        do
            local X = mass_overburden(cos_theta) - X0
            local ebx = math.exp(b * X)
            local Ef = kinetic_energy + physics.MUON_MASS
            local Ei = ((a + b * Ef) * ebx - a) / b

            local sE = 0.5 * c2 * (Ei * Ei - Ef * Ef) + c1 * (Ei - Ef) +
                       c0 / b * math.log((a + b * Ei) / (a + b * Ef))
            local dXf = astar + bstar * Ef
            local dXi = astar + bstar * Ei
            local dsEdEf = ebx * dXi * dXi / (a + b * Ei) -
                           dXf * dXf / (a + b * Ef)
            local d0 = 1.1 * cs / 115
            local d2 = 1.1 * cs / 850
            local d01 = 1 / (1 + d0 * Ei)
            local d21 = 1 / (1 + d2 * Ei)
            local num1 = d0 * d01 * d01
            local num2 = d1 * d2 * d21 * d21
            local num = num1 + num2
            local iden = 1 / (d01 + d1 * d21)
            local fr = -gamma / Ei - num * iden
            local dfrdEf = gamma / (Ei * Ei) +
                           (num * num * iden + 2 * (d0 * num1 * d01 +
                                                    d2 * num2 * d21)) * iden
            EI = Ei + 0.5 * sE * fr
            dEIdEf = math.abs(ebx * (1 + 0.5 * dfrdEf * sE) +
                              0.5 * fr * dsEdEf)
        end

        -- Calculate the survival factor (W)
        local d0 = path_length(cos_theta)
        local ctau = 658.65
        local W = math.exp(-d0 / ctau * physics.MUON_MASS / EI)

        -- Return the modified Gaisser's flux
        return dEIdEf * W * gaisser(EI, cs, charge)
    end
end


-------------------------------------------------------------------------------
-- Muon flux metatype
-------------------------------------------------------------------------------
local MuonFlux = {}

do
    local function sample (self, state)
        if metatype(self) ~= 'MuonFlux' then
            error.raise{fname = 'sample', argnum = 1,
                expected = 'a MuonFlux table', got = metatype.a(self)}
        elseif metatype(state) ~= 'State' then
            error.raise{fname = 'sample', argnum = 2,
                expected = 'a State table', got = metatype.a(state)}
        end

        local cos_theta
        if self._axis == 'vertical' then
            self._position:set(state.position)
            local altitude = self._altitude + self._origin
            if math.abs(self._position.altitude - altitude) > 1E-03 then
                return false
            end
            local frame = coordinates.LocalFrame(self._position)
            self._direction:set(state.direction):transform(frame)
            cos_theta = -self._direction.z
        else
            local z = (state.position[0] - self._origin[0]) * self._axis[0] +
                      (state.position[1] - self._origin[1]) * self._axis[1] +
                      (state.position[2] - self._origin[2]) * self._axis[2]
            if math.abs(z - self._altitude) > 1E-03 then
                return false
            end

            cos_theta = -state.direction[0] * self._axis[0] -
                         state.direction[1] * self._axis[1] -
                         state.direction[2] * self._axis[2]
        end

        local f = self._spectrum(state.energy, cos_theta, state.charge)
        state.weight = state.weight * f

        return true, f
    end

    local function spectrum (self, energy, cos_theta, charge)
        if metatype(self) ~= 'MuonFlux' then
            error.raise{fname = 'spectrum', argnum = 1,
                expected = 'a MuonFlux table', got = metatype.a(self)}
        end

        return self._spectrum(energy, cos_theta, charge)
    end

    function MuonFlux:__index (k)
        if k == '__metatype' then
            return 'MuonFlux'
        elseif k == 'sample' then
            return sample
        elseif k == 'spectrum' then
            return spectrum
        elseif k == 'altitude' then
            return self._altitude
        elseif k == 'model' then
            return self._model
        else
            error.raise{['type'] = 'MuonFlux', bad_member = k}
        end
    end
end


function MuonFlux.__newindex (_, k)
    if (k == 'altitude') or (k == 'model') then
        error.raise{['type'] = 'MuonFlux', not_mutable = k}
    else
        error.raise{['type'] = 'MuonFlux', bad_member = k}
    end
end


-------------------------------------------------------------------------------
-- Muon flux constructor
-------------------------------------------------------------------------------
-- XXX Allow a user defined muon spectrum
-- XXX Allow a range of altitudes for muon spectrum

do
    local raise_error = error.ErrorFunction{fname = 'MuonFlux'}

    local function new (cls, model, options)
        if model == nil then
            raise_error{argnum = 'bad',  expected = '1 or 2', got = 0}
        end
        if options == nil then options = {} end

        local self = {_model = model}

        -- Set the vertical axis and the origin of the model
        local axis = options.axis or 'vertical'
        if axis == 'vertical' then
            self._position = coordinates.GeodeticPoint()
            self._direction = coordinates.CartesianVector()
            self._axis = axis

            local origin = options.origin or 0
            if type(origin) == 'number' then
                self._origin = origin
            else
                raise_error{argname = 'origin', expected = 'a number',
                    got = metatype.a(origin)}
            end
        else
            local mt = metatype(axis)
            if mt == 'table' then
                self._axis = coordinates.CartesianVector(axis)
            else
                self._axis = coordinates.CartesianVector():set(axis)
            end

            local origin = options.origin or {0, 0, 0}
            mt = metatype(origin)
            if mt == 'table' then
                self._origin = coordinates.CartesianPoint(origin)
            else
                self._origin = coordinates.CartesianPoint():set(origin)
            end
        end

        local altitude = options.altitude or 0
        if type(altitude) == 'number' then
            self._altitude = altitude
        else
            raise_error{argname = 'altitude', expected = 'a number',
                got = metatype.a(altitude)}
        end

        local tag = model:lower()
        if tag == 'tabulation' then
            local normalisation = 1
            for k, v in pairs(options) do
                if k == 'normalisation' then
                    normalisation = v
                elseif k ~= 'altitude' then
                    raise_error{
                        argnum = 2,
                        description = "unknown option '"..k..
                                      "' for 'tabulation' model"
                    }
                end
            end

            local data = clib.pumas_flux_tabulation_data[1]
            -- XXX interpolate with altitude

            self._spectrum = function (kinetic_energy, cos_theta, charge)
                if charge == nil then charge = 0 end
                return clib.pumas_flux_tabulation_get(data, kinetic_energy,
                    cos_theta, charge) * normalisation
            end

            return setmetatable(self, cls)
        end

        local charge_ratio, gamma, normalisation
        for k, v in pairs(options) do
            if k == 'charge_ratio' then charge_ratio = v
            elseif k == 'gamma' then
                gamma = v
            elseif k == 'normalisation' then normalisation = v
            else
                raise_error{
                    argnum = 2,
                    description = "unknown option '"..k..
                                  "' for '"..model.."' model"
                }
            end
        end

        charge_ratio = charge_ratio or 1.2766
        -- Ref: CMS (https://arxiv.org/abs/1005.5332)

        if tag == 'gaisser' then
            gamma = gamma or 2.7
            normalisation = normalisation or 1.4E+03
            self._spectrum = GaisserFlux(normalisation, gamma, charge_ratio)
        elseif tag == 'gccly' then
            gamma = gamma or 2.7
            normalisation = normalisation or 1.4E+03
            self._spectrum = GcclyFlux(normalisation, gamma, charge_ratio)
        elseif tag == 'chirkin' then
            gamma = gamma or 2.715
            normalisation = normalisation or 9.814E+02
            self._spectrum = ChirkinFlux(normalisation, gamma, charge_ratio)
        else
            raise_error{
                argnum = 1,
                description = "'unknown flux model '"..model.."'"
            }
        end

        return setmetatable(self, cls)
    end

    flux.MuonFlux = setmetatable(MuonFlux, {__call = new})
end


-------------------------------------------------------------------------------
-- Register the subpackage
-------------------------------------------------------------------------------
function flux.register_to (t)
    t.MuonFlux = flux.MuonFlux
end


-------------------------------------------------------------------------------
-- Return the package
-------------------------------------------------------------------------------
return flux
