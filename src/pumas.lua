-------------------------------------------------------------------------------
-- PUMAS wrapper
-- Author: Valentin Niess
-- License: GNU LGPL-3.0
-------------------------------------------------------------------------------
local ffi = require('ffi') -- XXX support vanilla Lua with cffi?
local lfs = require('lfs')
local os = require('pumas.os')
require('pumas.header.api')
require('pumas.header.extensions')
require('pumas.header.gull')
require('pumas.header.turtle')

local pumas = {}


-------------------------------------------------------------------------------
-- Prototypes of some standard C functions
-------------------------------------------------------------------------------
ffi.cdef [[
void * calloc(size_t, size_t);
void free(void *);
size_t fwrite(const void * ptr, size_t size, size_t nmemb,
    struct FILE * stream);
void * malloc(size_t);
]]


-------------------------------------------------------------------------------
-- Load the C libraries and their extensions, if not embedded in the runtime
-------------------------------------------------------------------------------
do
    local ok = pcall(function () return ffi.C.pumas_error_initialise end)
    if not ok then
        local _, path =...-- Lua 5.2
        if path == nil then
            path = debug.getinfo(1, 'S').source:sub(2) -- Lua 5.1
        end
        if (love ~= nil) and (lfs.attributes(path) == nil) then
            -- Patch for Love when the module is located in-source
            path = love.filesystem.getSource()..path
        end

        local dirname = path:match('(.*'..os.PATHSEP..')')
        local libname = '../../../lib/lua/5.1/pumas/libpumas_extended.'..
            os.LIBEXT
        ffi.load(dirname..libname, true) -- XXX Load to private space?
    end
end


-------------------------------------------------------------------------------
-- Set the PUMAS library version tag
-------------------------------------------------------------------------------
do
    local tag = ffi.C.pumas_version()
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


-------------------------------------------------------------------------------
-- Register all API functions
-------------------------------------------------------------------------------
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
