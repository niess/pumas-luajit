-------------------------------------------------------------------------------
-- Build physics tabulations for PUMAS
-- Author: Valentin Niess
-- License: GNU LGPL-3.0
-------------------------------------------------------------------------------
local ffi = require('ffi')
local call = require('pumas.call')
local clib = require('pumas.clib')
local element_ = require('pumas.element')
local error = require('pumas.error')
local material_ = require('pumas.material')
local metatype = require('pumas.metatype')
local os = require('pumas.os')
local utils = require('pumas.physics.utils')

local build = {}


-------------------------------------------------------------------------------
-- Tabulate a set of materials
-------------------------------------------------------------------------------
local function tabulate_materials (_, args)
    local raise_error = error.ErrorFunction{fname = 'build'}

    if args == nil then
        raise_error{
            argnum = 'bad', expected = 1, got = 0}
    elseif type(args) ~= 'table' then
        raise_error{
            argnum = 1, expected = 'a table', got = 'a '..type(args)}
    end

    local materials, composites, path, particle, energies, compile, cutoff,
        elastic_ratio, dcs
    for k, v in pairs(args) do
        if k == 'composites' then composites = v
        elseif k == 'path' then path = v
        elseif k == 'particle' then particle = v
        elseif k == 'energies' then energies = v
        elseif k == 'compile' then compile = v
        elseif k == 'cutoff' then cutoff = v
        elseif k == 'elastic_ratio' then elastic_ratio = v
        elseif k == 'dcs' then dcs = v
        elseif k ~= 'materials' then
            raise_error{
                argname = k, description = 'unknown argument'}
        end
    end

    if compile == nil then
        compile = true
    elseif type(compile) ~= 'boolean' then
        raise_error{
            argname = 'compile', expected = 'a boolean',
            got = 'a '..type(compile)}
    end

    local settings = ffi.new('struct pumas_physics_settings [1]')
    settings[0].update = 1
    settings[0].dry = not compile

    if cutoff ~= nil then
        if type(cutoff) == 'number' then
            settings[0].cutoff = cutoff
        else
            raise_error{argname = 'cutoff', expected = 'a number',
                got = metatype.a(cutoff)}
        end
    end

    if elastic_ratio ~= nil then
        if type(elastic_ratio) == 'number' then
            settings[0].elastic_ratio = elastic_ratio
        else
            raise_error{argname = 'elastic_ratio', expected = 'a number',
                got = metatype.a(elastic_ratio)}
        end
    end

    if dcs ~= nil then
        if type(dcs) == 'table' then
            local setter = function (k, v)
                settings[0][k] = v
            end

            for k, v in pairs(dcs) do
                local ok, msg = pcall(setter, k, v)
                if not ok then
                    raise_error{argname = 'dcs', description = msg}
                end
            end
        else
            raise_error{argname = 'dcs', expected = 'a table',
                got = metatype.a(dcs)}
        end
    end

    particle = utils.particle_ctype(particle, raise_error)

    if type(energies) == 'table' then
        local n
        if #energies > 0 then
            n = #energies
            local tmp = ffi.new('double [?]', n)
            for i, v in ipairs(energies) do tmp[i - 1] = v end
            energies = tmp
        else
            n = energies.n
            local min, max = energies.min, energies.max
            if min == nil then
                raise_error{
                    argname = 'energies',
                    description = 'missing min kinetic energy'}
            end
            if max == nil then
                raise_error{
                    argname = 'energies',
                    description = 'missing max kinetic energy'}
            end
            if n == nil then
                raise_error{
                    argname = 'energies',
                    description = "missing number of kinetic energies, 'n'"}
            end
            if n <= 1 then
                raise_error{
                    argname = 'energies', expected = 'n > 1',
                    got = 'n = '..n}
            end

            energies = ffi.new("double [?]", n)
            local dlnk = math.log(max / min) / (n - 1)
            for i = 0, n - 1 do energies[i] = min * math.exp(dlnk * i) end
        end

        settings[0].n_energies = n
        settings[0].energy = energies
    elseif energies ~= nil then
        raise_error{
            argname = 'energies', expected = 'a table',
            got = metatype.a(energies)}
    end

    if path == nil then
        path = '.'
    elseif type(path) ~= 'string' then
        raise_error{
            argname = 'path', expected = 'a string', got = metatype.a(path)}
    end

    if path ~= "." then
        local ok, errmsg = utils.makedirs(path)
        if not ok then error(errmsg, 2) end
    end

    if metatype(args.materials) ~= 'table' then
        raise_error{
            argname = 'materials', expected = 'a table',
            got = metatype.a(args.materials)}
    else
        materials = {}

        for k, v in pairs(args.materials) do
            local name, material
            if type(k) == 'number' then
                name = v
                if type(name) == 'string' then
                    material = material_.materials[name]
                    if not material then
                        raise_error{
                            argname = 'materials['..k..']',
                            description = "unknown material '"..name.."'"
                        }
                    end
                else
                    raise_error{
                        argname = 'materials['..k..']', expected = 'a string',
                        got = metatype.a(name)}
                end
            elseif type(k) == 'string' then
                name, material = k, v
                if metatype(material) ~= 'Material' then
                    raise_error{
                        argname = 'materials['..name..']',
                        expected = 'a Material table',
                        got = metatype.a(material)}
                end
            end

            if materials[name] ~= nil then
                raise_error{
                    argname = 'materials',
                    description = "duplicated material name '"..name.."'"}
            else
                materials[name] = material
            end
        end
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
                local element = element_.elements[name]
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

    local dedx_list = {}
    for _, name in ipairs(mlist) do
        xml:push('')
        local dedx = utils.snakify(name)..'.txt'
        table.insert(dedx_list, dedx)
        local m = materials[name]
        xml:push('  <material name="%s" file="%s" density="%.7g" I="%.7g">',
            name, dedx, m.density * 1E-03, m.I * 1E+09)

        local padmax2 = 0
        for symbol, _ in pairs(m.elements) do
            local n = #symbol
            if n > padmax2 then padmax2 = n end
        end

        local tmp = {}
        for symbol, wi in pairs(m.elements) do
            table.insert(tmp, {wi, symbol})
        end
        table.sort(tmp, function (a, b) return a[1] > b[1] end)

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

    local mdf = path..os.PATHSEP..'materials.xml'
    local f = io.open(mdf, 'w')
    f:write(xml:pop())
    f:close()

    -- Generate the energy loss tables
    local physics_ = ffi.new('struct pumas_physics *[1]')
    ffi.gc(physics_, clib.pumas_physics_destroy)
    call(clib.pumas_physics_create, physics_, particle, mdf, nil,
        settings)

    local dump
    if compile then
        -- Generate a binary dump
        dump = path..os.PATHSEP..'materials.pumas'
        local file = io.open(dump, 'w+')
        call(clib.pumas_physics_dump, physics_[0], file)
        file:close()
    end

    clib.pumas_physics_destroy(physics_)

    return {mdf = mdf, dedx = dedx_list, dump = dump}
end


-------------------------------------------------------------------------------
-- Return the sub-package
-------------------------------------------------------------------------------
return setmetatable(build, {__call = tabulate_materials})
