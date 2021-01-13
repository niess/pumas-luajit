-------------------------------------------------------------------------------
-- Loader for the PUMAS C library
-- Author: Valentin Niess
-- License: GNU LGPL-3.0
-------------------------------------------------------------------------------
local ffi = require('ffi') -- XXX support vanilla Lua with cffi?
local os = require('pumas.os')
require('pumas.header.api')
require('pumas.header.extensions')
require('pumas.header.gull')
require('pumas.header.turtle')

local clib


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
-- Load the C libraries and their extensions if not embedded in the runtime
-------------------------------------------------------------------------------
do
    local ok = pcall(function () return ffi.C.pumas_error_initialise end)
    if ok then
        clib = ffi.C
    else
        local _, path = ... -- Lua 5.2
        if path == nil then
            path = debug.getinfo(1, 'S').source:sub(2) -- Lua 5.1
        end
        local dirname = path:match('(.*'..os.PATHSEP..')') or ''

        local libname = 'libpumas_extended.'..os.LIBEXT

        local love = _G.love
        if love then
            -- For love2d the module is expected be located in the source
            -- XXX Could love.filesystem be used instead of lfs?
            dirname = love.filesystem.getSource()..dirname
            path = dirname..libname
        else
            -- For Lua modules the C library is installed under lib/ while
            -- this source is under share/.
            -- XXX this is likely OS specific
            local version = _VERSION:match('[0-9.]+')
            path = dirname..table.concat({'..', '..', '..', '..', 'lib', 'lua',
                version, 'pumas', libname}, os.PATHSEP)
        end

        clib = ffi.load(path)
    end
end


-------------------------------------------------------------------------------
-- Return the package
-------------------------------------------------------------------------------
return clib
