-------------------------------------------------------------------------------
-- Manage PUMAS Physics
-- Author: Valentin Niess
-- License: GNU LGPL-3.0
-------------------------------------------------------------------------------
local lfs = require('lfs')
local ffi = require('ffi')
local call = require('pumas.call')
local context = require('pumas.context')
local elements = require('pumas.elements')
local error = require('pumas.error')
local materials_ = require('pumas.materials')
local metatype = require('pumas.metatype')
local os = require('pumas.os')

local physics = {}


-------------------------------------------------------------------------------
-- Forward some Physics constants
-------------------------------------------------------------------------------
-- XXX get this from C/PUMAS directly
physics.MUON_C_TAU = 658.654
physics.TAU_C_TAU = 87.03E-06
physics.ELECTRON_MASS = 0.510998910E-03
physics.MUON_MASS = 0.10565839
physics.TAU_MASS = 1.77682


-------------------------------------------------------------------------------
-- Conversion between particles C type and strings
-------------------------------------------------------------------------------
local function particle_ctype (name, raise_error)
    if name == nil then
        return ffi.C.PUMAS_PARTICLE_MUON
    else
        if type(name) ~= 'string' then
            raise_error{
                argname = 'particle',
                expected = 'a string',
                got = 'a '..type(name)
            }
        end

        local tmp = name:lower()
        if tmp == 'muon' then
            return ffi.C.PUMAS_PARTICLE_MUON
        elseif tmp == "tau" then
            return ffi.C.PUMAS_PARTICLE_TAU
        else
            raise_error{
                argname = 'particle',
                expected = "'muon' or 'tau'",
                got = "'"..name.."'"
            }
        end
    end
end


local function particle_string (ctype)
    if ctype == ffi.C.PUMAS_PARTICLE_MUON then
        return 'muon'
    elseif ctype == ffi.C.PUMAS_PARTICLE_TAU then
        return 'tau'
    end
end


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
        ffi.gc(c, ffi.C.pumas_physics_destroy)

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
            local particle = particle_ctype(args.particle, raise_error)
            ffi.C.pumas_physics_create(c, particle, args.mdf, args.dedx)
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

            errmsg = call.protected(ffi.C.pumas_physics_load, c, f)
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
        local particle = ffi.new('enum pumas_particle [1]')
        local lifetime = ffi.new('double [1]')
        local mass = ffi.new('double [1]')
        local rc = ffi.C.pumas_physics_particle(c[0], particle, lifetime,
            mass)
        if rc == 0 then
            self.particle = {
                name = particle_string(particle[0]),
                lifetime = tonumber(lifetime[0]),
                mass = tonumber(mass[0])
            }
        end

        return self
    end

    physics.Physics = setmetatable(Physics, {__call = new})
end


-------------------------------------------------------------------------------
-- Dump the current material tables to a binary file
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

        local errmsg = call.protected(ffi.C.pumas_physics_dump, self._c[0], f)
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
-- Convert a Camel like name to a snaky one
-------------------------------------------------------------------------------
local snakify
do
    local function f (w) return '_'..w:lower() end

    function snakify (camel)
        camel = camel:sub(1,1):lower()..camel:sub(2)
        return camel:gsub('%u', f)
                    :gsub('%d+', f)
    end
end


-------------------------------------------------------------------------------
-- Text buffer used for building up multi-lines text contents
-------------------------------------------------------------------------------
local Text
do
    local Text_ = {__index={}}

    -- Add a line of text
    function Text_.__index:push (s,...)
        table.insert(self, string.format(s,...))
        return self
    end

    -- Pop the full text with OS specific line seps
    function Text_.__index:pop ()
        return table.concat(self, os.LINESEP)
    end

    function Text () return setmetatable({}, Text_) end
end


-------------------------------------------------------------------------------
-- Recursively create a new directory if it does not already exist
-------------------------------------------------------------------------------
local function makedirs (path)
    local dir = ''
    for s in path:gmatch(os.PATHSEP..'?[^'..os.PATHSEP..']+') do
        dir = dir..s
        if lfs.attributes(dir, "mode") == nil then
            local ok, err = lfs.mkdir(dir)
            if not ok then return nil, err end
        end
    end
    return true
end


-------------------------------------------------------------------------------
-- Tabulate a set of materials
-------------------------------------------------------------------------------
function physics.build (args)
    local raise_error = error.ErrorFunction{fname = 'build'}

    if type(args) ~= 'table' then
        raise_error{
            argnum = 1,
            expected = 'a table',
            got = 'a '..type(args),
        }
    end

    local materials, composites, project, path, particle, energies, compile
    for k, v in pairs(args) do
        if     k == 'materials' then materials = v
        elseif k == 'composites' then composites = v
        elseif k == 'project' then project = v
        elseif k == 'path' then path = v
        elseif k == 'particle' then particle = v
        elseif k == 'energies' then energies = v
        elseif k == 'compile' then compile = v
        else
            raise_error{
                argname = k,
                description = 'unknown argument'
            }
        end
    end

    if project == nil then
        project = 'materials'
    elseif type(project) ~= 'string' then
        raise_error{
            argname = 'project',
            expected = 'a string',
            got = 'a '..type(project)
        }
    end

    if compile == nil then
        compile = true
    elseif type(compile) ~= 'boolean' then
        raise_error{
            argname = 'compile',
            expected = 'a boolean',
            got = 'a '..type(compile)
        }
    end

    particle = particle_ctype(particle, raise_error)

    if energies == nil then
        if particle == ffi.C.PUMAS_PARTICLE_MUON
        then energies = 'pdg'
        else energies = {min = 1E+02, max = 1E+12, n = 201}
        end
    end

    if type(energies) == 'string' then
        local tmp = energies:lower()
        if tmp ~= 'pdg' then
            raise_error{
                argname = 'energies',
                expected = "a table or 'PDG'",
                got = "'"..energies.."'"
            }
        end

        energies = ffi.new("double [?]", 145,
            1.000E-03, 1.200E-03, 1.400E-03, 1.700E-03, 2.000E-03,
            2.500E-03, 3.000E-03, 3.500E-03, 4.000E-03, 4.500E-03,
            5.000E-03, 5.500E-03, 6.000E-03, 7.000E-03, 8.000E-03,
            9.000E-03)

        local n_decade = 16
        for i = 1, 8 do
            for j = 0, n_decade - 1 do
                energies[i * n_decade + j] =
                    10 * energies[(i - 1) * n_decade + j]
            end
        end
        energies[9 * n_decade] = 10 * energies[8 * n_decade]
    elseif type(energies) == 'table' then
        if #energies > 0 then
            local tmp = ffi.new('double [?]', #energies)
            for i, v in ipairs(energies) do tmp[i - 1] = v end
            energies = tmp
        else
            local min, max, n = energies.min, energies.max, energies.n
            if min == nil then
                raise_error{
                    argname = 'energies',
                    description = 'missing min kinetic energy'
                }
            end
            if max == nil then
                raise_error{
                    argname = 'energies',
                    description = 'missing max kinetic energy'
                }
            end
            if n == nil then
                raise_error{
                    argname = 'energies',
                    description = "missing number of kinetic energies, 'n'"
                }
            end
            if n <= 1 then
                raise_error{
                    argname = 'energies',
                    expected = 'n > 1',
                    got = 'n = '..n
                }
            end

            energies = ffi.new("double [?]", n)
            local dlnk = math.log(max / min) / (n - 1)
            for i = 0, n - 1 do energies[i] = min * math.exp(dlnk * i) end
        end
    else
        raise_error{
            argname = 'energies',
            expected = 'a string or table',
            got = metatype.a(energies)
        }
    end

    if path == nil then
        path = '.'
    elseif type(path) ~= 'string' then
        raise_error{
            argname = 'path',
            expected = 'a string',
            got = metatype.a(path)
        }
    end

    if path ~= "." then
        local ok, errmsg = makedirs(path)
        if not ok then error(errmsg, 2) end
    end

    if materials == nil then
        raise_error{
            argname = 'materials',
            expected = 'a string or a table',
            got = 'nil'
        }
    else
        local tp = type(materials)
        if tp == 'string' then
            materials = {materials}
        elseif tp ~= 'table' then
            raise_error{
                argname = 'materials',
                expected = 'a string or a table',
                got = 'a '..tp
            }
        end
    end

    if #materials > 0 then
        for _, name in ipairs(materials) do
            if materials[name] ~= nil then
                raise_error{
                    argname = 'materials',
                    description = "duplicated material name '"..
                                  name.."'"
                }
            end

            local material = materials_.MATERIALS[name]
            if not material then
                raise_error{
                    argname = 'materials',
                    description = "unknown material '"..name.."'"
                }
            end
            materials[name] = material
        end

        local n = #materials
        for _ = 1, n do table.remove(materials) end
    end

    if composites ~= nil then
        if type(composites) ~= 'table' then
            raise_error{
                argname = 'composites',
                expected = ' a table',
                got = 'a '..type(composites)
            }
        end
        for name, composition in pairs(composites) do
            for _, v in ipairs(composition) do
                local m = materials[v[1]]
                if not m then
                    raise_error{
                        argname = 'composites',
                        description = "missing material '"..v[1]..
                                      "' for composite '"..name "'"
                    }
                end
            end
        end
    end

    -- Build the list of elements
    local composition = {}
    for _, material in pairs(materials) do
        if material.__metatype ~= 'Material' then
            raise_error{
                argname = 'materials',
                expected =  'a Material table',
                got =  metatype.a(material)
            }
        end
        for _, v in pairs(material.composition) do
            local name = v[1]
            if not composition[name] then
                local element = elements.ELEMENTS[name]
                if not element then
                    raise_error{
                        argname = 'materials',
                        description = "unknown element '"..name.."'"
                    }
                end
                composition[name] = element
            end
        end
    end

    -- Build the MDF
    local mlist = {}
    for name, _ in pairs(materials) do table.insert(mlist, name) end
    table.sort(mlist)

    local xml = Text()
    xml:push('<pumas>')
    local elist, padmax = {}, 0
    for name, element in pairs(composition) do
        local n = #name
        if n > padmax then padmax = n end
        table.insert(elist, {name, element})
    end
    table.sort(elist, function(a, b)
        a, b = a[2], b[2]
        if a.Z == b.Z then
            return a.A < b.A
        else
            return a.Z < b.Z
        end
    end)

    for _, v in ipairs(elist) do
        local symbol, e = unpack(v)
        local align1 = string.rep(' ', padmax - #symbol)
        local align2 = e.Z >= 10 and '' or ' '
        local align3 = e.I >= 100 and '' or ' '
        xml:push(
            '  <element name="%s"%s Z="%d"%s A="%.6f" I="%.1f"%s />',
            symbol, align1, e.Z, align2, e.A, e.I, align3)
    end

    for _, name in ipairs(mlist) do
        xml:push('')
        local dedx = snakify(name)..'.txt'
        xml:push('  <material name="%s" file="%s">', name, dedx)
        local m = materials[name]

        local padmax2 = 0
        for _, v in ipairs(m.composition) do
            local n = #v[1]
            if n > padmax2 then padmax2 = n end
        end

        for _, value in ipairs(m.composition) do
            local symbol, wi = unpack(value)
            local pad = string.rep(" ", padmax2 - #symbol)
            xml:push(
                '    <component name="%s"%s fraction="%6f" />',
                symbol, pad, wi)
        end
        xml:push('  </material>')
    end

    if composites then
        for name, compo in pairs(composites) do
            local padmax2 = 0
            for _, v in ipairs(compo) do
                local n = #v[1]
                if n > padmax2 then padmax2 = n end
            end

            xml:push('')
            xml:push('  <composite name="%s">', name)
            for _, v in ipairs(compo) do
                local m = materials[v[1]]
                local pad = string.rep(" ", padmax2 - #v[1])
                xml:push('    <component name="%s"%s fraction="%f" \z
                    density="%f" />', v[1], pad, v[2], m.density * 1E-03)
            end
            xml:push('  </composite>')
        end
    end
    xml:push('</pumas>')

    local mdf = path..os.PATHSEP..project..'.xml'
    local f = io.open(mdf, 'w')
    f:write(xml:pop())
    f:close()

    -- Generate the energy loss tables
    local physics_ = ffi.new('struct pumas_physics *[1]')
    ffi.gc(physics_, ffi.C.pumas_physics_destroy)
    ffi.C.pumas_physics_create_tabulation(physics_, particle, mdf)

    local data = ffi.new('struct pumas_physics_tabulation_data')
    local outdir
    if path ~= nil then outdir = ffi.new('char [?]', #path + 1, path) end
    data.outdir = outdir
    data.overwrite = 1
    data.n_kinetics = ffi.sizeof(energies) / ffi.sizeof('double')
    data.kinetic = energies

    local ok, errormsg
    for name, material in pairs(materials) do
        local m = data.material
        local index = ffi.new('int [1]')
        ffi.C.pumas_physics_material_index(physics_[0], name, index)
        m.index = index[0]
        m.density = material.density
        m.I = material.I * 1E-09
        if material.state == nil then
            m.state = ffi.C.PUMAS_PHYSICS_STATE_UNKNOWN
        else
            m.state = ({
                solid  = ffi.C.PUMAS_PHYSICS_STATE_SOLID,
                liquid = ffi.C.PUMAS_PHYSICS_STATE_LIQUID,
                gaz    = ffi.C.PUMAS_PHYSICS_STATE_GAZ
            })[material.state:lower()]
        end
        m.a = material.a
        m.k = material.k
        m.x0 = material.x0
        m.x1 = material.x1
        m.Cbar = material.Cbar
        m.delta0 = material.delta0

        ok, errormsg = pcall(ffi.C.pumas_physics_tabulate, physics_[0], data)
        if not ok then break end
    end
    ffi.C.pumas_physics_tabulation_clear(physics_[0], data)
    if not ok then
        ffi.C.pumas_physics_destroy(physics_)
        raise_error{
            description = errormsg
        }
    end

    if compile then
        -- Generate a binary dump
        local dump
        ffi.C.pumas_physics_destroy(physics_)
        ffi.C.pumas_physics_create(physics_, particle, mdf, path)
        dump = path..os.PATHSEP..project..'.pumas'
        local file = io.open(dump, 'w+')
        ffi.C.pumas_physics_dump(physics_[0], file)
        file:close()
    end

    ffi.C.pumas_physics_destroy(physics_)
end


-------------------------------------------------------------------------------
-- Register the subpackage
-------------------------------------------------------------------------------
-- XXX add an interface to tables, properties and DCSs

function physics.register_to (t)
    t.build = physics.build
    t.Physics = physics.Physics

    -- Register back to context as well. This is to avoid a cross-reference
    -- loop.
    context._physics = physics
end


-------------------------------------------------------------------------------
-- Return the package
-------------------------------------------------------------------------------
return physics
