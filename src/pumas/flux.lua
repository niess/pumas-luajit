-------------------------------------------------------------------------------
-- Open sky muon flux models for PUMAS
-- Author: Valentin Niess
-- License: GNU LGPL-3.0
-------------------------------------------------------------------------------
local ffi = require('ffi')
local lfs = require('lfs')
local clib = require('pumas.clib')
local constants = require('pumas.constants')
local coordinates = require('pumas.coordinates')
local error = require('pumas.error')
local metatype = require('pumas.metatype')

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
        local Emu = kinetic_energy + constants.MUON_MASS
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
        local Emu = kinetic_energy + constants.MUON_MASS
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
            local Ef = kinetic_energy + constants.MUON_MASS
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
        local W = math.exp(-d0 / ctau * constants.MUON_MASS / EI)

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

        local altitude, cos_theta
        if self._axis == 'vertical' then
            self._position:set(state.position)
            altitude = self._position.altitude - self._origin
            if rawget(self, '_altitude') and
               (math.abs(self._altitude - altitude) > 1E-03) then
                return false
            end
            local frame = coordinates.LocalFrame(self._position)
            self._direction:set(state.direction):transform(frame)
            cos_theta = -self._direction.z
        else
            altitude = (state.position[0] - self._origin.x) * self._axis.x +
                       (state.position[1] - self._origin.y) * self._axis.y +
                       (state.position[2] - self._origin.z) * self._axis.z
            if rawget(self, '_altitude') and
               (math.abs(altitude - self._altitude) > 1E-03) then
                return false
            end

            cos_theta = -state.direction[0] * self._axis.x -
                         state.direction[1] * self._axis.y -
                         state.direction[2] * self._axis.z
        end

        local f = self._spectrum(
            state.energy, cos_theta, state.charge, altitude)
        state.weight = state.weight * f

        return true, f
    end

    local function spectrum (self, energy, cos_theta, charge, altitude)
        if metatype(self) ~= 'MuonFlux' then
            error.raise{fname = 'spectrum', argnum = 1,
                expected = 'a MuonFlux table', got = metatype.a(self)}
        end

        return self._spectrum(energy, cos_theta, charge, altitude)
    end

    function MuonFlux:__index (k)
        if k == '__metatype' then
            return 'MuonFlux'
        elseif k == 'sample' then
            return sample
        elseif k == 'spectrum' then
            return spectrum
        elseif k == 'altitude' then
            return rawget(self, '_altitude')
        elseif k == 'model' then
            return rawget(self, '_model')
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
do
    local raise_error = error.ErrorFunction{fname = 'MuonFlux'}

    local function new (cls, options)
        options = options or {}

        local model = options.model or 'mceq'
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

        -- Set any default altitude
        if options.altitude then
            if type(options.altitude) == 'number' then
                self._altitude = options.altitude
            else
                raise_error{argname = 'altitude', expected = 'a number',
                    got = metatype.a(options.altitude)}
            end
        end

        local tag, data
        if type(model) == 'string' then
            if lfs.attributes(model, 'mode') == 'file' then
                data = clib.pumas_flux_tabulation_load(model)
                if data == nil then
                    raise_error{argname = 'model',
                        description = 'could not load flux tabulation from '..
                        model}
                end
                ffi.gc(data, ffi.C.free)
                self._data = data
            else
                tag = model:lower()
            end
        elseif type(model) ~= 'function' then
            raise_error{argname = 'model',
                expected = 'a function or a string', got = metatype.a(model)}
        end

        if (tag == 'mceq') or (tag == nil) or data then
            local normalisation = 1
            for k, v in pairs(options) do
                if k == 'normalisation' then
                    if type(v) == 'number' then
                        normalisation = v
                    else
                        raise_error{argname = 'normalisation',
                            expected = 'a number', got = metatype.a(v)}
                    end
                elseif (k ~= 'altitude') and (k ~= 'axis') and
                    (k ~= 'model') and (k ~= 'origin')
                then
                    raise_error{
                        argnum = 2, description = "unknown option '"..k..
                        "' for 'mceq' model"}
                end
            end

            if tag or data then
                if not data then
                    data = clib.pumas_flux_tabulation_data[0]
                end

                self._spectrum = function (
                    kinetic_energy, cos_theta, charge, altitude)
                    altitude = altitude or rawget(self, '_altitude') or 0
                    charge = charge or 0
                    return clib.pumas_flux_tabulation_get(data, kinetic_energy,
                        cos_theta, altitude, charge) * normalisation
                end
            else
                self._spectrum = function (
                    kinetic_energy, cos_theta, charge, altitude)
                    altitude = altitude or rawget(self, '_altitude') or 0
                    return model(data, kinetic_energy, cos_theta, charge,
                        altitude) * normalisation
                end
            end

            return setmetatable(self, cls)
        end

        local charge_ratio, gamma
        local normalisation = 1
        local function parse_args ()
            for k, v in pairs(options) do
                if k == 'charge_ratio' then charge_ratio = v
                elseif k == 'gamma' then
                    gamma = v
                elseif k == 'normalisation' then normalisation = v
                elseif (k ~= 'altitude') and (k ~= 'axis') and (k ~= 'model')
                    and (k ~= 'origin')
                then
                    raise_error{
                        argnum = 2,
                        description = "unknown option '"..k..
                                      "' for '"..model.."' model"
                    }
                end
            end

            charge_ratio = charge_ratio or 1.2766
            -- Ref: CMS (https://arxiv.org/abs/1005.5332)
        end

        if tag == 'gaisser' then
            parse_args()
            gamma = gamma or 2.7
            normalisation = normalisation * 1.4E+03
            self._spectrum = GaisserFlux(normalisation, gamma, charge_ratio)
        elseif tag == 'gccly' then
            parse_args()
            gamma = gamma or 2.7
            normalisation = normalisation * 1.4E+03
            self._spectrum = GcclyFlux(normalisation, gamma, charge_ratio)
        elseif tag == 'chirkin' then
            parse_args()
            gamma = gamma or 2.715
            normalisation = normalisation * 9.814E+02
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
