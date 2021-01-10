-------------------------------------------------------------------------------
-- Lua compability tweak(s) for PUMAS
-- Author: Valentin Niess
-- License: GNU LGPL-3.0
-------------------------------------------------------------------------------
local compat = {}


-------------------------------------------------------------------------------
-- Wrapper for table.new
-------------------------------------------------------------------------------
do
    local ok = pcall(require, 'table.new')
    if ok then
        compat.table_new = table.new
    else
        compat.table_new = function () return {} end
    end
end


-------------------------------------------------------------------------------
-- Wrapper for time
-------------------------------------------------------------------------------
do
    local ok, socket = pcall(require, 'socket')
    if ok then
        compat.time = function () return socket.gettime() end
    else
        compat.time = function () return os.time() end
    end
end


-------------------------------------------------------------------------------
-- Register the subpackage
-------------------------------------------------------------------------------
function compat.register_to (t)
    t.time = compat.time
end


-------------------------------------------------------------------------------
-- Return the package
-------------------------------------------------------------------------------
return compat
