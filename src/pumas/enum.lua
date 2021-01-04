-------------------------------------------------------------------------------
-- Wrapper for PUMAS enums
-- Author: Valentin Niess
-- License: GNU LGPL-3.0
-------------------------------------------------------------------------------
local ffi = require('ffi')

local enum = {}


-------------------------------------------------------------------------------
-- Enum tags per category
-------------------------------------------------------------------------------
local decay_tags = {
    'DECAY_NONE', 'DECAY_PROCESS', 'DECAY_WEIGHT'
}

local scheme_tags = {
    'SCHEME_CSDA', 'SCHEME_DETAILED', 'SCHEME_HYBRID', 'SCHEME_NO_LOSS'
}


-------------------------------------------------------------------------------
-- Register an enum category to a table
-- XXX Define a mode enum for Monte Carlo context
-------------------------------------------------------------------------------
local function Tagger (t, tags)
    local mapping = {}

    for _, tag in ipairs(tags) do
        local index = ffi.C['PUMAS_'..tag]
        t[tag] = index
        mapping[index] = tag
    end

    return function (i)
        return mapping[i]
    end
end

enum.decay_tostring = Tagger(enum, decay_tags)
enum.scheme_tostring = Tagger(enum, scheme_tags)


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
-- Register all enums to a table
-------------------------------------------------------------------------------
function enum.register_to (t)
    for k, v in pairs(enum) do
        t[k] = v
    end
end


-------------------------------------------------------------------------------
-- Return the package
-------------------------------------------------------------------------------
return enum
