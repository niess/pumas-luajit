-------------------------------------------------------------------------------
-- The transparent medium placeholder
-- Author: Valentin Niess
-- License: GNU LGPL-3.0
-------------------------------------------------------------------------------
local clib = require('pumas.clib')
local error = require('pumas.error')
local base = require('pumas.medium.base')

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
        return base.BaseMedium.__index(self, k, strtype)
    end
end


function TransparentMedium:__newindex (k, v)
    if (k == 'density') or (k == 'magnet') or (k == 'material') then
        error.raise{
            ['type'] = strtype,
            not_mutable = k
        }
    else
        base.BaseMedium.__newindex(self, k, v, strtype)
    end
end


-------------------------------------------------------------------------------
-- Instantiate and register the transparent medium
-------------------------------------------------------------------------------
do
    local m = setmetatable({
        _c = clib.PUMAS_MEDIUM_TRANSPARENT,
    }, TransparentMedium)

    error.register('TranparentMedium', TransparentMedium)

    base.add(m)
    transparent.transparent_medium = m
end


-------------------------------------------------------------------------------
-- Return the package
-------------------------------------------------------------------------------
return transparent
