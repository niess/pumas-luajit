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

local event_tags = {
    'EVENT_LIMIT', 'EVENT_LIMIT_DISTANCE', 'EVENT_LIMIT_GRAMMAGE',
    'EVENT_LIMIT_KINETIC', 'EVENT_LIMIT_TIME', 'EVENT_MEDIUM',
    'EVENT_NONE', 'EVENT_START', 'EVENT_STOP', 'EVENT_VERTEX',
    'EVENT_VERTEX_BREMSSTRAHLUNG', 'EVENT_VERTEX_COULOMB',
    'EVENT_VERTEX_DECAY', 'EVENT_VERTEX_DEL', 'EVENT_VERTEX_DELTA_RAY',
    'EVENT_VERTEX_PAIR_CREATION', 'EVENT_VERTEX_PHOTONUCLEAR',
    'EVENT_WEIGHT'
}

local scheme_tags = {
    'SCHEME_CSDA', 'SCHEME_DETAILED', 'SCHEME_HYBRID', 'SCHEME_NO_LOSS'
}


-------------------------------------------------------------------------------
-- Register an enum category to a table
-- XXX Define a proper Enum metatype
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


-------------------------------------------------------------------------------
-- Register all enums to a table
-------------------------------------------------------------------------------
function enum.register_to (t)
    t.decay_tostring = Tagger(t, decay_tags)
    t.event_tostring = Tagger(t, event_tags)
    t.scheme_tostring = Tagger(t, scheme_tags)
end


-------------------------------------------------------------------------------
-- Return the package
-------------------------------------------------------------------------------
return enum
