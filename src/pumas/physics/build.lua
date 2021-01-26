-------------------------------------------------------------------------------
-- Build physics tabulations for PUMAS
-- Author: Valentin Niess
-- License: GNU LGPL-3.0
-------------------------------------------------------------------------------
local ffi = require('ffi')
local call = require('pumas.call')
local clib = require('pumas.clib')
local elements = require('pumas.elements')
local error = require('pumas.error')
local materials_ = require('pumas.materials')
local metatype = require('pumas.metatype')
local os = require('pumas.os')
local utils = require('pumas.physics.utils')

local build = {}


-------------------------------------------------------------------------------
-- Tabulate a set of materials
-------------------------------------------------------------------------------
local function tabulate_materials (_, args)
    local raise_error = error.ErrorFunction{fname = 'build'}

    if type(args) ~= 'table' then
        raise_error{
            argnum = 1,
            expected = 'a table',
            got = 'a '..type(args),
        }
    end

    -- XXX Simplify path / project

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

    particle = utils.particle_ctype(particle, raise_error)

    if energies == nil then
        if particle == clib.PUMAS_PARTICLE_MUON
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
        local ok, errmsg = utils.makedirs(path)
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
            for tag, _ in pairs(composition) do
                local m = materials[tag]
                if not m then
                    raise_error{
                        argname = 'composites',
                        description = "missing material '"..tag..
                                      "' for composite '"..name.."'"
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
        for name, _ in pairs(material.elements) do
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

    local xml = utils.Text()
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
        local symbol, e = v[1], v[2]
        local align1 = string.rep(' ', padmax - #symbol)
        local align2 = e.Z >= 10 and '' or ' '
        local align3 = e.A >= 10 and '' or ' '
        local align4 = e.I >= 100E-09 and '' or ' '
        xml:push(
            '  <element name="%s"%s Z="%d"%s A="%.6f"%s I="%.1f"%s />',
            symbol, align1, e.Z, align2, e.A, align3, e.I * 1E+09, align4)
    end

    for _, name in ipairs(mlist) do
        xml:push('')
        local dedx = utils.snakify(name)..'.txt'
        local m = materials[name]
        xml:push('  <material name="%s" file="%s" density="%.7g">',
            name, dedx, m.density * 1E-03)

        local padmax2 = 0
        for symbol, _ in pairs(m.elements) do
            local n = #symbol
            if n > padmax2 then padmax2 = n end
        end

        local tmp = {}
        for symbol, wi in pairs(m.elements) do
            table.insert(tmp, {wi, symbol})
        end
        table.sort(tmp, function (a, b) return a[1] >= b[1] end)

        for _, v in ipairs(tmp) do
            local pad = string.rep(" ", padmax2 - #v[2])
            xml:push(
                '    <component name="%s"%s fraction="%.7g" />',
                v[2], pad, v[1])
        end
        xml:push('  </material>')
    end

    if composites then
        for name, compo in pairs(composites) do
            local padmax2 = 0
            for tag, _ in pairs(compo) do
                local n = #tag
                if n > padmax2 then padmax2 = n end
            end

            xml:push('')
            xml:push('  <composite name="%s">', name)

            local tmp = {}
            for tag, fraction in pairs(compo) do
                table.insert(tmp, {fraction, tag})
            end
            table.sort(tmp, function (a, b) return a[1] >= b[1] end)

            for _, v in ipairs(tmp) do
                local pad = string.rep(" ", padmax2 - #v[2])
                xml:push('    <component name="%s"%s fraction="%.7g" />',
                    v[2], pad, v[1])
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
    ffi.gc(physics_, clib.pumas_physics_destroy)
    call(clib.pumas_physics_create_tabulation, physics_, particle, mdf)

    local data = ffi.new('struct pumas_physics_tabulation_data')
    local outdir
    if path ~= nil then outdir = ffi.new('char [?]', #path + 1, path) end
    data.outdir = outdir
    data.overwrite = 1
    data.n_kinetics = ffi.sizeof(energies) / ffi.sizeof('double')
    data.kinetic = energies

    local errormsg
    for name, material in pairs(materials) do
        local m = data.material
        local index = ffi.new('int [1]')
        clib.pumas_physics_material_index(physics_[0], name, index)
        m.index = index[0]
        m.density = material.density
        m.I = material.I
        if material.state == nil then
            m.state = clib.PUMAS_PHYSICS_STATE_UNKNOWN
        else
            m.state = ({
                solid  = clib.PUMAS_PHYSICS_STATE_SOLID,
                liquid = clib.PUMAS_PHYSICS_STATE_LIQUID,
                gaz    = clib.PUMAS_PHYSICS_STATE_GAZ
            })[material.state:lower()]
        end
        m.density_effect.a = material.a
        m.density_effect.k = material.k
        m.density_effect.x0 = material.x0
        m.density_effect.x1 = material.x1
        m.density_effect.Cbar = material.Cbar
        m.density_effect.delta0 = material.delta0

        errormsg = call.protected(
            clib.pumas_physics_tabulate, physics_[0], data)
        if errormsg then break end
    end
    clib.pumas_physics_tabulation_clear(physics_[0], data)
    if errormsg then
        clib.pumas_physics_destroy(physics_)
        raise_error{
            description = errormsg
        }
    end

    if compile then
        -- Generate a binary dump
        local dump
        clib.pumas_physics_destroy(physics_)
        call(clib.pumas_physics_create, physics_, particle, mdf, path)
        dump = path..os.PATHSEP..project..'.pumas'
        local file = io.open(dump, 'w+')
        call(clib.pumas_physics_dump, physics_[0], file)
        file:close()
    end

    clib.pumas_physics_destroy(physics_)
end


-------------------------------------------------------------------------------
-- Return the sub-package
-------------------------------------------------------------------------------
return setmetatable(build, {__call = tabulate_materials})
