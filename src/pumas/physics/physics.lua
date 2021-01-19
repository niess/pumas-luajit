-------------------------------------------------------------------------------
-- PUMAS Physics metatype
-- Author: Valentin Niess
-- License: GNU LGPL-3.0
-------------------------------------------------------------------------------
local lfs = require('lfs')
local ffi = require('ffi')
local call = require('pumas.call')
local clib = require('pumas.clib')
local context = require('pumas.context')
local error = require('pumas.error')
local os = require('pumas.os')
local readonly = require('pumas.readonly')
local tabulated = require('pumas.physics.tabulated')
local utils = require('pumas.physics.utils')

local type_ = {}


-------------------------------------------------------------------------------
-- The Physics metatype
-------------------------------------------------------------------------------
local Physics = {__index = {}}

Physics.__index.__metatype = 'Physics'
Physics.__index.Context = context.Context


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

        -- Update the version
        local self = setmetatable({_c = c}, cls)
        self._version = physics_version
        physics_version = physics_version + 1

        -- Update the particle properties
        -- XXX lazy loading instead
        local particle = ffi.new('enum pumas_particle [1]')
        local lifetime = ffi.new('double [1]')
        local mass = ffi.new('double [1]')
        local rc = clib.pumas_physics_particle(c[0], particle, lifetime,
            mass)
        if rc == 0 then
            self.particle = readonly.Readonly({
                name = utils.particle_string(particle[0]),
                lifetime = tonumber(lifetime[0]),
                mass = tonumber(mass[0])
            }, 'particle')
        end

        -- Build the elements index
        -- XXX lazy loading instead
        local elements = {}
        do
            local name = ffi.new('const char *[1]')
            local properties = ffi.new('double [3]')

            local n = tonumber(clib.pumas_physics_element_length(c[0]))
            for i = 0, n - 1 do
                clib.pumas_physics_element_name(c[0], i, name)
                clib.pumas_physics_element_properties(c[0], i, properties,
                    properties + 1, properties + 2)

                local k = ffi.string(name[0])
                elements[k] = readonly.Readonly(
                    {Z = tonumber(properties[0]), A = tonumber(properties[1]),
                    I = tonumber(properties[2])}, "Element' table '"..k,
                    'Element')
            end
        end
        self.elements = readonly.Readonly(elements, 'elements')

        -- Build the materials index
        -- XXX lazy loading instead
        -- XXX Split material and composites? HERE!!!
        local materials = {}
        do
            local n = tonumber(clib.pumas_physics_material_length(c[0]))
            for i = 0, n - 1 do
                local m = tabulated.TabulatedMaterial(self, i)
                materials[m.name] = m
            end
        end
        self.materials = readonly.Readonly(materials, 'materials')
        self._update_composites = false

        -- Wrap the DCS
        self.dcs = readonly.Readonly({
            bremsstrahlung = clib.pumas_physics_dcs_get(
                c[0], clib.PUMAS_PROCESS_BREMSSTRAHLUNG),
            pair_production = clib.pumas_physics_dcs_get(
                c[0], clib.PUMAS_PROCESS_PAIR_PRODUCTION),
            photonuclear = clib.pumas_physics_dcs_get(
                c[0], clib.PUMAS_PROCESS_PHOTONUCLEAR)
        }, 'dcs')

        return self
    end

    type_.Physics = setmetatable(Physics, {__call = new})
end


-------------------------------------------------------------------------------
-- Dump the material tables to a binary file
-------------------------------------------------------------------------------
do
    local raise_error = error.ErrorFunction{
        argnum = 2,
        fname = 'dump'
    }

    function Physics.__index:dump (path)
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
-- Inner routine for updating the physics when composites change
-------------------------------------------------------------------------------
function Physics.__index:_update ()
    if self._update_composites then
        for _, v in pairs(self.materials) do
            v:_update()
        end
        self._update_composites = false
    end
end



-------------------------------------------------------------------------------
-- Return the sub-package
-------------------------------------------------------------------------------
return type_
