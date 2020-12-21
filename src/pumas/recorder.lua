-------------------------------------------------------------------------------
-- Wraper for PUMAS recorders
-- Author: Valentin Niess
-- License: GNU LGPL-3.0
-------------------------------------------------------------------------------
local call = require('pumas.call')
local error = require('pumas.error')
local ffi = require('pumas.ffi')
local medium = require('pumas.medium')
local state = require('pumas.state')

local recorder = {}


-------------------------------------------------------------------------------
-- The recorder metatype
-------------------------------------------------------------------------------
local Recorder = {}


function Recorder:__index (k)
    if k == '__metatype' then
        return 'recorder'
    elseif k == 'period' then
        return self._c.period
    elseif k == 'record' then
        return self._record
    else
        error.raise{
            ['type'] = 'Recorder',
            bad_member = k
        }
    end
end


do
    local state_size = ffi.sizeof('struct pumas_state')

    function Recorder:__newindex (k, v)
        if k == 'record' then
            if self._c.record ~= ffi.nullptr then
                self._c.record:free()
            end

            local wrapped_state = state.State()
            self._c.record = ffi.cast('pumas_recorder_cb *',
                function (_, c_state, c_medium, event)
                    local wrapped_medium = medium.get(c_medium)
                    ffi.copy(wrapped_state._c, c_state, state_size)
                    v(wrapped_state, wrapped_medium, tonumber(event))
                end)
            rawset(self, '_record', v)
        elseif k == 'period' then
            rawget(self, '_c').period = v
        else
            error.raise{
                ['type'] = 'Recorder',
                bad_member = k
            }
        end
    end
end


-------------------------------------------------------------------------------
-- The recorder constructor
-------------------------------------------------------------------------------
local function default_callback (state_, medium_, event)
    print(event, medium_, state_) -- XXX pretty print
end

function recorder.Recorder (callback, period)
    local ptr = ffi.new('struct pumas_recorder *[1]')
    call(ffi.C.pumas_recorder_create, ptr, 0)

    local c = ptr[0]
    local self = setmetatable({_c = c}, Recorder)
    ffi.gc(c, function (self)
        if self.record ~= ffi.nullptr then
            self.record:free()
        end
        ffi.C.pumas_recorder_destroy(ptr)
    end)

    self.record = callback or default_callback
    self.period = period or 1

    return self
end


-------------------------------------------------------------------------------
-- Register the subpackage
-------------------------------------------------------------------------------
function recorder.register_to (t)
    t.Recorder = recorder.Recorder
end


-------------------------------------------------------------------------------
-- Return the package
-------------------------------------------------------------------------------
return recorder
