-------------------------------------------------------------------------------
-- Wrapper for PUMAS enums
-- Author: Valentin Niess
-- License: GNU LGPL-3.0
-------------------------------------------------------------------------------
local ffi = require('ffi')
local error = require('pumas.error')
local metatype = require('pumas.metatype')

local enum = {}


-------------------------------------------------------------------------------
-- The Event metatype
-------------------------------------------------------------------------------
do
    ffi.cdef('struct pumas_event_w {enum pumas_event _value;}')
    local event_t = ffi.typeof('struct pumas_event_w')

    local tags = {
        'none', 'start', 'medium', 'weight', 'stop', 'limit', 'vertex',
        'vertex_decay', 'vertex_del', 'limit_distance', 'limit_grammage',
        'limit_energy', 'limit_time', 'vertex_coulomb',
        'vertex_bremsstrahlung', 'vertex_delta_ray', 'vertex_pair_creation',
        'vertex_photonuclear'
    }

    local raise_error = error.ErrorFunction{['type'] = 'Event'}

    local get_value
    do
        local mapping = {}
        for _, k in ipairs(tags) do
            mapping[k] = tonumber(ffi.C['PUMAS_EVENT_'..k:upper()])
        end

        function get_value (k)
            local v = mapping[k]
            if v then
                return v
            else
                raise_error{bad_member = k}
            end
        end
    end

    local get_string
    do
        local mapping = {}
        for _, k in ipairs(tags) do
            local v = tonumber(ffi.C['PUMAS_EVENT_'..k:upper()])
            mapping[v] = k
        end

        function get_string (k)
            return mapping[k]
        end
    end

    local Event = {}

    function Event.__new (ct, ...)
        local self = ffi.new(ct)

        local n = select('#', ...)
        if n == 1 then
            -- Copy constructor
            local arg = select(1, ...)
            if metatype(arg) == 'Event' then
                self._value = arg._value
                return self
            end
        end

        if n > 0 then
            for _, k in ipairs{...} do
                local b = get_value(k)
                self._value = bit.bor(tonumber(self._value), b)
            end
        end
        return self
    end

    function Event.__eq (self, other)
        if ffi.istype(event_t, other) then
            return self._value == other._value
        else
            return self._value == other
        end
    end

    local function clear (self)
        if not self then
            error.raise{fname = 'clear', argnum = 'bad', expected = 1, got = 0}
        elseif metatype(self) ~= 'Event' then
            error.raise{fname = 'clear', argnum = 1,
                expected = 'an Event table', got = metatype.a(self)}
        end

        self._value = 0
        return self
    end

    local function clone (self)
        if self == nil then
            error.raise{fname = 'clone', argnum = 'bad', expected = 1, got = 0}
        elseif metatype(self) ~= 'Event' then
            error.raise{fname = 'clone', argnum = 1,
                expected = 'an Event table', got = metatype.a(self)}
        end

        local other = enum.Event()
        other._value = self._value
        return other
    end

    function Event.__index (self, k)
        if k == '__metatype' then
            return 'Event'
        elseif k == 'clear' then
            return clear
        elseif k == 'clone' then
            return clone
        else
            local b = get_value(k)
            if b == 0 then
                return self._value == 0
            else
                return bit.band(tonumber(self._value), b) ~= 0
            end
        end
    end

    function Event.__newindex (self, k, v)
        local b = get_value(k)
        if b == 0 then
            self._value = 0
        elseif v then
            self._value = bit.bor(tonumber(self._value), b)
        else
            self._value = bit.band(tonumber(self._value), bit.bnot(b))
        end
    end

    function Event.__tostring (self)
        local v = tonumber(self._value)
        local s = get_string(v)
        if s then return s end

        local t = {}
        for _, k in ipairs(tags) do
            local b = get_value(k)
            if b ~= 0 then
                if bit.band(tonumber(self._value), b) == b then
                    table.insert(t, k)
                    self._value = bit.band(tonumber(self._value), bit.bnot(b))
                end
            end
        end
        self._value = v
        return table.concat(t, ' ')
    end

    enum.Event = ffi.metatype(event_t, Event)
end


-------------------------------------------------------------------------------
-- The Mode wrapper
-------------------------------------------------------------------------------
do
    local Mode = {}

    local tags = {
        {'direction', {'forward', 'backward'}},
        {'scattering', {'full_space', 'longitudinal'}},
        {'energy_loss', {'virtual', 'csda', 'hybrid', 'detailed'}},
        {'decay', {'stable', 'weight', 'decay'}}}

    local strtoval, valtostr, categories = {}, {}, {}
    for _, data in ipairs(tags) do
        local category, subtags = unpack(data)
        table.insert(categories, category)
        local t = {}
        valtostr[category] = t
        for _, k in ipairs(subtags) do
            local v = tonumber(ffi.C['PUMAS_MODE_'..k:upper()])
            strtoval[k] = {category, v}
            t[v] = k
        end
    end

    local function set1 (self, s, category)
        local r = strtoval[s]
        if r then
            local k, v = unpack(r)
            if category and (category ~= k) then
                for _, c in ipairs(categories) do
                    if c == category then
                        error.raise{fname = 'Mode.'..category, argname = s,
                            description = 'invalid value'}
                    end
                end
                error.raise{['type'] = 'Mode', bad_member = category}
            end
            self._c[k] = v
        else
            error.raise{['type'] = 'Mode', bad_member = s}
        end
    end

    local function set (self, str)
        for _, category in ipairs(categories) do
            self._c[category] = self._default[category]
        end

        for s in str:gmatch('[%w_]+') do
            set1(self, s)
        end
    end

    function Mode:__index (k)
        if k == '__metatype' then
            return 'Mode'
        elseif k == 'set' then
            return set
        else
            local ok = false
            for _, category in ipairs(categories) do
                if k == category then
                    ok = true
                    break
                end
            end
            if not ok then
                error.raise{['type'] = 'Mode', bad_member = k}
            else
                return valtostr[k][tonumber(self._c[k])]
            end
        end
    end

    function Mode:__newindex (k, s)
        set1(self, s, k)
    end

    function Mode:__tostring ()
        local t = {}
        for _, category in ipairs(categories) do
            table.insert(t, valtostr[category][tonumber(self._c[category])])
        end
        return table.concat(t, ' ')
    end

    local function new (cls, c_context)
        local c = c_context.mode
        local default = {}
        for _, category in ipairs(categories) do
            default[category] = tonumber(c[category])
        end

        return setmetatable({_c = c, _default = default}, cls)
    end

    enum.Mode = setmetatable(Mode, {__call = new})

    error.register('enum.Mode', Mode)
end


-------------------------------------------------------------------------------
-- Register enums to a table
-------------------------------------------------------------------------------
function enum.register_to (t)
    t.Event = enum.Event
end


-------------------------------------------------------------------------------
-- Return the package
-------------------------------------------------------------------------------
return enum
