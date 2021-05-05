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
local material_ = require('pumas.material')
local metatype = require('pumas.metatype')
local composite = require('pumas.physics.composite')
local readonly = require('pumas.readonly')

local tabulated = {}


-------------------------------------------------------------------------------
-- Utility functions providing providing some material properties
-------------------------------------------------------------------------------
local function parse_composition (index, n_elements, c)
    local indices = ffi.new('int [?]', n_elements)
    local fractions = ffi.new('double [?]', n_elements)
    clib.pumas_physics_material_properties(c, index,
        nil, nil, nil, indices, fractions)

    local name_ = ffi.new('const char *[1]')
    local composition = compat.table_new(0, n_elements)
    for i = 1, n_elements do
        clib.pumas_physics_element_name(c, indices[i - 1], name_)
        composition[ffi.string(name_[0])] = tonumber(fractions[i - 1])
    end
    return readonly.Readonly(composition, 'elements')
end


local function parse_composite (physics_, index)
    local n_elements=  ffi.new('int [1]')
    local density = ffi.new('double [1]')
    local I = ffi.new('double [1]')
    clib.pumas_physics_material_properties(physics_._c[0], index,
        n_elements, density, I, nil, nil)

    n_elements = tonumber(n_elements[0])
    local composition = parse_composition(index, n_elements, physics_._c[0])

    local ZoA = material_.compute_ZoA(composition, physics_.elements)

    return tonumber(density[0]), composition, ZoA, tonumber(I[0])
end


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
            elseif (mode == 'virtual') then
                return clib.PUMAS_MODE_VIRTUAL
            else
                error.raise{fname = fname, argnum = 3,
                    description = "invalid mode '"..mode.."'"}
            end
        end
    end

    local function get_or_update_table (self, property, mode, ref)
        local n, is_update, t
        if ref then
            is_update = true
            t = readonly.rawget(ref)
            n = #t
        else
            is_update = false
            n = tonumber(clib.pumas_physics_table_length(self.physics._c[0]))
            t = compat.table_new(n, 0)
        end

        local c_property = clib['PUMAS_PROPERTY_'..property:upper()]
        mode = toindex(mode)
        for i = 0, n - 1 do
            clib.pumas_physics_table_value(self.physics._c[0], c_property, mode,
                self._index, i, value)
            t[i + 1] = tonumber(value[0])
        end

        if is_update then
            return ref
        else
            return readonly.Readonly(t, property, 'PhysicsTable')
        end
    end

    local function get_or_update_all_tables (self, t)
        local is_update
        if t then
            is_update = true
            t = readonly.rawget(t)
        else
            is_update = false
            t = {}
        end

        for _, mode in ipairs{'csda', 'hybrid', 'virtual'} do
            local v
            if is_update then
                v = readonly.rawget(t[mode])
            else
                v = {}
            end
            if mode == 'virtual' then
                local k = 'multiple_scattering_length'
                local ref = is_update and v[k] or nil
                v[k] = get_or_update_table(self, k, mode, ref)
            else
                for _, k in ipairs{'energy_loss', 'grammage', 'proper_time',
                    'multiple_scattering_length'} do
                    local ref = is_update and v[k] or nil
                    v[k] = get_or_update_table(self, k, mode, ref)
                end
            end

            if mode == 'csda' then
                local ref = is_update and v['kinetic_energy'] or nil
                v['kinetic_energy'] = get_or_update_table(
                    self, 'kinetic_energy', mode, ref)
            elseif mode == 'hybrid' then
                for _, prop in ipairs{'cross_section',
                    'elastic_scattering_length', 'elastic_cutoff_angle'} do
                    local ref = is_update and v[prop] or nil
                    v[prop] = get_or_update_table(self, prop, mode, ref)
                end
            end

            if not is_update then
                t[mode] = readonly.Readonly(v, mode)
            end
        end

        if not is_update then
            readonly.rawget(t.hybrid).kinetic_energy = t.csda.kinetic_energy
            for _, prop in ipairs{'elastic_scattering_length',
                'elastic_cutoff_angle'} do
                readonly.rawget(t.csda)[prop] = t.hybrid[prop]
                readonly.rawget(t.virtual)[prop] = t.hybrid[prop]
            end
            t.detailed = t.hybrid
            return readonly.Readonly(t)
        end
    end

    local function update (self, fname)
        if not self then
            fname = fname or 'TabulatedMaterial'
            error.raise{fname = fname, argnum = 1,
                expected = 'a TabulatedMaterial table', got = metatype.a(self)}
        end

        if self._properties.composite and
            self._properties.materials._needs_update then
            local fractions = ffi.new('double [?]',
                self._properties.materials._n)
            for i, k in ipairs(self._properties.materials._names) do
                fractions[i - 1] = self._properties.materials._fractions[k]
            end
            clib.pumas_physics_composite_update(self._physics._c[0],
                self._index, fractions)

            local density, composition, ZoA, I = parse_composite(
                self._physics, self._index)
            self._properties.density = density
            if self._properties.elements then
                local t = readonly.rawget(self._properties.elements)
                for k, v in composition:pairs() do
                    t[k] = v
                end
            else
                self._properties.elements = composition
            end
            self._properties.ZoA = ZoA
            self._properties.I = I

            local tables = rawget(self, 'table')
            if tables then
                get_or_update_all_tables(self, tables)
            end

            self._properties.materials._needs_update = false
        end
    end

    local index = {
        cross_section = function (self, energy)
            update(self, 'cross_section')
            call(clib.pumas_physics_property_cross_section, self._physics._c[0],
                self._index, energy, value)
            return tonumber(value[0])
        end,

        energy_loss = function (self, energy, mode)
            update(self, 'energy_loss')
            call(clib.pumas_physics_property_energy_loss, self.physics._c[0],
                toindex(mode, 'energy_loss'), self._index, energy, value)
            return tonumber(value[0])
        end,

        grammage = function (self, energy, mode)
            update(self, 'grammage')
            call(clib.pumas_physics_property_grammage, self.physics._c[0],
                toindex(mode, 'grammage'), self._index, energy, value)
            return tonumber(value[0])
        end,

        kinetic_energy = function (self, grammage, mode)
            update(self, 'kinetic_energy')
            call(clib.pumas_physics_property_kinetic_energy, self.physics._c[0],
                toindex(mode, 'kinetic_energy'), self._index, grammage, value)
            return tonumber(value[0])
        end,

        magnetic_rotation = function (self, energy)
            update(self, 'magnetic_rotation')
            call(clib.pumas_physics_property_magnetic_rotation,
                self.physics._c[0], self._index, energy, value)
            return tonumber(value[0])
        end,

        proper_time = function (self, energy, mode)
            update(self, 'proper_time')
            call(clib.pumas_physics_property_proper_time, self.physics._c[0],
                toindex(mode, 'proper_time'), self._index, energy, value)
            return tonumber(value[0])
        end,

        elastic_cutoff_angle = function (self, energy)
            update(self, 'elastic_cutoff_angle')
            call(clib.pumas_physics_property_elastic_cutoff_angle,
                self.physics._c[0], self._index, energy, value)
            return tonumber(value[0])
        end,

        elastic_scattering_length = function (self, energy)
            update(self, 'elastic_scattering_length')
            call(clib.pumas_physics_property_elastic_scattering_length,
                self.physics._c[0], self._index, energy, value)
            return tonumber(value[0])
        end,

        multiple_scattering_length = function (self, energy, mode)
            update(self, 'multiple_scattering_length')
            call(clib.pumas_physics_property_multiple_scattering_length,
                self.physics._c[0], toindex(mode, 'multiple_scattering_length'),
                self._index, energy, value)
            return tonumber(value[0])
        end
    }

    function TabulatedMaterial:__index (k)
        if k == '__metatype' then
            return 'TabulatedMaterial'
        elseif k == 'name' then
            return self._name
        elseif k == 'physics' then
            return self._physics
        elseif k == 'table' then
            local t = get_or_update_all_tables(self)
            rawset(self, 'table', t)
            return t
        elseif k == '_update' then
            return update
        else
            if (k ~= 'materials') and (k ~= 'composite') then
                update(self)
            end

            local prop = rawget(self, '_properties')
            prop = prop and prop[k]
            if prop ~= nil then return prop end

            local func = index[k]
            if func then return func end

            if k == 'materials' then return nil end

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
        local properties
        if index < n - m then
            -- This is a base material. Let us fetch its properties
            local n_elements=  ffi.new('int [1]')
            local density = ffi.new('double [1]')
            local I = ffi.new('double [1]')
            clib.pumas_physics_material_properties(physics_._c[0], index,
                n_elements, density, I, nil, nil)

            n_elements = tonumber(n_elements[0])
            local composition = parse_composition(
                index, n_elements, physics_._c[0])
            local ZoA = material_.compute_ZoA(composition, physics_.elements)

            properties = {
                composite = false,
                density = tonumber(density[0]),
                I = tonumber(I[0]),
                elements = composition,
                ZoA = ZoA}
        else
            -- This is a composite material. Let us fetch its properties
            local density, composition, ZoA, I = parse_composite(
                physics_, index)

            properties = {
                composite = true,
                density = density,
                I = I,
                elements = composition,
                ZoA = ZoA,
                materials = composite.CompositeMaterials(physics_, index)
            }
        end

        local self = {_physics = physics_, _index = index, _name = name,
            _properties = properties}
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
