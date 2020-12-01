-------------------------------------------------------------------------------
-- Extended type functions handling PUMAS metatypes as well
-- Author: Valentin Niess
-- License: GNU LGPL-3.0
-------------------------------------------------------------------------------


-------------------------------------------------------------------------------
-- Return the PUMAS metatype. Fallback to the usual type otherwise
-------------------------------------------------------------------------------
local function metatype (self, obj)
    local tp = obj.__metatype
    if tp ~= nil then
        if type(tp) == 'string' then
            return tp
        end
        return tostring(tp):match('<[^>]+>')
    else
        return type(obj)
    end
end


-------------------------------------------------------------------------------
-- Return `a {metatype}` handling the nil case
-------------------------------------------------------------------------------
local function a_metatype (obj)
    local tp = metatype(nil, obj)
    if tp == 'nil' then
        return tp
    else
        return 'a '..tp
    end
end


-------------------------------------------------------------------------------
-- Return the package
-------------------------------------------------------------------------------
return setmetatable(
    {a = a_metatype},
    {__call = metatype})
