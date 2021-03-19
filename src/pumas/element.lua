-------------------------------------------------------------------------------
-- Atomic elements for PUMAS
-- Author: Valentin Niess
-- License: GNU LGPL-3.0
-------------------------------------------------------------------------------
local compat = require('pumas.compat')
local error = require('pumas.error')
local metatype = require('pumas.metatype')

local element = {}


-------------------------------------------------------------------------------
-- The atomic Element metatype
-------------------------------------------------------------------------------
local Element = {__index = {}}

Element.__index.__metatype = 'Element'

do
    local raise_error = error.ErrorFunction{fname = 'Element'}

    local function new (cls, ...)
        local Z, A, I, argname, argnum, var
        local nargs = select('#', ...)
        if nargs == 1 then
            local args = select(1, ...)
            if type(args) ~= 'table' then
                raise_error{argnum = 1, expected = 'a table',
                    got = metatype.a(args)}
            end

            Z = args.Z
            A = args.A
            I = args.I

            if     type(Z) ~= 'number' then argname, var = 'Z', Z
            elseif type(A) ~= 'number' then argname, var = 'A', A
            elseif type(I) ~= 'number' then argname, var = 'I', I
            end
        elseif nargs == 3 then
            Z = select(1, ...)
            A = select(2, ...)
            I = select(3, ...)

            if     type(Z) ~= 'number' then argnum, var = 1, Z
            elseif type(A) ~= 'number' then argnum, var = 2, A
            elseif type(I) ~= 'number' then argnum, var = 3, A
            end
        else
            raise_error{argnum = 'bad', expected = '1 or 3', got = nargs}
        end

        if argname or argnum then
            raise_error{
                argname = argname, argnum = argnum, expected = 'a number',
                got = metatype.a(var)}
        end

        local self = compat.table_new(0, 3)
        self.Z = Z
        self.A = A
        self.I = I

        return setmetatable(self, cls)
    end

    element.Element = setmetatable(Element, {__call = new})
end


-------------------------------------------------------------------------------
-- Build the Elements table
-------------------------------------------------------------------------------
element.elements = require('pumas.data.elements')

for k, v in pairs(element.elements) do
    element.elements[k] = setmetatable(v, Element)
end


-------------------------------------------------------------------------------
-- Register the subpackage
-------------------------------------------------------------------------------
function element.register_to (t)
    t.Element = element.Element
    t.elements = element.elements
end


-------------------------------------------------------------------------------
-- Return the package
-------------------------------------------------------------------------------
return element
