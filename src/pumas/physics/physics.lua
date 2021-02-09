-------------------------------------------------------------------------------
-- PUMAS Physics metatype
-- Author: Valentin Niess
-- License: GNU LGPL-3.0
-------------------------------------------------------------------------------
local lfs = require('lfs')
local ffi = require('ffi')
local call = require('pumas.call')
local clib = require('pumas.clib')
local compat = require('pumas.compat')
local context = require('pumas.context')
local error = require('pumas.error')
local os = require('pumas.os')
local readonly = require('pumas.readonly')
local tabulated = require('pumas.physics.tabulated')
local utils = require('pumas.physics.utils')

local type_ = {}


-------------------------------------------------------------------------------
-- Lazy loaders for the Physics
-------------------------------------------------------------------------------
local function load_composites (self)
    local n = tonumber(clib.pumas_physics_material_length(self._c[0]))
    local m = tonumber(clib.pumas_physics_composite_length(self._c[0]))

    local composites = compat.table_new(0, m)
    for i = n - m, n - 1 do
        local comp = tabulated.TabulatedMaterial(self, i)
        composites[comp.name] = comp
    end
    composites = readonly.Readonly(composites, 'composites')
    rawset(self, 'composites', composites)

    return composites
end

-- XXX Allow to modify cross-sections?
local function load_dcs (self)
    local dcs = readonly.Readonly({
        bremsstrahlung = clib.pumas_physics_dcs_get(
            self._c[0], clib.PUMAS_PROCESS_BREMSSTRAHLUNG),
        pair_production = clib.pumas_physics_dcs_get(
            self._c[0], clib.PUMAS_PROCESS_PAIR_PRODUCTION),
        photonuclear = clib.pumas_physics_dcs_get(
            self._c[0], clib.PUMAS_PROCESS_PHOTONUCLEAR)
    }, 'dcs')
    rawset(self, 'dcs', dcs)

    return dcs
end


local function load_elements (self)
    local n = tonumber(clib.pumas_physics_element_length(self._c[0]))
    local elements = compat.table_new(0, n)

    local name = ffi.new('const char *[1]')
    local properties = ffi.new('double [3]')
    for i = 0, n - 1 do
        clib.pumas_physics_element_name(self._c[0], i, name)
        clib.pumas_physics_element_properties(self._c[0], i, properties,
            properties + 1, properties + 2)

        local k = ffi.string(name[0])
        elements[k] = readonly.Readonly(
            {Z = tonumber(properties[0]), A = tonumber(properties[1]),
            I = tonumber(properties[2])}, "Element' table '"..k,
            'Element')
    end
    elements = readonly.Readonly(elements, 'elements')
    rawset(self, 'elements', elements)

    return elements
end


local function load_materials (self)
    local n = tonumber(clib.pumas_physics_material_length(self._c[0]))
    local m = tonumber(clib.pumas_physics_composite_length(self._c[0]))
    n = n - m

    local materials = compat.table_new(0, n)
    for i = 0, n - 1 do
        local mat = tabulated.TabulatedMaterial(self, i)
        materials[mat.name] = mat
    end
    materials = readonly.Readonly(materials, 'materials')
    rawset(self, 'materials', materials)

    return materials
end


local function load_particle (self)
    local particle = ffi.new('enum pumas_particle [1]')
    local lifetime = ffi.new('double [1]')
    local mass = ffi.new('double [1]')
    local rc = clib.pumas_physics_particle(self._c[0], particle, lifetime,
        mass)
    if rc == 0 then
        particle = readonly.Readonly({
            name = utils.particle_string(particle[0]),
            lifetime = tonumber(lifetime[0]),
            mass = tonumber(mass[0])
        }, 'particle')
    else
        error.raise{['type'] = 'Physics', bad_member = 'particle'}
    end
    rawset(self, 'particle', particle)

    return particle
end


-------------------------------------------------------------------------------
-- Inner routine for updating composite data if the composition has changed
-------------------------------------------------------------------------------
local function update_composites (self)
    if self._update_composites then
        for _, v in pairs(self.composites) do
            v:_update()
        end
        self._update_composites = false
    end
end


-------------------------------------------------------------------------------
-- Dump the material tables to a binary file
-------------------------------------------------------------------------------
local dump_physics
do
    local raise_error = error.ErrorFunction{
        argnum = 2,
        fname = 'dump'
    }

    function dump_physics (self, path)
        if path == nil then
            local nargs = (self ~= nil) and 1 or 0
            error.raise{
                argnum = 'bad',
                expected = 2,
                got = nargs
            }
        end

        local f = io.open(path, 'wb')
        if f == nil then
            raise_error('could not open file '..path)
        end

        local errmsg = call.protected(clib.pumas_physics_dump, self._c[0], f)
        f:close()
        if errmsg then
            raise_error{
                header = 'error when dumping materials',
                errmsg
            }
        end
    end
end


-------------------------------------------------------------------------------
-- The Physics metatype
-------------------------------------------------------------------------------
local Physics = {}


do
    function Physics:__index (k)
        if k == '__metatype' then
            return 'Physics'
        elseif k == 'Context' then
            return context.Context
        elseif k == 'dump' then
            return dump_physics
        elseif k == '_update' then
            return update_composites
        elseif k == 'composites' then
            return load_composites(self)
        elseif k == 'dcs' then
            return load_dcs(self)
        elseif k == 'elements' then
            return load_elements(self)
        elseif k == 'materials' then
            return load_materials(self)
        elseif k == 'particle' then
            return load_particle(self)
        else
            error.raise{['type'] = 'Physics', bad_member = k}
        end
    end
end


function Physics.__newindex (_, k)
    local fields = {'__metatype', 'Context', 'composites', 'elements',
        'maetrials', 'particle'}
    for _, v in ipairs(fields) do
        if k == v then
            error.raise{['type'] = 'Physics', not_mutable = k}
        end
    end
    error.raise{['type'] = 'Physics', bad_member = k}
end


-------------------------------------------------------------------------------
-- The Physics constructor
-------------------------------------------------------------------------------
do
    local physics_version = 0
    local raise_error = error.ErrorFunction{fname = 'Physics'}

    local function new (cls, args)
        local c = ffi.new('struct pumas_physics *[1]')
        ffi.gc(c, clib.pumas_physics_destroy)

        if args == nil then
            error.raise{
                argnum = 'bad',
                expected = 1,
                got = 0
            }
        end

        local tp = type(args)
        if (tp ~= 'string') and (tp ~= 'table') then
            raise_error{
                argnum = 1,
                expected = 'a string or a table',
                got = 'a '..type(args)
            }
        end

        -- Load the physics tables
        if tp == 'table' then
            local particle = utils.particle_ctype(args.particle, raise_error)
            call(clib.pumas_physics_create, c, particle, args.mdf, args.dedx)
        else
            local path = args
            local mode, errmsg = lfs.attributes(path, 'mode')
            if mode == nil then
                raise_error(errmsg)
            elseif mode == 'directory' then
                path = path..os.PATHSEP..'materials.pumas'
            end

            local f = io.open(path, 'rb')
            if f == nil then
                raise_error('could not open file '..path)
            end

            errmsg = call.protected(clib.pumas_physics_load, c, f)
            f:close()
            if errmsg then
                raise_error{
                    header = 'error when loading materials',
                    errmsg
                }
            end
        end

        local self = setmetatable({_c = c, _version = physics_version,
            _update_composites = false}, cls)
        physics_version = physics_version + 1

        return self
    end

    type_.Physics = setmetatable(Physics, {__call = new})
end


-------------------------------------------------------------------------------
-- Return the sub-package
-------------------------------------------------------------------------------
return type_
