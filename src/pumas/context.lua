-------------------------------------------------------------------------------
-- Monte Carlo simulation context for PUMAS
-- Author: Valentin Niess
-- License: GNU LGPL-3.0
-------------------------------------------------------------------------------
local ffi = require('ffi')
local call = require('pumas.call')
local error = require('pumas.error')
local medium = require('pumas.medium')
local metatype = require('pumas.metatype')

local context = {}


-------------------------------------------------------------------------------
-- The Monte Carlo context metatype
-------------------------------------------------------------------------------
-- XXX Lazy data set / get in order to handle re-initialisation of the
-- PUMAS library (& MT)
local Context = {}
local ctype = ffi.typeof('struct pumas_context')


function Context:__index (k)
    if k == '__metatype' then
        return 'context'
    elseif k == 'geometry' then
        return self._geometry
    elseif k == 'recorder' then
        return self._recorder
    elseif k == 'random_seed' then
        return self._random_seed
    else
        return rawget(self, '_c')[k]
    end
end


local function event_set (self, flag)
    local c = rawget(self, '_c')
    c.event = bit.bor(tonumber(c.event), flag)
end


local function event_unset (self, flag)
    local c = rawget(self, '_c')
    if bit.band(tonumber(c.event), flag) == flag then
        c.event = c.event - flag
    end
end


local function get_random_seed ()
    local seed
    local f = io.open('/dev/urandom', 'rb') -- XXX Windows case?
    if f == nil then
        seed = os.time()
    else
        local s = f:read(4)
        f:close()
        seed = 0
        for i = 1, s:len() do seed = seed * 256 + s:byte(i) end
    end

    return seed
end


do
    local pumas_geometry_t = ffi.typeof('struct pumas_geometry')
    local pumas_recorder_t = ffi.typeof('struct pumas_recorder')

    function Context:__newindex (k, v)
        if k == 'distance_max' then
            if v == nil then
                event_unset(self, pumas.EVENT_LIMIT_DISTANCE)
                v = 0
            else
                event_set(self, pumas.EVENT_LIMIT_DISTANCE)
            end
        elseif k == 'grammage_max' then
            if v == nil then
                event_unset(self, pumas.EVENT_LIMIT_GRAMMAGE)
                v = 0
            else
                event_set(self, pumas.EVENT_LIMIT_GRAMMAGE)
            end
        elseif k == 'kinetic_limit' then
            if v == nil then
                event_unset(self, pumas.EVENT_LIMIT_KINETIC)
                v = 0
            else
                event_set(self, pumas.EVENT_LIMIT_KINETIC)
            end
        elseif k == 'time_max' then
            if v == nil then
                event_unset(self, pumas.EVENT_LIMIT_TIME)
                v = 0
            else
                event_set(self, pumas.EVENT_LIMIT_TIME)
            end
        elseif k == 'geometry' then
            local current_geometry = rawget(self, '_geometry')
            if current_geometry == v then return end

            if current_geometry ~= nil then
                ffi.C.pumas_geometry_destroy(self._c)
            end

            if (v ~= nil) and (v.__metatype ~= 'geometry') then
                error.raise{
                    header = 'bad type',
                    expected = 'a geometry',
                    got = metatype.a(v)
                }
            end

            rawset(self, '_geometry', v)
            return
        elseif k == 'random_seed' then
            if v == nil then
                v = get_random_seed()
            end
            local c = rawget(self, '_c')
            ffi.C.pumas_random_initialise(c, v)

            rawset(self, '_random_seed', v)
            return
        elseif k == 'recorder' then
            if v == nil then
                rawset(self, '_recorder', nil)
                self._c.recorder = nil
            else
                if v.__metatype ~= 'recorder' then
                    error.raise{
                        header = 'bad type',
                        expected = 'a recorder',
                        got = metatype.a(v)
                    }
                end
                rawset(self, '_recorder', v)
                self._c.recorder = v._c
            end
            return
        elseif k == 'geometry_callback' then
            local user_data = ffi.cast('struct pumas_user_data *',
                                       self._c.user_data)
            local wrapped_state = pumas.State()
            user_data.geometry.callback =
                function (geometry, state, c_medium, step)
                    local wrapped_medium = medium.get(c_medium)
                    ffi.copy(wrapped_state._c, state,
                        ffi.sizeof('struct pumas_state_extended'))
                    v(geometry, wrapped_state, wrapped_medium, step)
                end
            return
        end

        rawget(self, '_c')[k] = v
    end
end


local pumas_state_t = ffi.typeof('struct pumas_state')
local pumas_state_extended_ptr = ffi.typeof('struct pumas_state_extended *')

local function transport (self, state)
    if state == nil then
        local nargs = (self ~= nil) and 1 or 0
        error.raise{
            fname = 'transport',
            argnum = 'bad',
            expected = 2,
            got = nargs
        }
    end

    if state.__metatype ~= 'state' then
        error.raise{
            fname = 'transport',
            argnum = 2,
            expected = 'a state',
            got = metatype.a(state)
        }
    end

    local extended_state = ffi.cast(pumas_state_extended_ptr, state._c)
    ffi.C.pumas_state_extended_reset(extended_state, self._c)

    self._geometry:_update(self)
    call(ffi.C.pumas_transport, self._c, state._c, self._cache.event,
             self._cache.media)
    local media = table.new(2, 0)

    for i = 1, 2 do
        if self._cache.media[i - 1] ~= nil then
            media[i] = medium.get(self._cache.media[i - 1])
        end
    end
    return self._cache.event[0], media
end


local function medium_callback (self, state)
    if state == nil then
        local nargs = (self ~= nil) and 1 or 0
        error.raise{
            fname = 'medium',
            argnum = 'bad',
            expected = 2,
            got = nargs
        }
    end

    if state.__metatype ~= 'state' then
        error.raise{
            fname = 'medium',
            argnum = 2,
            expected = 'a state',
            got = metatype.a(state)
        }
    end

    local extended_state = ffi.cast(pumas_state_extended_ptr, state._c)
    ffi.C.pumas_state_extended_reset(extended_state, self._c)

    self._geometry:_update(self)
    self._c.medium(self._c, state._c, self._cache.media,
                   self._cache.distance)

    local wrapped_medium
    if self._cache.media[0] ~= nil then
            wrapped_medium = medium.get(self._cache.media[0])
    end
    return wrapped_medium, self._cache.distance[0]
end


local function random (self, n)
    if (type(self) ~= 'table') or (self.__metatype ~= 'context') then
        error.raise{
            fname = 'random',
            argnum = 1,
            expected = 'a context',
            got = metatype.a(self)
        }
    end

    local c = rawget(self, '_c')

    if n == nil then
        return c:random()
    else
        if type(n) ~= 'number' then
            error.raise{
                fname = 'random',
                argnum = 2,
                expected = 'a number',
                got = metatype.a(n)
            }
        end
        local t = table.new(n, 0)
        for i = 1, n do
            t[i] = c:random()
        end
        return unpack(t)
    end
end


-------------------------------------------------------------------------------
-- Monte Carlo context constructor
-------------------------------------------------------------------------------
function context.Context (args)
    if args and type(args) ~= 'table' then
        error.raise{
            fname = 'Context',
            argnum = 1,
            expected = 'a table',
            got = metatype.a(args)
        }
    end

    local ptr = ffi.new('struct pumas_context *[1]')
    call(ffi.C.pumas_context_create, ptr,
            ffi.sizeof('struct pumas_user_data'))
    local c = ptr[0]
    ffi.gc(c, function () ffi.C.pumas_context_destroy(ptr) end)

    c.random = ffi.C.pumas_random_uniform01
    c.medium = ffi.C.pumas_geometry_medium

    local user_data = ffi.cast('struct pumas_user_data *', c.user_data)
    user_data.geometry.top = nil
    user_data.geometry.current = nil
    user_data.geometry.callback = nil

    local self = setmetatable({
        _c = c,
        medium = medium_callback,
        transport = transport,
        random = random,
        _cache = {
            distance = ffi.new('double [1]'),
            event = ffi.new('enum pumas_event [1]'),
            media = ffi.new('struct pumas_medium *[2]')
        }
    }, Context)

    local seeded = false
    if args ~= nil then
        for k, v in pairs(args) do
            self[k] = v
            if k == 'random_seed' then
                seeded = true
            end
        end
    end

    if not seeded then
        self.random_seed = nil
    end

    return self
end


-------------------------------------------------------------------------------
-- Register the subpackage
-------------------------------------------------------------------------------
function context.register_to (t)
    t.Context = context.Context
end


-------------------------------------------------------------------------------
-- Return the package
-------------------------------------------------------------------------------
return context
