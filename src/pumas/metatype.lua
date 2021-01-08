-------------------------------------------------------------------------------
-- Extended type functions handling PUMAS metatypes as well
-- Author: Valentin Niess
-- License: GNU LGPL-3.0
-------------------------------------------------------------------------------


-------------------------------------------------------------------------------
-- Return the PUMAS metatype. Fallback to the usual type otherwise
-------------------------------------------------------------------------------
local function metatype (_, obj)
    local tp = type(obj)
    if (tp == 'table') or (tp == 'cdata') then
        mt = obj.__metatype
        if mt then return mt else return tp end
    else
        return tp
    end
end


-------------------------------------------------------------------------------
-- Return `a {metatype}` handling the nil case and metatypes
-------------------------------------------------------------------------------
local function a_metatype (obj)
    local mt = metatype(nil, obj)
    if mt == 'nil' then
        return mt
    else
        local tp = type(obj)
        if mt ~= tp then
            mt = mt..' '..tp
        end
        return 'a '..mt
    end
end


-------------------------------------------------------------------------------
-- Return the package
-------------------------------------------------------------------------------
return setmetatable(
    {a = a_metatype},
    {__call = metatype})
