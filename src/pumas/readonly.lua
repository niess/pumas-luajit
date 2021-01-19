-------------------------------------------------------------------------------
-- Wrapper for emulating a read-only table
-- Author: Valentin Niess
-- License: GNU LGPL-3.0
-------------------------------------------------------------------------------
local error = require('pumas.error')

local readonly = {}


if math.mod then
    -- Using Lua(JIT) 5.1 API
    readonly.Readonly = function (_, t) return t end
else
    -- Using Lua 5.2 API or LuaJIT with partial compatibility
    local instances = setmetatable({}, {__mode = 'k'})

    local Readonly = {}
    Readonly.__metatable = 'readonly'

    function Readonly:__index (k)
        self = instances[self]
        if k == '__metatype' then
            return self.metatype
        else
            return self.table[k]
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

    function Readonly:__pairs ()
        self = instances[self]
        return pairs(self.table)
    end

    function Readonly:__ipairs ()
        self = instances[self]
        return ipairs(self.table)
    end

    local function wrap (cls, t, type_, metatype)
        if not type_ then type_ = 'table' end

        local self = {}
        instances[self] = {table = t, ['type'] = type_, metatype = metatype}

        return setmetatable(self, cls)
    end

    readonly.Readonly = setmetatable(Readonly, {__call = wrap})
    error.register('Readonly', Readonly)
end

return readonly
