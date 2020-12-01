-------------------------------------------------------------------------------
-- Manage PUMAS Physics
-- Author: Valentin Niess
-- License: GNU LGPL-3.0
-------------------------------------------------------------------------------
local lfs = require('lfs')
local ffi = require('ffi')
local call = require('pumas.call')
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
-- Main table for global / shared data
-------------------------------------------------------------------------------
local PUMAS = {}


-------------------------------------------------------------------------------
-- Update the PUMAS table constants, e.g. on a library initialisation
-------------------------------------------------------------------------------
function update ()
    local particle = ffi.new('enum pumas_particle [1]')
    local lifetime = ffi.new('double [1]')
    local mass = ffi.new('double [1]')
    if ffi.C.pumas_particle(particle, lifetime, mass) == 0 then
        if particle[0] == ffi.C.PUMAS_PARTICLE_MUON then
            PUMAS.particle = 'muon'
        else
            PUMAS.particle = 'tau'
        end
        PUMAS.lifetime = tonumber(lifetime[0])
        PUMAS.mass = tonumber(mass[0])
    else
        PUMAS.particle = nil
        PUMAS.lifetime = nil
        PUMAS.mass = nil
    end
end


-------------------------------------------------------------------------------
-- Register the subpackage
-------------------------------------------------------------------------------
-- XXX add an interface to tables & properties
local mt = {__index = {}}

function physics.register_to (t)
    t.PUMAS = setmetatable(PUMAS, mt)

    for k, v in pairs(physics) do
        t[k] = v
    end
end


-------------------------------------------------------------------------------
-- Load material tables from a binary dump
-------------------------------------------------------------------------------
do
    local raise_error = error.ErrorFunction{
        argnum = 1,
        fname = 'load'
    }

    function mt.__index.load (path)
        if type(path) ~= 'string' then
            raise_error{
                expected = 'a string',
                got = 'a '..type(path),
            }
        end

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

        ffi.C.pumas_finalise()
        local errmsg = call.protected(ffi.C.pumas_load, f)
        update(PUMAS)
        f:close()
        if errmsg then
            raise_error{
                header = 'error when loading PUMAS materials',
                errmsg
            }
        end
    end
end


-------------------------------------------------------------------------------
-- Dump the current material tables to a binary file
-------------------------------------------------------------------------------
do
    local raise_error = error.ErrorFunction{
        argnum = 1,
        fname = 'dump'
    }

    function mt.__index.dump (path)
        local f = io.open(path, 'wb')
        if f == nil then
            raise_error('could not open file '..path)
        end

        local errmsg = call.protected(ffi.C.pumas_dump, f)
        f:close()
        if errmsg then
            raise_error{
                header = 'error when dumping PUMAS materials',
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
    local mt = {__index={}}

    -- Add a line of text
    function mt.__index:push (s,...)
        table.insert(self, string.format(s,...))
        return self
    end

    -- Pop the full text with OS specific line seps
    function mt.__index:pop ()
        return table.concat(self, LINESEP)
    end

    function Text () return setmetatable({}, mt) end
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
function mt.__index.build (args)
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

    if particle == nil then
        particle = ffi.C.PUMAS_PARTICLE_MUON
    else
        if type(particle) ~= 'string' then
            raise_error{
                argname = 'particle',
                expected = 'a string',
                got = 'a '..type(particle)
            }
        end

        local tmp = particle:lower()
        if tmp == 'muon' then
            particle = ffi.C.PUMAS_PARTICLE_MUON
        elseif tmp == "tau" then
            particle = ffi.C.PUMAS_PARTICLE_TAU
        else
            raise_error{
                argname = 'particle',
                expected = "'muon' or 'tau'",
                got = "'"..particle.."'"
            }
        end
    end

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
            got 'a '..type(energies)
        }
    end

    if path == nil then
        path = '.'
    elseif type(path) ~= 'string' then
        raise_error{
            argname = 'path',
            expected = 'a string',
            got = 'a'..type(path)
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
        for i, name in ipairs(materials) do
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
        for i = 1, n do table.remove(materials) end
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
        if material.__metatype ~= 'material' then
            raise_error{
                argname = 'materials',
                expected =  'a material',
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

    for i, name in ipairs(mlist) do
        xml:push('')
        local dedx = snakify(name)..'.txt'
        xml:push('  <material name="%s" file="%s">', name, dedx)
        local m = materials[name]

        local padmax = 0
        for _, v in ipairs(m.composition) do
            local n = #v[1]
            if n > padmax then padmax = n end
        end

        for _, value in ipairs(m.composition) do
            local symbol, wi = unpack(value)
            local pad = string.rep(" ", padmax - #symbol)
            xml:push(
                '    <component name="%s"%s fraction="%6f" />',
                symbol, pad, wi)
        end
        xml:push('  </material>')
    end

    if composites then
        for name, composition in pairs(composites) do
            local padmax = 0
            for _, v in ipairs(composition) do
                local n = #v[1]
                if n > padmax then padmax = n end
            end

            xml:push('')
            xml:push('  <composite name="%s">', name)
            for _, v in ipairs(composition) do
                local m = materials[v[1]]
                local pad = string.rep(" ", padmax - #v[1])
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

    -- Backup the current materials and set a restore point
    local materials_backup
    if ffi.C.pumas_material_length() > 0 then
        materials_backup = io.tmpfile()
        ffi.C.pumas_dump(materials_backup)
        materials_backup:seek('set', 0)
    end

    local function restore_materials()
        ffi.C.pumas_finalise()
        if materials_backup == nil then return end
        ffi.C.pumas_load(materials_backup)
        materials_backup:close()
        materials_backup = nil
    end

    -- Generate the energy loss tables
    ffi.C.pumas_finalise()
    ffi.C.pumas_tabulation_initialise(particle, mdf)
    local data = ffi.new('struct pumas_tabulation_data')
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
        ffi.C.pumas_material_index(name, index)
        m.index = index[0]
        m.density = material.density
        m.I = material.I * 1E-09
        if material.state == nil then
            m.state = C.PUMAS_TABULATION_STATE_UNKNOWN
        else
            m.state = ({
                solid  = ffi.C.PUMAS_TABULATION_STATE_SOLID,
                liquid = ffi.C.PUMAS_TABULATION_STATE_LIQUID,
                gaz    = ffi.C.PUMAS_TABULATION_STATE_GAZ
            })[material.state:lower()]
        end
        m.a = material.a
        m.k = material.k
        m.x0 = material.x0
        m.x1 = material.x1
        m.Cbar = material.Cbar
        m.delta0 = material.delta0

        ok, errormsg = pcall(ffi.C.pumas_tabulation_tabulate, data)
        if not ok then break end
    end
    ffi.C.pumas_tabulation_clear(data)
    outdir = nil
    if not ok then
        restore_materials()
        raise_error{
            description = errormsg
        }
    end

    if compile then
        -- Generate a binary dump
        local dump
        ffi.C.pumas_finalise()
        ffi.C.pumas_initialise(particle, mdf, path)
        dump = path..os.PATHSEP..project..'.pumas'
        local f = io.open(dump, 'w+')
        ffi.C.pumas_dump(f)
        f:close()
    end

    restore_materials()
end


-------------------------------------------------------------------------------
-- Return the package
-------------------------------------------------------------------------------
return physics
