-------------------------------------------------------------------------------
-- Wrap calls to PUMAS C library in order to forward error messages
-- Author: Valentin Niess
-- License: GNU LGPL-3.0
-------------------------------------------------------------------------------
local ffi = require('ffi')
local error = require('pumas.error')


-------------------------------------------------------------------------------
-- Initialise the C error handler
-------------------------------------------------------------------------------
ffi.C.pumas_error_initialise()


-------------------------------------------------------------------------------
-- Pattern for decoding PUMAS C library error messages
-------------------------------------------------------------------------------
local pattern = '[^}]+} (.*)$'


-------------------------------------------------------------------------------
-- Call a PUMAS C library function and forward any error message
-------------------------------------------------------------------------------
local raise_error = error.ErrorFunction{header = 'C library error'}

local function ccall (self, func,...)
    if func(...) ~= 0 then
        local msg = ffi.string(ffi.C.pumas_error_get())
        raise_error(msg:match(pattern))
    end
end


-------------------------------------------------------------------------------
-- Protected call to a PUMAS C library function
-------------------------------------------------------------------------------
local function pccall (func,...)
    if func(...) ~= 0 then
        local msg = ffi.string(ffi.C.pumas_error_get())
        return msg:match(pattern)
    end
end


-------------------------------------------------------------------------------
-- Return the package
-------------------------------------------------------------------------------
return setmetatable(
    {protected = pccall},
    {__call = ccall})
