-------------------------------------------------------------------------------
-- PUMAS wrapper
-- Author: Valentin Niess
-- License: GNU LGPL-3.0
-------------------------------------------------------------------------------
local clib = require('pumas.clib')

local pumas = {}


-------------------------------------------------------------------------------
-- Set the PUMAS library version tag
-------------------------------------------------------------------------------
do
    local tag = clib.pumas_version()
    local major = math.floor(tag / 1000)
    local minor = tag - major
    pumas.version = string.format('%d.%d', major, minor)
end


-------------------------------------------------------------------------------
-- Import and register the subpackages
-------------------------------------------------------------------------------
local function register (pkg)
    local p = require(pkg)
    if p.register_to then
        p.register_to(pumas)
    end
end

register('pumas.call')
register('pumas.compat')
register('pumas.context')
register('pumas.coordinates')
register('pumas.elements')
register('pumas.flux')
register('pumas.geometry')
register('pumas.enum')
register('pumas.materials')
register('pumas.medium')
register('pumas.metatype')
register('pumas.physics')
register('pumas.recorder')
register('pumas.state')

pumas.constants = require('pumas.constants')


-------------------------------------------------------------------------------
-- Register all API functions
-------------------------------------------------------------------------------
-- XXX what if only a sub-package is imported?
do
    local error_ = require('pumas.error')
    for k, v in pairs(pumas) do
        error_.register(k, v)
    end
end

-------------------------------------------------------------------------------
-- Return the package
-------------------------------------------------------------------------------
return pumas
