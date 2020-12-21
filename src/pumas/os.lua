-------------------------------------------------------------------------------
-- Extended OS package with some extra constants
-- Author: Valentin Niess
-- License: GNU LGPL-3.0
-------------------------------------------------------------------------------
local os_ = {}

for k, v in pairs(os) do
    os_[k] = v
end

local pathsep = package.config:sub(1,1)

if pathsep == '\\' then
    os_.LINESEP = '\r\n'
    os_.LIBEXT = 'dll'
else
    os_.LINESEP = '\n'
    os_.LIBEXT = 'so'
end
os_.PATHSEP = pathsep

return os_
