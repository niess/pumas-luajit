-------------------------------------------------------------------------------
-- Tabulation wrapper for PUMAS Physics
-- Author: Valentin Niess
-- License: GNU LGPL-3.0
-------------------------------------------------------------------------------
local ffi = require('ffi')
local call = require('pumas.call')
local compat = require('pumas.compat')
local clib = require('pumas.clib')
local error = require('pumas.error')
local materials_ = require('pumas.materials')
local metatype = require('pumas.metatype')
local readonly = require('pumas.readonly')

local tabulated = {}


-------------------------------------------------------------------------------
-- The TabulateMaterial metatype
-------------------------------------------------------------------------------
local TabulatedMaterial = {}

do
    local value = ffi.new('double [1]')

    local toindex
    do
        function toindex (mode, fname)
            if (mode == nil) or (mode == 'csda') then
                return clib.PUMAS_MODE_CSDA
            elseif (mode == 'hybrid') or (mode == 'detailed') then
                return clib.PUMAS_MODE_HYBRID
            else
                error.raise{fname = fname, argnum = 3,
                    description = "invalid mode '"..mode.."'"}
            end
        end
    end

    local index = {
        cross_section = function (self, kinetic)
            call(clib.pumas_physics_property_cross_section, self._physics._c[0],
                self._index, kinetic, value)
            return tonumber(value[0])
        end,

        energy_loss = function (self, kinetic, mode)
            call(clib.pumas_physics_property_energy_loss, self.physics._c[0],
                toindex(mode, 'energy_loss'), self._index, kinetic, value)
            return tonumber(value[0])
        end,

        grammage = function (self, kinetic, mode)
            call(clib.pumas_physics_property_grammage, self.physics._c[0],
                toindex(mode, 'grammage'), self._index, kinetic, value)
            return tonumber(value[0])
        end,

        kinetic_energy = function (self, grammage, mode)
            call(clib.pumas_physics_property_kinetic_energy, self.physics._c[0],
                toindex(mode, 'kinetic_energy'), self._index, grammage, value)
            return tonumber(value[0])
        end,

        magnetic_rotation = function (self, kinetic)
            call(clib.pumas_physics_property_magnetic_rotation,
                self.physics._c[0], self._index, kinetic, value)
            return tonumber(value[0])
        end,

        proper_time = function (self, kinetic, mode)
            call(clib.pumas_physics_property_proper_time, self.physics._c[0],
                toindex(mode, 'proper_time'), self._index, kinetic, value)
            return tonumber(value[0])
        end,

        scattering_length = function (self, kinetic)
            call(clib.pumas_physics_property_scattering_length,
                self.physics._c[0], self._index, kinetic, value)
            return tonumber(value[0])
        end
    }

    local function get_table (self, property, mode)
        local n = tonumber(clib.pumas_physics_table_length(self.physics._c[0]))
        local t = compat.table_new(n, 0)
        property = clib['PUMAS_PROPERTY_'..property:upper()]
        mode = toindex(mode)
        for i = 0, n - 1 do
            clib.pumas_physics_table_value(self.physics._c[0], property, mode,
                self._index, i, value)
            t[i + 1] = tonumber(value[0])
        end

        return t
    end

    local function get_all_tables (self)
        local t = {}

        for _, k in pairs{'cross_section', 'kinetic_energy',
            'magnetic_rotation'} do
            t[k] = get_table(self, k)
        end

        for _, mode in pairs{'csda', 'hybrid'} do
            local v = {}
            for _, k in pairs{'energy_loss', 'grammage', 'proper_time'} do
                v[k] = get_table(self, k, mode)
            end
            t[mode] = v
        end
        t.detailed = t.hybrid

        return t
    end

    function TabulatedMaterial:__index (k)
        if k == 'name' then
            return self._name
        elseif k == 'physics' then
            return self._physics
        elseif k == 'table' then
            local t = get_all_tables(self)
            rawset(self, 'table', t)
            return t
        else
            local prop = rawget(self, '_properties')
            prop = prop and prop [k]
            if prop then return prop end

            local func = index[k]
            if func then return func end

            error.raise{['type'] = 'TabulatedMaterial', bad_member = k}
        end
    end
end


function TabulatedMaterial.__newindex (_, k, _)
    error.raise{['type'] = 'TabulatedMaterial', not_mutable = k}
end


function TabulatedMaterial:__tostring ()
    return self._name
end


-------------------------------------------------------------------------------
-- The TabulateMaterial constructor
-------------------------------------------------------------------------------
do
    local raise_error = error.ErrorFunction{fname = 'TabulatedMaterial'}

    local function new (cls, physics_, arg)
        if metatype(physics_) ~= 'Physics' then
            raise_error{argnum = 1, expected = 'a Physics table',
                got = metatype.a(physics_)}
        end

        local n = clib.pumas_physics_material_length(physics_._c[0])
        local name, index
        local tp = type(arg)
        if tp == 'number' then
            if (arg < 0) or (arg >= n) then
                raise_error{argnum = 1, expected = 'a value between '..
                    '0 and '..(n - 1), got = arg}
            end

            local c_name = ffi.new('const char *[1]')
            call(clib.pumas_physics_material_name, physics_._c[0], arg,
                c_name)
            index = arg
            name = ffi.string(c_name[0])
        elseif tp == 'string' then
            local c_index = ffi.new('int [1]')
            call(clib.pumas_physics_material_index, physics_._c[0], arg,
                c_index)
            index = tonumber(c_index[0])
            name = arg
        else
            raise_error{argnum = 1, expected = 'a number or a string',
                got = metatype.a(arg)}
        end

        local m = clib.pumas_physics_composite_length(physics_._c[0])
        local properties, composite
        if index < n - m then
            -- This is a base material. Let us fetch its properties
            composite = false

            local n_elements=  ffi.new('int [1]')
            local density = ffi.new('double [1]')
            local I = ffi.new('double [1]')
            local density_effect =
                ffi.new('struct pumas_physics_density_effect[1]')
            clib.pumas_physics_material_properties(physics_._c[0], index,
                n_elements, density, I, density_effect, nil, nil)

            n_elements = tonumber(n_elements[0])
            local indices = ffi.new('int [?]', n_elements)
            local fractions = ffi.new('double [?]', n_elements)
            clib.pumas_physics_material_properties(physics_._c[0], index,
                nil, nil, nil, nil, indices, fractions)

            local name_ = ffi.new('const char *[1]')
            local composition = compat.table_new(n_elements, 0)
            for i = 1, n_elements do
                clib.pumas_physics_element_name(physics_._c[0],
                    indices[i - 1], name_)
                composition[i] = readonly.Readonly{
                    ffi.string(name_[0]), fractions[i - 1]}
            end
            composition = readonly.Readonly(composition, 'composition')

            properties = materials_.Material{
                density = density[0], I = I[0],
                a = density_effect[0].a, k = density_effect[0].k,
                x0 = density_effect[0].x0, x1 = density_effect[0].x1,
                Cbar = density_effect[0].Cbar,
                delta0 = density_effect[0].delta0,
                composition = composition, elements = physics_.elements}
        else
            -- This is a composite material. Let us fetch its properties
            -- XXX parse the components and build the wrappers
            composite = true
        end

        local self = {_physics = physics_, _index = index, _name = name,
            _properties = properties, _composite = composite}
        return setmetatable(self, cls)
    end

    tabulated.TabulatedMaterial = setmetatable(
        TabulatedMaterial, {__call = new})

    error.register('physics.TabulatedMaterial', TabulatedMaterial)
end


-------------------------------------------------------------------------------
-- Return the sub-package
-------------------------------------------------------------------------------
return tabulated
