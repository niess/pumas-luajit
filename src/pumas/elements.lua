-------------------------------------------------------------------------------
-- Atomic elements for PUMAS
-- Author: Valentin Niess
-- License: GNU LGPL-3.0
-------------------------------------------------------------------------------
local compat = require('pumas.compat')
local error = require('pumas.error')

local elements = {}


-------------------------------------------------------------------------------
-- The atomic Element metatype
-------------------------------------------------------------------------------
local Element = {__index = {}}

Element.__index.__metatype = 'Element'

do
    local raise_error = error.ErrorFunction{fname = 'Element'}

    local function new (cls, Z, A, I)
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

        local self = compat.table_new(0, 3)
        self.Z = Z
        self.A = A
        self.I = I

        return setmetatable(self, cls)
    end

    elements.Element = setmetatable(Element, {__call = new})
end


-------------------------------------------------------------------------------
-- Build the Elements table
-------------------------------------------------------------------------------
elements.ELEMENTS = require('pumas.data.elements')

for k, v in pairs(elements.ELEMENTS) do
    elements.ELEMENTS[k] = setmetatable(v, Element)
end


-------------------------------------------------------------------------------
-- Register the subpackage
-------------------------------------------------------------------------------
function elements.register_to (t)
    t.Element = elements.Element
    t.ELEMENTS = elements.ELEMENTS
end


-------------------------------------------------------------------------------
-- Return the package
-------------------------------------------------------------------------------
return elements
