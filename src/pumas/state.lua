-------------------------------------------------------------------------------
-- Monte Carlo state for PUMAS
-- Author: Valentin Niess
-- License: GNU LGPL-3.0
-------------------------------------------------------------------------------
local ffi = require('ffi')
local error = require('pumas.error')
local metatype = require('pumas.metatype')

local state = {}


-------------------------------------------------------------------------------
-- The Monte Carlo state metatype
-------------------------------------------------------------------------------
-- XXX Add generators for configuring an initial state

local State = {}

local ctype = ffi.typeof('struct pumas_state_extended')
local pumas_state_ptr = ffi.typeof('struct pumas_state *')


local function clear (self)
    if self == nil then
        error.raise{fname = 'clear', argnum = 'bad', expected = 1, got = 0}
    end

    ffi.fill(self._c, ffi.sizeof(ctype))
    return self
end


local function set (self, other)
    if other == nil then
        local nargs = (self ~= nil) and 1 or 0
        error.raise{fname = 'set', argnum = 'bad', expected = 2, got = nargs}
    end

    if metatype(other) ~= 'State' then
        error.raise{fname = 'set', argnum = 2, expected = 'a State table',
            got = metatype.a(other)}
    end

    ffi.copy(self._c, other._c, ffi.sizeof(ctype))
    return self
end


local function clone (self)
    if self == nil then
        error.raise{fname = 'clone', argnum = 'bad', expected = 1, got = 0}
    end

    local other = state.State()
    return other:set(self)
end


error.register('State.__index.clear', clear)
error.register('State.__index.clone', clone)
error.register('State.__index.set', set)


function State:__index (k)
    if k == '__metatype' then
        return 'State'
    elseif k == 'clear' then
        return clear
    elseif k == 'clone' then
        return clone
    elseif k == 'set' then
        return set
    elseif (k == 'position') or (k == 'direction') then
        return self._c[k]
    elseif k == 'decayed' then
        return (self._c.decayed ~= 0)
    else
        return tonumber(self._c[k])
    end
end


function State:__newindex (k, v)
    if ((k == 'position') or (k == 'direction')) and (v ~= nil) and
        (v.__metatype == 'Coordinates') then
        -- Get the Monte Carlo representation of the position or direction
        v = v:get()
    end

    self._c[k] = v
end


-------------------------------------------------------------------------------
-- The Monte Carlo state constructor
-------------------------------------------------------------------------------
state.State = setmetatable(State, {
    __call = function (cls, args)
        local c = ffi.cast(pumas_state_ptr, ffi.C.calloc(1, ffi.sizeof(ctype)))
        ffi.gc(c, ffi.C.free)

        local self = setmetatable({_c = c}, cls)

        if args ~= nil then
            local mt = metatype(args)
            if mt == 'State' then
                self:set(args)
            elseif mt == 'table' then
                c.charge = -1
                c.energy = 1
                c.weight = 1
                c.direction[2] = 1

                for k, v in pairs(args) do
                    self[k] = v
                end
            else
                error.raise{fname = 'State', argnum = 1,
                    expected = 'a (State) table', got = metatype.a(args)}
            end
        end

        return self
    end})


-------------------------------------------------------------------------------
-- Register the subpackage
-------------------------------------------------------------------------------
function state.register_to (t)
    t.State = state.State
end


-------------------------------------------------------------------------------
-- Return the package
-------------------------------------------------------------------------------
return state
