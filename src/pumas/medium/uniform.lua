-------------------------------------------------------------------------------
-- Uniform medium for PUMAS
-- Author: Valentin Niess
-- License: GNU LGPL-3.0
-------------------------------------------------------------------------------
local ffi = require('ffi')
local clib = require('pumas.clib')
local error = require('pumas.error')
local materials = require('pumas.materials')
local base = require('pumas.medium.base')

local uniform = {}


-------------------------------------------------------------------------------
-- The uniform medium metatype
-------------------------------------------------------------------------------
local UniformMedium = {}
local strtype = 'UniformMedium'


function UniformMedium:__index (k)
    if k == 'density' then
        return self._c.locals.density
    elseif k == 'magnet' then
        return self._c.locals.magnet
    else
        return base.BaseMedium.__index(self, k, strtype)
    end
end


function UniformMedium:__newindex (k, v)
    if k == 'density' then
        self._c.locals.density = v
    elseif k == 'magnet' then
        self._c.locals.magnet = v
    else
        base.BaseMedium.__newindex(self, k, v, strtype)
    end
end


-------------------------------------------------------------------------------
-- The uniform medium constructor
-------------------------------------------------------------------------------
local ctype = ffi.typeof('struct pumas_medium_uniform')
local ctype_ptr = ffi.typeof('struct pumas_medium_uniform *')

do
    local raise_error = error.ErrorFunction{fname = 'UniformMedium'}

    local function new (cls, material, density, magnet)
        if material == nil then
            raise_error{
                argnum = 1,
                expected = 'a string',
                got = type(material)
            }
        end

        local self = base.BaseMedium.new(ctype, ctype_ptr, material)

        if density == nil then
            local m = materials.MATERIALS[material]
            if m then
                density = materials.MATERIALS[material].density
            else
                raise_error{
                    argnum = 2,
                    expected = 'a number',
                    got = 'nil'
                }
            end
        end

        clib.pumas_medium_uniform_initialise(self._c, -1, density, magnet)

        return setmetatable(self, cls)
    end

    uniform.UniformMedium  = setmetatable(UniformMedium, {__call = new})
end


-------------------------------------------------------------------------------
-- Return the package
-------------------------------------------------------------------------------
return uniform
