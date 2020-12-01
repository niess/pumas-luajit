-------------------------------------------------------------------------------
-- Atomic elements for PUMAS
-- Author: Valentin Niess
-- License: GNU LGPL-3.0
-------------------------------------------------------------------------------
local error = require('pumas.error')

local elements = {}


-------------------------------------------------------------------------------
-- The atomic Element metatype
-------------------------------------------------------------------------------
local mt = {__index = {}}

mt.__index.__metatype = 'element'

do
    local raise_error = error.ErrorFunction{fname = 'Element'}

    function elements.Element (Z, A, I)
        local index, tp
        if type(Z) ~= 'number' then index, tp = 1, type(Z) end
        if type(A) ~= 'number' then index, tp = 2, type(A) end
        if type(I) ~= 'number' then index, tp = 3, type(I) end
        if index ~= nil then
            raise_error{
                argnum = index,
                expected = 'a number',
                got = 'a '..tp
            }
        end

        local self = table.new(0, 3)
        self.Z = Z
        self.A = A
        self.I = I

        return setmetatable(self, mt)
    end
end


-------------------------------------------------------------------------------
-- Build the Elements table
-------------------------------------------------------------------------------
elements.ELEMENTS = require('pumas.data.elements')

for k, v in pairs(elements.ELEMENTS) do
    elements.ELEMENTS[k] = setmetatable(v, mt)
end


-------------------------------------------------------------------------------
-- Register the subpackage
-------------------------------------------------------------------------------
function elements.register_to (t)
    for k, v in pairs(elements) do
        t[k] = v
    end
end


-------------------------------------------------------------------------------
-- Return the package
-------------------------------------------------------------------------------
return elements
