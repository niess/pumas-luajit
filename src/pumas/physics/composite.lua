-------------------------------------------------------------------------------
-- Composite materials' wrapper for PUMAS Physics
-- Author: Valentin Niess
-- License: GNU LGPL-3.0
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
local ffi = require('ffi')
local compat = require('pumas.compat')
local clib = require('pumas.clib')
local error = require('pumas.error')
local metatype = require('pumas.metatype')

local composite = {}


-------------------------------------------------------------------------------
-- The CompositeMaterials metatype
-------------------------------------------------------------------------------
local CompositeMaterials = {}


do
    local function pairs_ (self)
        if not self then
            error.raise{fname = 'CompositeMaterials', argnum = 1,
                expected = 'a CompositeMaterials table', got = metatype.a(self)}
        end

        return pairs(self._fractions)
    end

    function CompositeMaterials:__index (k)
        if k == '__metatype' then
            return 'CompositeMaterials'
        elseif k == 'pairs' then
            return pairs_
        else
            local v = self._fractions[k]
            if not v then
                error.raise{['type'] = 'CompositeMaterials', bad_member = k}
            else
                return v
            end
        end
    end
end


function CompositeMaterials:__newindex (k, v)
    if type(v) ~= 'number' then
        error.raise{fname = 'CompositeMaterials', argname = k,
            expected = 'a number', got = metatype.a(v)}
    end

    local ok = pcall(rawset, self._fractions, k, v)
    if ok then
        rawset(self, '_needs_update', true)
        rawset(self._physics, '_update_composites', true)
    else
        error.raise{['type'] = 'CompositeMaterials', bad_member = k}
    end
end


-------------------------------------------------------------------------------
-- Constructor for a CompositeMaterials table
-------------------------------------------------------------------------------
do
    local function new (cls, physics_, index)
        local n_materials = ffi.new('int [1]')
        clib.pumas_physics_composite_properties(
            physics_._c[0], index, n_materials, nil, nil)

        n_materials = tonumber(n_materials[0])
        local indices = ffi.new('int [?]', n_materials)
        local fractions = ffi.new('double [?]', n_materials)
        clib.pumas_physics_composite_properties(
            physics_._c[0], index, nil, indices, fractions)

        local name_ = ffi.new('const char *[1]')
        local fractions_ = compat.table_new(0, n_materials)
        local names = compat.table_new(n_materials, 0)
        for i = 1, n_materials do
            clib.pumas_physics_material_name(
                physics_._c[0], indices[i - 1], name_)
            local k = ffi.string(name_[0])
            fractions_[k] = tonumber(fractions[i - 1])
            names[i] = k
        end

        local self = {_names = names, _fractions = fractions_,
            _n = n_materials, _physics = physics_, _needs_update = false}
        return setmetatable(self, cls)
    end

    composite.CompositeMaterials = setmetatable(
        CompositeMaterials, {__call = new})

    error.register('CompositeMaterials', CompositeMaterials)
end


-------------------------------------------------------------------------------
-- Return the sub-package
-------------------------------------------------------------------------------
return composite
