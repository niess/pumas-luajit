-------------------------------------------------------------------------------
-- The transparent medium placeholder
-- Author: Valentin Niess
-- License: GNU LGPL-3.0
-------------------------------------------------------------------------------
local base = require('pumas.medium.base')
local ffi = require('ffi')

local transparent = {}


-------------------------------------------------------------------------------
-- Metatype for the transparent medium
-------------------------------------------------------------------------------
local TransparentMedium = {}
local strtype = 'TransparentMedium'


function TransparentMedium:__index (k)
    if k == 'density' then
        return 0
    elseif (k == 'magnet') or (k == 'material') then
        return nil
    else
        return BaseMedium.__index(self, k, strtype)
    end
end


function TransparentMedium:__newindex (k, v)
    if (k == 'density') or (k == 'magnet') or (k == 'material') then
        error.raise{
            ['type'] = strtype,
            not_mutable = k
        }
    else
        BaseMedium.__newindex(self, k, v, strtype)
    end
end


-------------------------------------------------------------------------------
-- Instantiate and register the transparent medium
-------------------------------------------------------------------------------
do
    local m = setmetatable({
        _c = ffi.C.PUMAS_MEDIUM_TRANSPARENT,
        _material = 'Transparent'
    }, TransparentMedium)

    base.add(m)
    transparent.MEDIUM_TRANSPARENT = m
end


-------------------------------------------------------------------------------
-- Return the package
-------------------------------------------------------------------------------
return transparent