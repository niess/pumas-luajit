-------------------------------------------------------------------------------
-- Wraper for PUMAS recorders
-- Author: Valentin Niess
-- License: GNU LGPL-3.0
-------------------------------------------------------------------------------
local ffi = require('ffi')
local call = require('pumas.call')
local clib = require('pumas.clib')
local enum = require('pumas.enum')
local error = require('pumas.error')
local medium = require('pumas.medium')
local state = require('pumas.state')

local recorder = {}


-------------------------------------------------------------------------------
-- The recorder metatype
-------------------------------------------------------------------------------
local Recorder = {}


function Recorder:__index (k)
    if k == '__metatype' then
        return 'Recorder'
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
            if self._c.record ~= nil then
                self._c.record:free()
            end

            if v then
                local wrapped_state = state.State()
                local wrapped_event = enum.Event()
                self._c.record = ffi.cast('pumas_recorder_cb *',
                    function (_, c_state, c_medium, c_event)
                        local wrapped_medium = medium.get(c_medium)
                        ffi.copy(wrapped_state._c, c_state, state_size)
                        wrapped_event.value = c_event
                        v(wrapped_state, wrapped_medium, wrapped_event)
                    end)
            else
                self._c.record = nil
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
local function default_callback (state_, medium_, event)
    print(event, medium_, state_) -- XXX pretty print
end

do
    local function new (cls, callback, period)
        local ptr = ffi.new('struct pumas_recorder *[1]')
        call(clib.pumas_recorder_create, ptr, 0)
        local c = ptr[0]
        ffi.gc(c, function ()
            if c.record ~= nil then
                c.record:free()
            end
            clib.pumas_recorder_destroy(ptr)
        end)

        local self = setmetatable({_c = c}, cls)

        self.record = callback or default_callback
        self.period = period or 1

        return self
    end

    recorder.Recorder = setmetatable(Recorder, {__call = new})
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
