-------------------------------------------------------------------------------
-- Monte Carlo state for PUMAS
-- Author: Valentin Niess
-- License: GNU LGPL-3.0
-------------------------------------------------------------------------------
local ffi = require('ffi')
local error = require('pumas.error')

local state = {}


-------------------------------------------------------------------------------
-- The Monte Carlo state metatype
-------------------------------------------------------------------------------
local State = {}

local ctype = ffi.typeof('struct pumas_state_extended')
local pumas_state_ptr = ffi.typeof('struct pumas_state *')


local function clear (self)
    ffi.fill(self._c, ffi.sizeof(ctype))
    return self
end


local function set (self, other)
    if other == nil then
        local nargs = (self ~= nil) and 1 or 0
        error.raise {
            fname = 'set',
            argnum = 'bad',
            expected = 2,
            got = nargs
        }
    end

    ffi.copy(self._c, other._c, ffi.sizeof(ctype))
    return self
end


function State:__index (k)
    if k == '__metatype' then
        return 'state'
    elseif k == 'clear' then
        return clear
    elseif k == 'set' then
        return set
    else
        return self._c[k]
    end
end


function State:__newindex (k, v)
    if ((k == 'position') or (k == 'direction')) and (v ~= nil) and
        (v.__metatype == 'coordinates') then
        -- Get the Monte Carlo representation of the position or direction
        v = v:get()
    end

    self._c[k] = v
end


-------------------------------------------------------------------------------
-- The Monte Carlo state constructor
-------------------------------------------------------------------------------
function state.State (args)
    local c = ffi.cast(pumas_state_ptr, ffi.C.calloc(1, ffi.sizeof(ctype)))
    ffi.gc(c, ffi.C.free)

    local self = setmetatable({_c = c}, State)

    if args ~= nil then
        for k, v in pairs(args) do
            self[k] = v
        end
    end

    return self
end


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
