-------------------------------------------------------------------------------
-- Wraper for PUMAS recorders
-- Author: Valentin Niess
-- License: GNU LGPL-3.0
-------------------------------------------------------------------------------
local ffi = require('ffi')
local call = require('pumas.call')
local error = require('pumas.error')
local medium = require('pumas.medium')

local recorder = {}


-------------------------------------------------------------------------------
-- The recorder metatype
-------------------------------------------------------------------------------
local Recorder = {}


do
    local ctype = ffi.typeof('struct pumas_recorder')

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
end


do
    local state_size = ffi.sizeof('struct pumas_state')

    function Recorder:__newindex (k, v)
        if k == 'record' then
            local wrapped_state = pumas.State()
            rawget(self, '_c').record =
                function (context, state, c_medium, event)
                    local wrapped_medium = medium.get(c_medium)
                    ffi.copy(wrapped_state._c, state, state_size)
                    v(wrapped_state, wrapped_medium, tonumber(event))
                end
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
local function default_callback (state, medium, event)
    print(event, medium, state) -- XXX pretty print
end

function recorder.Recorder (callback, period)
    local ptr = ffi.new('struct pumas_recorder *[1]')
    call(ffi.C.pumas_recorder_create, ptr, 0)
    local c = ptr[0]
    ffi.gc(c, function () ffi.C.pumas_recorder_destroy(ptr) end)

    local self = setmetatable({_c = c}, Recorder)

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
