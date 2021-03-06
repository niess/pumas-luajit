-------------------------------------------------------------------------------
-- PUMAS geometry of infinite extension
-- Author: Valentin Niess
-- License: GNU LGPL-3.0
-------------------------------------------------------------------------------
local ffi = require('ffi')
local clib = require('pumas.clib')
local error = require('pumas.error')
local base = require('pumas.geometry.base')
local uniform = require('pumas.medium.uniform')
local metatype = require('pumas.metatype')

local infinite = {}


-------------------------------------------------------------------------------
-- The infinite geometry metatype
-------------------------------------------------------------------------------
local InfiniteGeometry = {}


local function new (self)
    local c = ffi.cast('struct pumas_geometry_infinite *',
        ffi.C.calloc(1, ffi.sizeof('struct pumas_geometry_infinite')))
    c.base.get = clib.pumas_geometry_infinite_get
    c.base.destroy = ffi.C.free
    if self._medium ~= nil then
        c.medium = ffi.cast('struct pumas_medium *', self._medium._c)
    end
    return ffi.cast('struct pumas_geometry *', c)
end


function InfiniteGeometry:__index (k)
    if k == 'medium' then
        return self._medium
    elseif k == '_new' then
        return new
    else
        return base.BaseGeometry.__index[k]
    end
end


function InfiniteGeometry:__newindex (k, v)
    if k == 'medium' then
        if v == self._medium then return end
        if v.__metatype ~= 'Medium' then
            error.raise{
                fname = k,
                expected = 'a Medium table',
                got = metatype.a(v)
            }
        end
        rawset(self,'_medium', v)
        self._invalidate()
    else
        rawset(self, k, v)
    end
end


-------------------------------------------------------------------------------
-- The infinite geometry constructor
-------------------------------------------------------------------------------
do
    local function new_ (cls, medium)
        local mt = metatype(medium)
        if mt == 'string' then
            medium = uniform.UniformMedium(medium)
        elseif (mt ~= 'nil') and (mt ~= 'Medium') then
            error.raise {
                fname = 'InfiniteGeometry',
                argnum = 1,
                expected = 'a Medium table or a string',
                got = metatype.a(medium)
            }
        end

        local self = base.BaseGeometry:new()
        self._medium = medium

        return setmetatable(self, cls)
    end

    infinite.InfiniteGeometry = setmetatable(InfiniteGeometry,
        {__call = new_})
end


-------------------------------------------------------------------------------
-- Return the package
-------------------------------------------------------------------------------
return infinite
