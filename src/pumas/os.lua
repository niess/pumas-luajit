-------------------------------------------------------------------------------
-- Extended OS package with some extra constants
-- Author: Valentin Niess
-- License: GNU LGPL-3.0
-------------------------------------------------------------------------------
local jit = require('jit')

local os_ = {}

for k, v in pairs(os) do
    os_[k] = v
end

if jit.os == 'Windows' then
    os_.PATHSEP = '\\'
    os_.LINESEP = '\r\n'
    os_.LIBEXT = 'dll'
else
    os_.PATHSEP = '/'
    os_.LINESEP = '\n'
    os_.LIBEXT = 'so'
end

return os_
