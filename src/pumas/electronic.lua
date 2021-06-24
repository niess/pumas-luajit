-------------------------------------------------------------------------------
-- Interface to the PUMAS electronic functions
-- Author: Valentin Niess
-- License: GNU LGPL-3.0
-------------------------------------------------------------------------------
local ffi = require('ffi')

local clib = require('pumas.clib')
local error = require('pumas.error')
local metatype = require('pumas.metatype')

-- XXX Allow Element or Material to be provided as target
local Electronic = {}
local functions = {}

do
    local raise_error = error.ErrorFunction{['type'] = 'electronic'}

    function Electronic:__index (k)
        if type(k) ~= 'string' then
            raise_error{bad_key = true, expected = 'a string',
                got = metatype.a(k)}
        end

        local f = self._functions[k]
        if f then
            return f
        else
            local getter = function () return clib['pumas_electronic_'..k] end
            local ok
            ok, f = pcall(getter)
            if ok then
                self._functions[k] = f
                return f
            else
                raise_error{bad_member = k}
            end
        end
    end
end


-------------------------------------------------------------------------------
-- Density effect
-------------------------------------------------------------------------------
do
    local raise_error = error.ErrorFunction{fname = 'density_effect'}

    local density_effect_c = clib['pumas_electronic_density_effect']

    local function density_effect (Z, A, ...)
        local w, I, density, gamma

        local tp = type(Z)

        local function check_type ()
            if type(A) ~= tp then
                raise_error{argnum = 2, expected = metatype.a(Z), got =
                    metatype.a(A)}
            elseif type(w) ~= tp then
                raise_error{argnum = 3, expected = metatype.a(Z), got =
                    metatype.a(w)}
            end
        end

        local n
        if tp == 'table' then
            w = select(1, ...)
            I = select(2, ...)
            density = select(3, ...)
            gamma = select(4, ...)
            check_type()
            n = #Z
            if (#A ~= n) or (#w ~= n) then
                local argnum, m
                if #A ~= n then
                    argnum, m = 2, #A
                else
                    argnum, m = 3, #w
                end

                raise_error{argnum = argnum, expected = 'a size '..n..' table',
                    got = 'a size'..m..' table'}
            end
        elseif tp == 'number' then
            w = 1
            I = select(1, ...)
            density = select(2, ...)
            gamma = select(3, ...)
            check_type()
            n = 1
        else
            raise_error{argnum = 1, expected = 'a number or a table',
                got = metatype.a(Z)}
        end

        Z = ffi.new('double [?]', n, Z)
        A = ffi.new('double [?]', n, A)
        w = ffi.new('double [?]', n, w)

        local ok, delta = pcall(density_effect_c, n, Z, A, w, I, density, gamma)
        if ok then
            return tonumber(delta)
        else
            error.raise('density_effect', delta)
        end
    end

    rawset(functions, 'density_effect', density_effect)
    error.register('electronic.__index.density_effect', density_effect)
end


-------------------------------------------------------------------------------
-- Energy loss
-------------------------------------------------------------------------------
do
    local raise_error = error.ErrorFunction{fname = 'energy_loss'}

    local energy_loss_c = clib['pumas_electronic_energy_loss']

    local function energy_loss (Z, A, ...)
        local w, I, density, mass, energy

        local tp = type(Z)

        local function check_type ()
            if type(A) ~= tp then
                raise_error{argnum = 2, expected = metatype.a(Z), got =
                    metatype.a(A)}
            elseif type(w) ~= tp then
                raise_error{argnum = 3, expected = metatype.a(Z), got =
                    metatype.a(w)}
            end
        end

        local n
        if tp == 'table' then
            w = select(1, ...)
            I = select(2, ...)
            density = select(3, ...)
            mass = select(4, ...)
            energy = select(5, ...)
            check_type()
            n = #Z
            if (#A ~= n) or (#w ~= n) then
                local argnum, m
                if #A ~= n then
                    argnum, m = 2, #A
                else
                    argnum, m = 3, #w
                end

                raise_error{argnum = argnum, expected = 'a size '..n..' table',
                    got = 'a size'..m..' table'}
            end
        elseif tp == 'number' then
            w = 1
            I = select(1, ...)
            density = select(2, ...)
            mass = select(3, ...)
            energy = select(4, ...)
            check_type()
            n = 1
        else
            raise_error{argnum = 1, expected = 'a number or a table',
                got = metatype.a(Z)}
        end

        Z = ffi.new('double [?]', n, Z)
        A = ffi.new('double [?]', n, A)
        w = ffi.new('double [?]', n, w)

        local ok, de = pcall(
            energy_loss_c, n, Z, A, w, I, density, mass, energy)
        if ok then
            return tonumber(de)
        else
            error.raise('energy_loss', de)
        end
    end

    rawset(functions, 'energy_loss', energy_loss)
    error.register('electronic.__index.energy_loss', energy_loss)
end


do
    function Electronic.__newindex ()
        error.raise{['type'] = 'pumas', not_mutable = 'electronic'}
    end
end


-------------------------------------------------------------------------------
-- Return the package
-------------------------------------------------------------------------------
return setmetatable({_functions = functions}, Electronic)
