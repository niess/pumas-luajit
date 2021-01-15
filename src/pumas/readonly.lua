-------------------------------------------------------------------------------
-- Wrapper for emulating a read-only table
-- Author: Valentin Niess
-- License: GNU LGPL-3.0
-------------------------------------------------------------------------------
local error = require('pumas.error')

local wrap
if math.mod then
    -- Using Lua(JIT) 5.1 API
    wrap = function (_, t) return t end
else
    -- Using Lua 5.2 API or LuaJIT with partial compatibility
    wrap = function (_, t, type_, metatype)
        if not type_ then type_ = 'table' end

        return setmetatable({}, {
            __index = function (_, k)
                if metatype and (k == '__metatype') then
                    return metatype
                else
                    return t[k]
                end
            end,
            __newindex = function (_, k)
                error.raise{['type'] = type_, not_mutable = k}
            end,
            __metatable = 'readonly',
            __len = function () return #t end,
            __tostring = function () return tostring(t) end,
            __pairs = function () return pairs(t) end,
            __ipairs = function () return ipairs(t) end
        })
    end

    -- XXX How to register to error API? Avoid one function per table
end

return setmetatable({}, {__call = wrap})
