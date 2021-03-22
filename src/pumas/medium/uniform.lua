-------------------------------------------------------------------------------
-- Uniform medium for PUMAS
-- Author: Valentin Niess
-- License: GNU LGPL-3.0
-------------------------------------------------------------------------------
local ffi = require('ffi')
local clib = require('pumas.clib')
local coordinates = require('pumas.coordinates')
local error = require('pumas.error')
local material_ = require('pumas.material')
local base = require('pumas.medium.base')
local metatype = require('pumas.metatype')

local uniform = {}


-------------------------------------------------------------------------------
-- The uniform medium metatype
-------------------------------------------------------------------------------
local UniformMedium = {}
local strtype = 'UniformMedium'


function UniformMedium:__index (k)
    if k == 'density' then
        return tonumber(self._c.locals.density)
    elseif k == 'magnet' then
        return self._c.locals.magnet
    else
        return base.BaseMedium.__index(self, k, strtype)
    end
end


function UniformMedium:__newindex (k, v)
    if k == 'density' then
        local ok, description = pcall(function ()
            self._c.locals.density = v
        end)
        if not ok then
            error.raise{fname = 'UniformMedium', argname = 'magnet',
                description = description:match(':%d+:(.+)$')}
        end
    elseif k == 'magnet' then
        local ok, description = coordinates.set_double3(
            self._c.locals, 'magnet', v)
        if not ok then
            error.raise{fname = 'UniformMedium', argname = 'magnet',
                description = description}
        end
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

    local function new (cls, material, density, magnet, name)
        if type(material) ~= 'string' then
            raise_error{
                argnum = 1, expected = 'a string', got = metatype.a(material)}
        end

        local self = base.BaseMedium.new(ctype, ctype_ptr, material)

        if density then
            if type(density) ~= 'number' then
                raise_error{argnum = 2, expected = 'a number',
                    got = metatype.a(density)}
            end
        else
            local m = material_.materials[material]
            if m then
                density = m.density
            else
                raise_error{argnum = 2, expected = 'a number', got = 'nil'}
            end
        end

        if magnet then
            local ok, tmp = coordinates.to_double3(magnet)
            if ok then
                magnet = tmp
            else
                raise_error{argnum = 3, description = tmp}
            end
        end

        if name ~= nil then
            if type(name) == 'string' then
                self._name = name
            else
                raise_error{argnum = 4, expected = 'a string',
                    got = metatype.a(name)}
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
