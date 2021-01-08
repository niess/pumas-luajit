-------------------------------------------------------------------------------
-- Wrapper for PUMAS enums
-- Author: Valentin Niess
-- License: GNU LGPL-3.0
-------------------------------------------------------------------------------
local ffi = require('ffi')
local error = require('pumas.error')

local enum = {}


-------------------------------------------------------------------------------
-- The Event metatype
-------------------------------------------------------------------------------
do
    ffi.cdef('struct pumas_event_w {enum pumas_event value;}')
    local event_t = ffi.typeof('struct pumas_event_w')

    local tags = {
        'none', 'start', 'medium', 'weight', 'stop', 'limit', 'vertex',
        'vertex_decay', 'vertex_del', 'limit_distance', 'limit_grammage',
        'limit_kinetic', 'limit_time', 'vertex_coulomb',
        'vertex_bremsstrahlung', 'vertex_delta_ray', 'vertex_pair_creation',
        'vertex_photonuclear'
    }

    local get_value
    do
        local mapping = {}
        for _, k in ipairs(tags) do
            mapping[k] = ffi.C['PUMAS_EVENT_'..k:upper()]
        end

        function get_value (k)
            local v = mapping[k]
            if v then
                return v
            else
                error("'pumas.Event' has no member named '"..k.."'", 3)
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
        if select('#', ...) then
            for _, k in ipairs({...}) do
                local b = get_value(k)
                self.value = bit.bor(self.value, b)
            end
        end
        return self
    end

    function Event.__eq (self, other)
        if ffi.istype(event_t, other) then
            return self.value == other.value
        else
            return self.value == other
        end
    end

    function Event.__index (self, k)
        if k == '__metatype' then
            return 'enum'
        end

        local b = get_value(k)
        if b == 0 then
            return self.value == 0
        else
            return bit.band(self.value, b) ~= 0
        end
    end

    function Event.__newindex (self, k, v)
        local b = get_value(k)
        if b == 0 then
            self.value = 0
        elseif v then
            self.value = bit.bor(self.value, b)
        else
            self.value = bit.band(self.value, bit.bnot(b))
        end
    end

    function Event.__tostring (self)
        local v = tonumber(self.value)
        local s = get_string(v)
        if s then return s end

        local t = {}
        for _, k in ipairs(tags) do
            local b = get_value(k)
            if b ~= 0 then
                if bit.band(self.value, b) == b then
                    table.insert(t, k)
                    self.value = bit.band(self.value, bit.bnot(b))
                end
            end
        end
        self.value = v
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

    local raise_error = error.ErrorFunction{fname = 'mode'}

    local function set1 (self, s, category)
        local r = strtoval[s]
        if r then
            local k, v = unpack(r)
            if category and (category ~= k) then
                for _, c in ipairs(categories) do
                    if c == category then
                        raise_error{fname = 'mode.'..category, argname = s,
                            description = 'invalid value', depth = 3}
                    end
                end
                raise_error{argname = category,
                    description = 'no such member', depth = 3}
            end
            self._c[k] = v
        else
            local depth = category and 2 or 4 -- XXX detect depth automaticaly
            raise_error{argname = s, description = 'no such value',
                depth = depth}
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
            return 'mode'
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
                raise_error{argname = k, description ='no such member',
                    depth = 2}
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

    function enum.Mode (c_context)
        local c = c_context.mode
        local default = {}
        for _, category in ipairs(categories) do
            default[category] = tonumber(c[category])
        end

        return setmetatable({_c = c, _default = default}, Mode)
    end
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
