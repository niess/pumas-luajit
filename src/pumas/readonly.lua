-------------------------------------------------------------------------------
-- Wrapper for emulating a read-only table
-- Author: Valentin Niess
-- License: GNU LGPL-3.0
-------------------------------------------------------------------------------
local error = require('pumas.error')

local readonly = {}

-------------------------------------------------------------------------------
-- Local bookmarking of readonly tables
-------------------------------------------------------------------------------
local instances = setmetatable({}, {__mode = 'k'})

function readonly.rawget (t) return instances[t].table end


-------------------------------------------------------------------------------
-- The Readonly metatype
-------------------------------------------------------------------------------
local Readonly = {}

Readonly.__metatable = 'Readonly'


do
    -- Vanilla Lua 5.1 does not have the __pairs and __ipairs metamethods.
    -- Therefore we provide explicit iterators
    local function ipairs_ (self)
        if self == nil then
            error.raise{fname = 'ipairs', argnum = 1, expected = 'a table',
                got = 'nil'}
        end

        self = instances[self]
        return ipairs(self.table)
    end

    local function pairs_ (self)
        if self == nil then
            error.raise{fname = 'pairs', argnum = 1, expected = 'a table',
                got = 'nil'}
        end

        self = instances[self]
        return pairs(self.table)
    end

    local inspect

    local function inspect_ (self)
        if self == nil then
            error.raise{fname = 'inspect', argnum = 1, expected = 'a table',
                got = 'nil'}
        end

        if not inspect then
            local ok, result = pcall(require, 'inspect')
            if not ok then
                error.raise{fname = 'inspect', description = result}
            else
                inspect = result
            end
        end

        return inspect(instances[self], {process = function (item)
            return instances[item] or item
        end})
    end

    error.register('Readonly.__ipairs', ipairs_)
    error.register('Readonly.__pairs', pairs_)
    error.register('Readonly.__index.inspect', inspect_)

    function Readonly:__index (k)
        if k == 'inspect' then
            return inspect_
        elseif k == 'ipairs' then
            return ipairs_
        elseif k == 'pairs' then
            return pairs_
        else
            self = instances[self]
            if k == '__metatype' then
                return self.metatype
            else
                return self.table[k]
            end
        end
    end
end


function Readonly:__newindex (k)
    self = instances[self]
    error.raise{['type'] = self.type, not_mutable = k}
end


function Readonly:__len ()
    self = instances[self.table]
    return #self.table
end


function Readonly:__tostring ()
    self = instances[self]
    return tostring(self.table)
end


-------------------------------------------------------------------------------
-- The Readonly constructor
-------------------------------------------------------------------------------
do
    local function wrap (cls, t, type_, metatype)
        if not type_ then type_ = 'table' end

        local self = {}
        instances[self] = {table = t, ['type'] = type_, metatype = metatype}

        return setmetatable(self, cls)
    end

    readonly.Readonly = setmetatable(Readonly, {__call = wrap})

    error.register('Readonly', Readonly)
end


-------------------------------------------------------------------------------
-- Return the sub-package
-------------------------------------------------------------------------------
return readonly
