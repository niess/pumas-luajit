-------------------------------------------------------------------------------
-- Lua compability tweak(s) for PUMAS
-- Author: Valentin Niess
-- License: GNU LGPL-3.0
-------------------------------------------------------------------------------
local compat = {}


do
    local ok = pcall(require, 'table.new')
    if ok then
        compat.table_new = table.new
    else
        compat.table_new = function () return {} end
    end
end


return compat
