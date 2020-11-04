-------------------------------------------------------------------------------
-- PUMAS wrapper
-- Author: Valentin Niess
-- License: LGPL-v3
-------------------------------------------------------------------------------
local ffi = require 'ffi'
local jit = require 'jit'
require 'lfs'
require 'pumas.header.api'
require 'pumas.header.extensions'
require 'pumas.header.gull'
require 'pumas.header.turtle'

local _M = {}


-------------------------------------------------------------------------------
-- Set some OS specific constants
-------------------------------------------------------------------------------
local PATHSEP, LINESEP, LIBEXT
if jit.os == 'Windows' then
    PATHSEP = '\\'
    LINESEP = '\r\n'
    LIBEXT = 'dll'
else
    PATHSEP = '/'
    LINESEP = '\n'
    LIBEXT = 'so'
end


-------------------------------------------------------------------------------
-- Load the C libraries and their extensions, if not embedded in the runtime
-------------------------------------------------------------------------------
do
    local ok = pcall(function () return ffi.C.pumas_error_initialise end)
    if not ok then
        local _, path = ... -- Lua 5.2
        if path == nil then
            path = debug.getinfo(1, 'S').source:sub(2) -- Lua 5.1
        end
        if (love ~= nil) and (lfs.attributes(path) == nil) then
            -- Patch for Love when the module is located in-source
            path = love.filesystem.getSource() .. path
        end

        local dirname = path:match('(.*' .. PATHSEP .. ')')
        local libname = 'libpumas_extended.' .. LIBEXT
        ffi.load(dirname .. libname, true) -- Load to private space?
    end
end


-------------------------------------------------------------------------------
-- Import the table.new extension or set a patch
-------------------------------------------------------------------------------
do
    -- Try to import some useful extensions
    local ok = pcall(require, 'table.new')
    if not ok then -- XXX Append to a core module?
        table.new = function () return {} end
        package.loaded['table.new'] = {}
    end
end


-------------------------------------------------------------------------------
-- Prototypes of some standard C functions
-------------------------------------------------------------------------------
ffi.cdef [[
void * calloc(size_t, size_t);
void free(void *);
size_t fwrite(const void * ptr, size_t size, size_t nmemb,
    struct FILE * stream);
void * malloc(size_t);
]]


-------------------------------------------------------------------------------
-- Generic error messages formater
-------------------------------------------------------------------------------
local function raise (args)
    local msg = {}

    if args.header ~= nil then
        table.insert(msg, args.header)
    elseif args.type ~= nil then
        if args.bad_member ~= nil then
            table.insert(msg, "'" .. args.type .. "' has no member named '" ..
                              args.bad_member .. "'")
        elseif args.not_mutable ~= nil then
            table.insert(msg, "cannot modify '" .. args.not_mutable ..
                              " for '" .. args.type .. "'")
        else
            table.insert(msg, "an unknown error occured related to '" ..
                              args.type .. "'")
        end
    else
        if args.argnum ~= nil then
            if type(args.argnum) == 'number' then
                table.insert(msg, 'bad argument #' .. args.argnum)
            else
                table.insert(msg, 'bad number of argument(s)')
            end
        elseif args.argname ~= nil then
            table.insert(msg, "bad argument '" .. args.argname .. "'")
        else
            table.insert(msg, "bad argument(s)")
        end

        if args.fname ~= nil then
            table.insert(msg, "to '" .. args.fname .. "'")
        end
    end

    local description = {}
    if args.description ~= nil then
        table.insert(description, args.description)
    else
        if args.expected ~= nil then
            table.insert(description, 'expected ' .. args.expected)
        end
        if args.got ~= nil then
            table.insert(description, 'got ' .. args.got)
        end
    end

    if #description > 0 then
        description = table.concat(description, ', ')
        table.insert(msg, '(' .. description .. ')')
    end
    msg = table.concat(msg, ' ')

    local depth
    if args.depth == nil then
        depth = 2
    else
        depth = args.depth
    end

    error(msg, depth + 1)
end


-- Generate an error function with default format parameters
local function ErrorFunction (default_args)
    return function (extra_args)
        local args = {}
        for k, v in pairs(default_args) do
            args[k] = v
        end

        if type(extra_args) == 'string' then
            args.description = extra_args
        elseif extra_args ~= nil then
            for k, v in pairs(extra_args) do
                args[k] = v
            end
        end

        if args.depth ~= nil then
            args.depth = args.depth + 1
        else
            args.depth = 3
        end

        raise(args)
    end
end


-------------------------------------------------------------------------------
-- Extended type function handling PUMAS metatypes as well
-------------------------------------------------------------------------------
local function metatype (self)
    local tp = self.__metatype
    if tp ~= nil then
        if type(tp) == 'string' then
            return tp
        end
        return tostring(tp):match('<[^>]+>')
    else
        return type(self)
    end
end


local function a_metatype (self)
    local tp = metatype(self)
    if tp == 'nil' then
        return tp
    else
        return 'a ' .. tp
    end
end


-------------------------------------------------------------------------------
-- Forward enumerations (XXX wrap with an enum metatype)
-------------------------------------------------------------------------------
do
    local decay_tags = {
        'DECAY_NONE', 'DECAY_PROCESS', 'DECAY_WEIGHT'
    }

    local event_tags = {
        'EVENT_LIMIT', 'EVENT_LIMIT_DISTANCE', 'EVENT_LIMIT_GRAMMAGE',
        'EVENT_LIMIT_KINETIC', 'EVENT_LIMIT_TIME', 'EVENT_MEDIUM',
        'EVENT_NONE', 'EVENT_START', 'EVENT_STOP', 'EVENT_VERTEX',
        'EVENT_VERTEX_BREMSSTRAHLUNG', 'EVENT_VERTEX_COULOMB',
        'EVENT_VERTEX_DECAY', 'EVENT_VERTEX_DEL', 'EVENT_VERTEX_DELTA_RAY',
        'EVENT_VERTEX_PAIR_CREATION', 'EVENT_VERTEX_PHOTONUCLEAR',
        'EVENT_WEIGHT'
    }

    local scheme_tags = {
        'SCHEME_CSDA', 'SCHEME_DETAILED', 'SCHEME_HYBRID', 'SCHEME_NO_LOSS'
    }

    local function Tagger (tags)
        local mapping = {}

        for _, tag in ipairs(tags) do
            local index = ffi.C['PUMAS_' .. tag]
            _M[tag] = index
            mapping[index] = tag
        end

        return function (i)
            return mapping[i]
        end
    end

    _M.decay_tostring = Tagger(decay_tags)
    _M.event_tostring = Tagger(event_tags)
    _M.scheme_tostring = Tagger(scheme_tags)
end


-------------------------------------------------------------------------------
-- Wrap calls to C libraries in order to forward error messages
-------------------------------------------------------------------------------
do
    ffi.C.pumas_error_initialise()

    local raise_error = ErrorFunction{header = 'C library error'}

    local pattern = '[^}]+} (.*)$'

    function _M._ccall (func, ...)
        if func(...) ~= 0 then
            local msg = ffi.string(ffi.C.pumas_error_get())
            raise_error(msg:match(pattern))
        end
    end

    function _M._pccall (func, ...)
        if func(...) ~= 0 then
            local msg = ffi.string(ffi.C.pumas_error_get())
            raise_error(msg:match(pattern))
        end
    end
end


-------------------------------------------------------------------------------
-- Main PUMAS table for managing global/shared data
-------------------------------------------------------------------------------
do
    local PUMAS = {}

    -- Update the PUMAS table constants, e.g. on a library initialisation
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

    -- Set the PUMAS library version tag
    do
        local tag = ffi.C.pumas_tag()
        local major = math.floor(tag / 1000)
        local minor = tag - major
        PUMAS.version = string.format('%d.%d', major, minor)
    end

    -- XXX add an interface to tables & properties
    local mt = {__index = {}}
    _M.PUMAS = setmetatable(PUMAS, mt)

    -- Load material tables from a binary dump
    do
        local raise_error = ErrorFunction{
            argnum = 1,
            fname = 'load'
        }

        function mt.__index.load (path)
            if type(path) ~= 'string' then
                raise_error{
                    expected = 'a string',
                    got = 'a ' .. type(path),
                }
            end

            local mode, errmsg = lfs.attributes(path, 'mode')
            if mode == nil then
                raise_error(errmsg)
            elseif mode == 'directory' then
                path = path .. PATHSEP .. 'materials.pumas'
            end

            local f = io.open(path, 'rb')
            if f == nil then
                raise_error('could not open file ' .. path)
            end

            ffi.C.pumas_finalise()
            local errmsg = _M._pccall(ffi.C.pumas_load, f)
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

    -- Dump the current material tables to a binary file
    do
        local raise_error = ErrorFunction{
            argnum = 1,
            fname = 'dump'
        }

        function mt.__index.dump (path)
            local f = io.open(path, "wb")
            if f == nil then
                raise_error('could not open file ' .. path)
            end

            local errmsg = _M._pccall(ffi.C.pumas_dump, f)
            f:close()
            if errmsg then
                raise_error{
                    header = 'error when deumping PUMAS materials',
                    errmsg
                }
            end
        end
    end

    -- Convert a Camel like name to a snaky one
    local snakify
    do
        local function f (w) return "_" .. w:lower() end

        function snakify (camel)
            camel = camel:sub(1,1):lower() .. camel:sub(2)
            return camel:gsub("%u", f)
                        :gsub("%d+", f)
        end
    end

    -- Text buffer used for building up multi-lines text contents
    local Text
    do
        local mt = {__index={}}

        -- Add a line of text
        function mt.__index:push (s, ...)
            table.insert(self, string.format(s, ...))
            return self
        end

        -- Pop the full text with OS specific line seps
        function mt.__index:pop ()
            return table.concat(self, LINESEP)
        end

        function Text () return setmetatable({}, mt) end
    end

    -- Recursively create a new directory if it does not already exist
    local function makedirs (path)
        local dir = ''
        for s in path:gmatch(PATHSEP .. '?[^' .. PATHSEP .. ']+') do
            dir = dir .. s
            if lfs.attributes(dir, "mode") == nil then
                local ok, err = lfs.mkdir(dir)
                if not ok then return nil, err end
            end
        end
        return true
    end

    -- Tabulate a set of materials
    function mt.__index.build (args)
        local raise_error = ErrorFunction{fname = 'build'}

        if type(args) ~= 'table' then
            raise_error{
                argnum = 1,
                expected = 'a table',
                got = 'a ' .. type(args),
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
                got = 'a ' .. type(project)
            }
        end

        if compile == nil then
            compile = true
        elseif type(compile) ~= 'boolean' then
            raise_error{
                argname = 'compile',
                expected = 'a boolean',
                got = 'a ' .. type(compile)
            }
        end

        if particle == nil then
            particle = ffi.C.PUMAS_PARTICLE_MUON
        else
            if type(particle) ~= 'string' then
                raise_error{
                    argname = 'particle',
                    expected = 'a string',
                    got = 'a ' .. type(particle)
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
                    got = "'" .. particle .. "'"
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
                    got = "'" .. energies .. "'"
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
                        got = 'n = ' .. n
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
                got 'a ' .. type(energies)
            }
        end

        if path == nil then
            path = '.'
        elseif type(path) ~= 'string' then
            raise_error{
                argname = 'path',
                expected = 'a string',
                got = 'a' .. type(path)
            }
        end

        if path ~= "." then
            local ok, errmsg = makedirs(path)
            if not ok then error(errmsg, 2) end
        end

        if materials == nil then
            error("missing materials to 'build'", 2)
        else
            local tp = type(materials)
            if tp == 'string' then
                materials = {materials}
            elseif tp ~= 'table' then
                raise_error{
                    argname = 'materials',
                    expected = 'a string or a table',
                    got = 'a ' .. tp
                }
            end
        end

        if #materials > 0 then
            for i, name in ipairs(materials) do
                if materials[name] ~= nil then
                    raise_error{
                        argname = 'materials',
                        description = "duplicated material name '" ..
                                      name .. "'"
                    }
                end

                local material = _M.MATERIALS[name]
                if not material then
                    raise_error{
                        argname = 'materials',
                        description = "unknown material '" .. name .. "'"
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
                    got = 'a ' .. type(composites)
                }
            end
            for name, composition in pairs(composites) do
                for _, v in ipairs(composition) do
                    local m = materials[v[1]]
                    if not m then
                        raise_error{
                            argname = 'composites',
                            description = "missing material '" .. v[1] ..
                                          "' for composite '" .. name "'"
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
                    got =  a_metatype(material)
                }
            end
            for _, v in pairs(material.composition) do
                local name = v[1]
                if not composition[name] then
                    local element = _M.ELEMENTS[name]
                    if not element then
                        raise_error{
                            argname = 'materials',
                            description = "unknown element '" .. name .. "'"
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
            local dedx = snakify(name) .. '.txt'
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

        local mdf = path .. PATHSEP .. project .. '.xml'
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
            error(errormsg, 2)
        end

        if compile then
            -- Generate a binary dump
            local dump
            ffi.C.pumas_finalise()
            ffi.C.pumas_initialise(particle, mdf, path)
            dump = path .. PATHSEP .. project .. '.pumas'
            local f = io.open(dump, 'w+')
            ffi.C.pumas_dump(f)
            f:close()
        end

        restore_materials()
    end
end


-------------------------------------------------------------------------------
-- The atomic Element metatype
-------------------------------------------------------------------------------
do
    local mt = {__index = {}}

    mt.__index.__metatype = 'element'

    do
        local raise_error = ErrorFunction{fname = 'Element'}

        function _M.Element (Z, A, I)
            local index, tp
            if type(Z) ~= 'number' then index, tp = 1, type(Z) end
            if type(A) ~= 'number' then index, tp = 2, type(A) end
            if type(I) ~= 'number' then index, tp = 3, type(I) end
            if index ~= nil then
                raise_error{
                    argnum = index,
                    expected = 'a number',
                    got = 'a ' .. tp
                }
            end

            local self = table.new(0, 3)
            self.Z = Z
            self.A = A
            self.I = I

            return setmetatable(self, mt)
        end
    end

    -- Load the elements data
    local elements = require 'pumas.data.elements'

    -- The elements table
    _M.ELEMENTS = require 'pumas.data.elements'
    for k, v in pairs(_M.ELEMENTS) do
        _M.ELEMENTS[k] = setmetatable(v, mt)
    end
end


-------------------------------------------------------------------------------
-- The Material metatype
-------------------------------------------------------------------------------
do
    local mt = {__index = {}}

    mt.__index.__metatype = 'material'

    local raise_error = ErrorFunction{fname = 'Material'}

    function _M.Material (args)
        if type(args) ~= 'table' then
            raise_error{
                argnum = 1,
                expected = 'a table',
                got = type(args)
            }
        end

        local formula, composition, density, state, I, a, k, x0, x1, Cbar,
              delta0
        for k, v in pairs(args) do
            if     k == 'formula' then formula = v
            elseif k == 'composition' then composition = v
            elseif k == 'density' then density = v
            elseif k == 'state' then state = v
            elseif k == 'I' then I = v
            elseif k == 'a' then a = v
            elseif k == 'k' then k = v
            elseif k == 'x0' then x0 = v
            elseif k == 'x1' then x1 = v
            elseif k == 'Cbar' then Cbar = v
            elseif k == 'delta0' then delta0 = v
            else
                raise_error{
                    argname = k,
                    description = 'unknown parameter'
                }
            end
        end

        -- XXX check the type of other args
        if type(density) ~= 'number' then
            raise_error{
                argname = 'density',
                expected = 'a number',
                got = type(density)
            }
        end

        if delta0 == nil then delta0 = 0 end

        local self = {}

        if formula then
            -- Parse the chemical composition and compute the mass fractions
            self.formula = args.formula
            local composition, norm = {}, 0
            for symbol, count in formula:gmatch('(%u%l?)(%d*)') do
                count = tonumber(count) or 1
                local wi = count * _M.ELEMENTS[symbol].A
                table.insert(composition, {symbol, wi})
                norm = norm + wi
            end
            norm = 1 / norm
            for _, value in ipairs(composition) do
                local symbol, wi = unpack(value)
                value[2] = wi * norm
            end
            self.composition = composition
        elseif composition then
            -- Use the provided composition
            self.composition = composition
        else
            raise_error{description = "missing 'composition' or 'formula'"}
        end

        local ZoA, mee = 0, 0
        for _, value in ipairs(self.composition) do
            local symbol, wi = unpack(value)
            local e = _M.ELEMENTS[symbol]
            if e == nil then
                raise_error{description = "unknown element '" .. symbol .. "'"}
            end
            local tmp = wi * e.Z / e.A
            ZoA = ZoA + tmp
            mee = mee + tmp * math.log(e.I)
        end
        self.ZoA = ZoA
        if not I then
            I = math.exp(mee / ZoA) * 1.13 -- 13% rule, see Groom et al.
        end
        self.I = I
        self.density = density

        if state then
            local tmp = state:lower()
            if (tmp ~= 'gaz') and (tmp ~= 'liquid') and (tmp ~= 'solid') then
                raise_error{
                    argname = 'state',
                    expected = "'solid', 'liquid' or 'gaz'",
                    got = "'" .. state .. "'"
                }
            end
            state = tmp
        else
            if self.density < 0.1E+03
            then state = 'gaz'
            else state = 'liquid'
            end
        end
        self.state = state

        -- Set the Sternheimer coefficients. If not provided the Sternheimer
        -- and Peierls recipe is used
        if k == nil then k = 3 end
        self.k = k

        if not Cbar then
            local hwp = 28.816E-09 * math.sqrt(density * 1E-03 * ZoA)
            Cbar = 2 * math.log(self.I / hwp)
        end
        self.Cbar = Cbar

        if not x0 then
            if state == 'gaz' then
                if     Cbar <= 10     then x0 = 1.6
                elseif Cbar <= 10.5   then x0 = 1.7
                elseif Cbar <= 11     then x0 = 1.8
                elseif Cbar <= 11.5   then x0 = 1.9
                elseif Cbar <= 13.804 then x0 = 2
                else                       x0 = 0.326 * Cbar - 1.5
                end
            elseif I <= 100 then
                if   Cbar <= 3.681
                then x0 = 0.2
                else x0 = 0.326 * Cbar - 1
                end
            else
                if   Cbar <= 5.215
                then x0 = 0.2
                else x0 = 0.326 * Cbar - 1.5
                end
            end
        end
        self.x0 = x0

        if not x1 then
            if state == 'gaz' then
                if   Cbar < 13.804
                then x1 = 4
                else x1 = 5
                end
            elseif I <= 100 then
                x1 = 2
            else
                x1 = 3
            end
        end
        self.x1 = x1

        if not a then
            local dx = x1 - x0
            a = (Cbar - 2 * math.log(10) * x0) / (dx * dx * dx)
        end
        self.a = a

        self.delta0 = delta0

        return setmetatable(self, mt)
    end

    -- The materials table
    _M.MATERIALS = require 'pumas.data.materials'
    for k, v in pairs(_M.MATERIALS) do
        v.density = v.density * 1E+03 -- XXX use kg / m^3
        _M.MATERIALS[k] = _M.Material(v)
    end
end


-------------------------------------------------------------------------------
-- Inverse mapping between C media and their Lua wrappers
-------------------------------------------------------------------------------
local function addressof (ptr)
    return tonumber(ffi.cast('uintptr_t', ptr))
end

local media_table = {}


-------------------------------------------------------------------------------
-- The Monte Carlo context metatype
-------------------------------------------------------------------------------
-- XXX Lazy data set / get in order to handle re-initialisation of the
-- PUMAS library (& MT)
do
    local mt = {}

    local ctype = ffi.typeof('struct pumas_context')

    function mt:__index (k)
        if k == '__metatype' then
            return 'context'
        elseif k == 'geometry' then
            return self._geometry
        elseif k == 'recorder' then
            return self._recorder
        elseif k == 'random_seed' then
            return self._random_seed
        else
            return rawget(self, '_c')[k]
        end
    end

    local function event_set (self, flag)
        local c = rawget(self, '_c')
        c.event = bit.bor(tonumber(c.event), flag)
    end

    local function event_unset (self, flag)
        local c = rawget(self, '_c')
        if bit.band(tonumber(c.event), flag) == flag then
            c.event = c.event - flag
        end
    end

    local function get_random_seed ()
        local seed
        local f = io.open('/dev/urandom', 'rb') -- XXX Windows case?
        if f == nil then
            seed = os.time()
        else
            local s = f:read(4)
            f:close()
            seed = 0
            for i = 1, s:len() do seed = seed * 256 + s:byte(i) end
        end

        return seed
    end

    do
        local pumas_geometry_t = ffi.typeof('struct pumas_geometry')
        local pumas_recorder_t = ffi.typeof('struct pumas_recorder')

        function mt:__newindex (k, v)
            if k == 'distance_max' then
                if v == nil then
                    event_unset(self, _M.EVENT_LIMIT_DISTANCE)
                    v = 0
                else
                    event_set(self, _M.EVENT_LIMIT_DISTANCE)
                end
            elseif k == 'grammage_max' then
                if v == nil then
                    event_unset(self, _M.EVENT_LIMIT_GRAMMAGE)
                    v = 0
                else
                    event_set(self, _M.EVENT_LIMIT_GRAMMAGE)
                end
            elseif k == 'kinetic_limit' then
                if v == nil then
                    event_unset(self, _M.EVENT_LIMIT_KINETIC)
                    v = 0
                else
                    event_set(self, _M.EVENT_LIMIT_KINETIC)
                end
            elseif k == 'time_max' then
                if v == nil then
                    event_unset(self, _M.EVENT_LIMIT_TIME)
                    v = 0
                else
                    event_set(self, _M.EVENT_LIMIT_TIME)
                end
            elseif k == 'geometry' then
                local current_geometry = rawget(self, '_geometry')
                if current_geometry == v then return end

                if current_geometry ~= nil then
                    ffi.C.pumas_geometry_destroy(self._c)
                end

                if (v ~= nil) and (v.__metatype ~= 'geometry') then
                    raise{
                        header = 'bad type',
                        expected = 'a geometry',
                        got = a_metatype(v)
                    }
                end

                rawset(self, '_geometry', v)
                return
            elseif k == 'random_seed' then
                if v == nil then
                    v = get_random_seed()
                end
                local c = rawget(self, '_c')
                ffi.C.pumas_random_initialise(c, v)

                rawset(self, '_random_seed', v)
                return
            elseif k == 'recorder' then
                if v == nil then
                    rawset(self, '_recorder', nil)
                    self._c.recorder = nil
                else
                    if v.__metatype ~= 'recorder' then
                        raise{
                            header = 'bad type',
                            expected = 'a recorder',
                            got = a_metatype(v)
                        }
                    end
                    rawset(self, '_recorder', v)
                    self._c.recorder = v._c
                end
                return
            elseif k == 'geometry_callback' then
                local user_data = ffi.cast('struct pumas_user_data *',
                                           self._c.user_data)
                local wrapped_state = _M.State()
                user_data.geometry.callback =
                    function (geometry, state, medium, step)
                        local wrapped_medium = media_table[addressof(medium)]
                        ffi.copy(wrapped_state._c, state,
                            ffi.sizeof('struct pumas_state_extended'))
                        v(geometry, wrapped_state, wrapped_medium, step)
                    end
                return
            end

            rawget(self, '_c')[k] = v
        end
    end

    local pumas_state_t = ffi.typeof('struct pumas_state')
    local pumas_state_extended_ptr = ffi.typeof('struct pumas_state_extended *')

    local function transport (self, state)
        if state == nil then
            local nargs = (self ~= nil) and 1 or 0
            raise{
                fname = 'transport',
                argnum = 'bad',
                expected = 2,
                got = nargs
            }
        end

        if state.__metatype ~= 'state' then
            raise{
                fname = 'transport',
                argnum = 2,
                expected = 'a state',
                got = a_metatype(state)
            }
        end

        local extended_state = ffi.cast(pumas_state_extended_ptr, state._c)
        ffi.C.pumas_state_extended_reset(extended_state, self._c)

        self._geometry:_update(self)
        _M._ccall(ffi.C.pumas_transport, self._c, state._c, self._cache.event,
                 self._cache.media)
        local media = table.new(2, 0)

        for i = 1, 2 do
            if self._cache.media[i - 1] ~= nil then
                media[i] = media_table[addressof(self._cache.media[i - 1])]
            end
        end
        return self._cache.event[0], media
    end

    local function medium (self, state)
        if state == nil then
            local nargs = (self ~= nil) and 1 or 0
            raise{
                fname = 'medium',
                argnum = 'bad',
                expected = 2,
                got = nargs
            }
        end

        if state.__metatype ~= 'state' then
            raise{
                fname = 'medium',
                argnum = 2,
                expected = 'a state',
                got = a_metatype(state)
            }
        end

        local extended_state = ffi.cast(pumas_state_extended_ptr, state._c)
        ffi.C.pumas_state_extended_reset(extended_state, self._c)

        self._geometry:_update(self)
        self._c.medium(self._c, state._c, self._cache.media,
                       self._cache.distance)

        local medium
        if self._cache.media[0] ~= nil then
                medium = media_table[addressof(self._cache.media[0])]
        end
        return medium, self._cache.distance[0]
    end

    local function random (self, n)
        if (type(self) ~= 'table') or (self.__metatype ~= 'context') then
            raise{
                fname = 'random',
                argnum = 1,
                expected = 'a context',
                got = a_metatype(self)
            }
        end

        local c = rawget(self, '_c')

        if n == nil then
            return c:random()
        else
            if type(n) ~= 'number' then
                raise{
                    fname = 'random',
                    argnum = 2,
                    expected = 'a number',
                    got = a_metatype(n)
                }
            end
            local t = table.new(n, 0)
            for i = 1, n do
                t[i] = c:random()
            end
            return unpack(t)
        end
    end

    function _M.Context (args)
        if args and type(args) ~= 'table' then
            raise{
                fname = 'Context',
                argnum = 1,
                expected = 'a table',
                got = a_metatype(args)
            }
        end

        local ptr = ffi.new('struct pumas_context *[1]')
        _M._ccall(ffi.C.pumas_context_create, ptr,
                ffi.sizeof('struct pumas_user_data'))
        local c = ptr[0]
        ffi.gc(c, function () ffi.C.pumas_context_destroy(ptr) end)

        c.random = ffi.C.pumas_random_uniform01
        c.medium = ffi.C.pumas_geometry_medium

        local user_data = ffi.cast('struct pumas_user_data *', c.user_data)
        user_data.geometry.top = nil
        user_data.geometry.current = nil
        user_data.geometry.callback = nil

        local self = setmetatable({
            _c = c,
            medium = medium,
            transport = transport,
            random = random,
            _cache = {
                distance = ffi.new('double [1]'),
                event = ffi.new('enum pumas_event [1]'),
                media = ffi.new('struct pumas_medium *[2]')
            }
        }, mt)

        local seeded = false
        if args ~= nil then
            for k, v in pairs(args) do
                self[k] = v
                if k == 'random_seed' then
                    seeded = true
                end
            end
        end

        if not seeded then
            self.random_seed = nil
        end

        return self
    end
end


-------------------------------------------------------------------------------
-- The Monte Carlo state metatype
-------------------------------------------------------------------------------
do
    local mt = {__index = {}}

    local ctype = ffi.typeof('struct pumas_state_extended')
    local pumas_state_ptr = ffi.typeof('struct pumas_state *')
    local pumas_state_t = ffi.typeof('struct pumas_state')

    function clear (self)
        ffi.fill(self._c, ffi.sizeof(ctype))
        return self
    end

    function set (self, other)
        if other == nil then
            local nargs = (self ~= nil) and 1 or 0
            raise {
                fname = 'set',
                argnum = 'bad',
                expected = 2,
                got = nargs
            }
        end

        ffi.copy(self._c, other._c, ffi.sizeof(ctype))
        return self
    end

    function mt:__index (k)
        if k == '__metatype' then
            return 'state'
        elseif k == 'clear' then
            return clear
        elseif k == 'set' then
            return set
        else
            return self._c[k]
        end
    end

    function mt:__newindex (k, v)
        -- XXX check for position or direction & coordinates
        self._c[k] = v
    end

    function _M.State (args)
        local c = ffi.cast(pumas_state_ptr, ffi.C.calloc(1, ffi.sizeof(ctype)))
        ffi.gc(c, ffi.C.free)

        if args ~= nil then
            for k, v in pairs(args) do
                c[k] = v
            end
        end

        return setmetatable({_c = c}, mt)
    end
end


-------------------------------------------------------------------------------
-- The base medium incomplete metatype
-------------------------------------------------------------------------------
-- XXX Set materials from 'Material' object or string ref. MATERIALS
local BaseMedium = {}
do
    local ctype = ffi.typeof('struct pumas_medium')

    function BaseMedium:__index (k, strtype)
        if k == '__metatype' then
            return 'medium'
        elseif k == 'material' then
            return self._material
        else
            raise{
                ['type'] = strtype,
                bad_member = k,
                depth = 3
            }
        end
    end

    local function parse_material (v, strtype)
        local raise_error = ErrorFunction{
            fname = strtype,
            argname = 'material',
            depth = 3
        }

        local n = ffi.C.pumas_material_length()
        if n == 0 then
            raise_error{
                header = 'missing materials',
                description = 'none loaded',
            }
            -- XXX how to invalidate materials if reloaded?
        end

        if type(v) == 'string' then
            local index = ffi.new('int [1]')
            _M._ccall(ffi.C.pumas_material_index, v, index)
            return index[0]
        elseif type(v) == 'number' then
            if (n == 1) and (v ~= 0) then
                raise_error{
                    expected = 0,
                    got  = v
                }
            elseif (v < 0) or (v >= n) then
                raise_error{
                    expected = 'a value between 0 and ' .. tostring(n - 1),
                    got  = v
                }
            end
            return v
        else
            raise_error{
                expected = 'a number or a string',
                got = a_metatype(v)
            }
        end
    end

    function BaseMedium:__newindex (k, v, strtype)
        if k == 'material' then
            self._c.medium.material = parse_material(v, strtype)
            rawset(self, '_material', v)
        else
            raise{
                ['type'] = strtype,
                bad_member = k,
                depth = 3
            }
        end
    end

    function BaseMedium.new (ctype, ctype_ptr, material, strtype)
        local c = ffi.cast(ctype_ptr, ffi.C.calloc(1, ffi.sizeof(ctype)))
        ffi.gc(c, ffi.C.free)

        local obj = {_c = c, _material = material}
        media_table[addressof(c)] = obj

        local index = parse_material(material, strtype)
        return obj, index
    end
end


-------------------------------------------------------------------------------
-- The transparent medium
-------------------------------------------------------------------------------
do
    local strtype = 'TransparentMedium'
    local mt = {}

    function mt:__index (k)
        if k == 'density' then
            return 0
        elseif (k == 'magnet') or (k == 'material') then
            return nil
        else
            return BaseMedium.__index(self, k, strtype)
        end
    end

    function mt:__newindex (k, v)
        if (k == 'density') or (k == 'magnet') or (k == 'material') then
            raise{
                ['type'] = strtype,
                not_mutable = k
            }
        else
            BaseMedium.__newindex(self, k, v, strtype)
        end
    end

    local m = setmetatable({
        _c = ffi.C.PUMAS_MEDIUM_TRANSPARENT,
        _material = 'Transparent'
    }, mt)

    media_table[addressof(m._c)] = m

    _M.MEDIUM_TRANSPARENT = m
end


-------------------------------------------------------------------------------
-- The uniform medium metatype
-------------------------------------------------------------------------------
do
    local strtype = 'UniformMedium'
    local mt = {}

    function mt:__index (k)
        if k == 'density' then
            return self._c.locals.density
        elseif k == 'magnet' then
            return self._c.locals.magnet
        else
            return BaseMedium.__index(self, k, strtype)
        end
    end

    function mt:__newindex (k, v)
        if k == 'density' then
            self._c.locals.density = v
        elseif k == 'magnet' then
            self._c.locals.magnet = v
        else
            BaseMedium.__newindex(self, k, v, strtype)
        end
    end

    local ctype = ffi.typeof('struct pumas_medium_uniform')
    local ctype_ptr = ffi.typeof('struct pumas_medium_uniform *')

    function _M.UniformMedium (material, density, magnet)
        if material == nil then
            raise {
                fname = strtype,
                argnum = 1,
                expected = 'a string or a number',
                got = type(material)
            }
        end

        local self, index = BaseMedium.new(ctype, ctype_ptr, material, strtype)

        if density == nil then
            density = _M.MATERIALS[material].density -- XXX check if Material
        end

        ffi.C.pumas_medium_uniform_initialise(self._c, index, density, magnet)

        return setmetatable(self, mt)
    end
end


-------------------------------------------------------------------------------
-- The gradient medium metatype
-------------------------------------------------------------------------------
do
    local strtype = 'GradientMedium'

    local mt = {}

    local parse_type
    do
        local raise_error = ErrorFunction{
            fname = 'type',
            depth = 3
        }

        function parse_type (v)
            if type(v) ~= 'string' then
                raise_error{
                    expected = 'a string',
                    got = metatype(v)
                }
            end
            local tag = v:lower()
            if tag == 'linear' then
                return ffi.C.PUMAS_MEDIUM_GRADIENT_LINEAR
            elseif tag == 'exponential' then
                return ffi.C.PUMAS_MEDIUM_GRADIENT_EXPONENTIAL
            else
                raise_error{
                    expected = "'linear' or 'exponential'",
                    got = v
                }
            end
        end
    end

    function mt:__index (k)
        if k == 'type' then
            return rawget(self, '_type')
        elseif k == 'magnet' then
            return self._c.magnet
        else
            return BaseMedium.__index(self, k, strtype)
        end
    end

    function mt:__newindex (k, v)
        if k == 'type' then
            rawget(self, '_c').gradient.type = parse_type(v)
            rawset(self, '_type', v)
        elseif k == 'magnet' then
            self._c.magnet = v
        else
            BaseMedium.__newindex(self, k, v, strtype)
        end
    end

    local ctype = ffi.typeof('struct pumas_medium_gradient')
    local ctype_ptr = ffi.typeof('struct pumas_medium_gradient *')

    -- XXX Use keyword arguments instead
    function _M.GradientMedium (material, type_, axis, value, position0,
                               density0, magnet)
        if density0 == nil then
            local args = {material, type_, axis, value, position0}
            raise{
                fname = strtype,
                argnum = 'bad',
                expected = '6 or more',
                got = #args
            }
        end

        local self, index = BaseMedium.new(ctype, ctype_ptr, material, strtype)
        type_ = parse_type(type_)

        ffi.C.pumas_medium_gradient_initialise(self._c, index, type_, value,
                                               position0, density0, magnet)
        if (type(axis) == 'string') and (axis:lower() == 'vertical') then
            self._c.gradient.project =
                ffi.C.pumas_medium_gradient_project_altitude
        else
            self._c.gradient.direction = axis
        end

        return setmetatable(self, mt)
    end
end


-------------------------------------------------------------------------------
-- The base geometry metatype
-------------------------------------------------------------------------------
_M.BaseGeometry = {__index = {}} -- XXX export this? or not?
do
    function _M.BaseGeometry:new ()
        local obj = {}
        obj._daughters = {}
        obj._mothers = {}
        obj._valid = true
        return setmetatable(obj, self)
    end

    function _M.BaseGeometry:clone ()
        local mt = {__index = {}}
        mt.new = self.new
        mt.clone = self.clone
        for k, v in pairs(self.__index) do
            mt.__index[k] = v
        end
        return mt
    end

    _M.BaseGeometry.__index.__metatype = 'geometry'

    local function walk_up (geometry, f)
        for mother, count in pairs(geometry._mothers) do
            if f(mother, count) == true then break end
            walk_up(mother, f)
        end
    end

    function _M.BaseGeometry.__index:_invalidate ()
        walk_up(self, function (g) g._valid = false end)
        self._valid = false
    end

    do
        local raise_error = ErrorFunction{fname = 'insert'}

        function _M.BaseGeometry.__index:insert (...)
            local args, index, geometry, arg1 = {...}
            if #args == 0 then
                    raise_error{
                        argnum = 'bad',
                        expected = '1 or 2',
                        got = 0
                    }
            elseif type(args[1]) == 'number' then
                if #args == 1 then
                    raise_error{
                        argnum = 'bad',
                        expected = 2,
                        got = 1
                    }
                end
                index, geometry, arg1 = args[1], args[2], 2
            else
                index, geometry, arg1 = 1, args[1], 1
            end

            if geometry.__metatype ~= 'geometry' then
                raise_error{
                    argnum = arg1,
                    expected = 'a geometry',
                    got = a_metatype(geometry)
                }
            end

            -- Invalidate the geometry and its parents
            -- Also check for circular references
            local circular = self == geometry
            if not circular then
                walk_up(self, function (g)
                    if g == geometry then
                        circular = true
                        return true
                    else
                        g._valid = false
                    end
                end)
            end
            if circular then
                raise_error('circular reference')
            end
            self._valid = false

            -- Update references
            local count = geometry._mothers[self] or 0
            geometry._mothers[self] = count + 1

            table.insert(self._daughters, index, geometry)
        end
    end

    function _M.BaseGeometry.__index:remove (index)
        local geometry = table.remove(self._daughters, index)
        if geometry == nil then return end

        -- Update the mother ref
        local count = geometry._mothers[self]
        if count == 1 then
            geometry._mothers[self] = nil
        else
            geometry._mothers[self] = count - 1
        end

        -- Invalidate the geometry and its parents
        walk_up(self, function (g) g._valid = false end)
        self._valid = false

        return geometry
    end

    local function set_daughters (mother, c_mother)
        for _, daughter in ipairs(mother._daughters) do
            local c_daughter = daughter:_new()
            ffi.C.pumas_geometry_push(c_mother, c_daughter)
            set_daughters(daughter, c_daughter)
        end
    end

    function _M.BaseGeometry.__index:_update (context)
        ffi.C.pumas_geometry_reset(context._c)

        if (ffi.C.pumas_geometry_get(context._c) ~= nil) and self._valid then
            return
        end

        local c = self:_new()
        set_daughters(self, c)
        ffi.C.pumas_geometry_set(context._c, c)
        self._valid = true
    end
end


-------------------------------------------------------------------------------
-- The infinite geometry metatype
-------------------------------------------------------------------------------
do
    local InfiniteGeometry = {}

    local function new (self)
        local c = ffi.cast('struct pumas_geometry_infinite *',
            ffi.C.calloc(1, ffi.sizeof('struct pumas_geometry_infinite')))
        c.base.get = ffi.C.pumas_geometry_infinite_get
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
            return _M.BaseGeometry.__index[k]
        end
    end

    function InfiniteGeometry:__newindex (k, v)
        if k == 'medium' then
            if v == self._medium then return end
            if v.__metatype ~= 'medium' then
                raise{
                    fname = k,
                    expected = 'a medium',
                    got = a_metatype(medium)
                }
            end
            rawset(self,'_medium', v)
            self._invalidate()
        else
            rawset(self, k, v)
        end
    end

    function _M.InfiniteGeometry (medium)
        if (medium ~= nil) and (medium.__metatype ~= 'medium') then
            raise {
                fname = 'InfiniteGeometry',
                argnum = 1,
                expected = 'a medium',
                got = a_metatype(medium)
            }
        end

        local self = _M.BaseGeometry:new()
        self._medium = medium

        return setmetatable(self, InfiniteGeometry)
    end
end


-------------------------------------------------------------------------------
-- The topography data metatype
-------------------------------------------------------------------------------
do
    local mt = {__index={}}

    mt.__index.__metatype = 'topographydata'

    function mt.__index:elevation (x, y)
        if (self == nil) or (x == nil) or (y == nil) then
            local args = {self, x, y}
            raise{
                fname = 'elevation',
                argnum = 'bad',
                expected = 3,
                got = #args
            }
        end

        if type(self._elevation) == 'number' then
            return self._elevation
        else
            local z = ffi.new('double [1]')
            local inside = ffi.new('int [1]')
            _M._ccall(self._elevation, self._c, x, y, z, inside)
            if inside[0] == 1 then
                return z[0]
            else
                return nil
            end
        end
    end

    local mt_stack = {__index = {}}
    mt_stack.__index._stepper_add = ffi.C.turtle_stepper_add_stack
    mt_stack.__index._elevation = ffi.C.turtle_stack_elevation
    for k, v in pairs(mt.__index) do mt_stack.__index[k] = v end

    local mt_map = {__index = {}}
    mt_map.__index._stepper_add = ffi.C.turtle_stepper_add_map
    do
        mt_map.__index._elevation = function (self, x, y, z, inside)
            local projection = ffi.C.turtle_map_projection(self)
            if projection ~= nil then
                local xmap = ffi.new('double [1]')
                local ymap = ffi.new('double [1]')
                ffi.C.turtle_projection_project(projection, x, y, xmap, ymap)
                x, y = xmap[0], ymap[0]
            end
            return ffi.C.turtle_map_elevation(self, x, y, z, inside)
        end
    end
    for k, v in pairs(mt.__index) do mt_map.__index[k] = v end

    local mt_flat = {__index = {}}
    mt_flat.__index._stepper_add = ffi.C.turtle_stepper_add_flat
    for k, v in pairs(mt.__index) do mt_flat.__index[k] = v end

    function _M.TopographyData (data)
        if data == nil then data = 0 end

        local self = {}
        local c, ptr, metatype
        local data_type = type(data)
        if data_type == 'string' then
            local mode, errmsg = lfs.attributes(data, 'mode')
            if mode == nil then
                raise{
                    fname = 'TopographyData',
                    description = errmsg
                }
            elseif mode == 'directory' then
                ptr = ffi.new('struct turtle_stack *[1]')
                _M._ccall(ffi.C.turtle_stack_create, ptr, data, 0, nil, nil)
                c = ptr[0]
                ffi.gc(c, function () ffi.C.turtle_stack_destroy(ptr) end)
                _M._ccall(ffi.C.turtle_stack_load, c)
                metatype = mt_stack
            else
                ptr = ffi.new('struct turtle_map *[1]')
                _M._ccall(ffi.C.turtle_map_load, ptr, data)
                c = ptr[0]
                ffi.gc(c, function () ffi.C.turtle_map_destroy(ptr) end)
                metatype = mt_map
            end
        elseif data_type == 'number' then
            self._elevation = data
            metatype = mt_flat
        else
            raise{
                fname = 'TopographyData',
                argnum = 1,
                expected = 'a number or a string',
                got = a_metatype(data)
            }
        end
        self._c = c

        return setmetatable(self, metatype)
    end
end


-------------------------------------------------------------------------------
-- The Earth geometry metatype
-------------------------------------------------------------------------------
do
    local mt = {}

    local ctype = ffi.typeof('struct pumas_geometry_earth')
    local ctype_ptr = ffi.typeof('struct pumas_geometry_earth *')
    local pumas_geometry_ptr = ffi.typeof('struct pumas_geometry *')

    local function new (self)
        local c = ffi.cast(ctype_ptr, ffi.C.calloc(1, ffi.sizeof(ctype)))

        c.base.get = ffi.C.pumas_geometry_earth_get
        c.base.reset = ffi.C.pumas_geometry_earth_reset
        c.base.destroy = ffi.C.pumas_geometry_earth_destroy
        c.media = self._media
        c.n_layers = #self._layers

        _M._ccall(ffi.C.turtle_stepper_create, c.stepper)
        for i, layer in ipairs(self._layers) do
            local _, data, offset = unpack(layer)

            if i > 1 then
                _M._ccall(ffi.C.turtle_stepper_add_layer, c.stepper[0])
            end

            for j = #data, 1, -1 do
                local datum = data[j]
                if type(datum._elevation) == 'number' then
                    _M._ccall(datum._stepper_add, c.stepper[0],
                            datum._elevation + offset)
                else
                    _M._ccall(datum._stepper_add, c.stepper[0],
                            datum._c, offset)
                end
            end
        end

        c.magnet.workspace[0] = nil
        if self._magnet then
            local date = self._date or '01/01/2020'
            local matches = {}
            for match in date:gmatch('(%d+)/*') do
                table.insert(matches, tonumber(match))
            end

            local magnet
            if self._magnet == true then
                magnet = os.tmpname()
                local f = io.open(magnet, 'a+')
                f:write(require 'pumas.data.igrf13')
                f:close()
            else
                magnet = self._magnet
            end

            local errmsg = _M._pccall(
                ffi.C.gull_snapshot_create, c.magnet.snapshot, magnet,
                matches[1], matches[2], matches[3])
            if self._magnet == true then os.remove(magnet) end
            if errmsg then error(errmsg, 2) end

            c.base.magnet = ffi.C.pumas_geometry_earth_magnet
        else
            c.magnet.snapshot[0] = nil
        end

        return ffi.cast(pumas_geometry_ptr, c)
    end

    function mt:__index (k)
        if k == 'magnet' then
            return self._magnet
        elseif k == 'date' then
            return self._date
        elseif k == '_new' then
            return new
        else
            return _M.BaseGeometry.__index[k]
        end
    end

    function mt:__newindex (k, v)
        if (k == 'magnet') or (k == 'date') then
            local key = '_' .. k
            if v == rawget(self, key) then return end

            local tp = type(v)
            if (tp ~= 'string') and (tp ~= 'nil') and (tp ~= 'boolean') then
                raise{
                    fname = k,
                    expected = 'a string',
                    got = a_metatype(v)
                }
            end

            rawset(self, key, v)
            self:_invalidate()
        else
            raise{
                ['type'] = 'EarthGeometry',
                bad_member = k
            }
        end
    end

    function _M.EarthGeometry (...)
        local args, layers = {...}, {}
        for _, layer in ipairs(args) do
            local medium, data, offset = unpack(layer)

            -- XXX validate the medium and data
            -- XXX Manage geoid undulations
            -- XXX Add offset topography data?
            -- XXX Invert the order of layers?

            if data.__metatype == 'topographydata' then
                data = {data}
            end

            offset = (offset == nil) and 0 or offset

            table.insert(layers, {medium, data, offset})
        end

        local pumas_medium_ptr = ffi.typeof('struct pumas_medium *')
        local pumas_medium_ptrarr = ffi.typeof('struct pumas_medium **')
        local size = ffi.sizeof(pumas_medium_ptr)
        local media = ffi.cast(pumas_medium_ptrarr, ffi.C.calloc(#layers, size))
        ffi.gc(media, ffi.C.free)
        for i, layer in ipairs(layers) do
            if layer[1] ~= nil then
                media[i - 1] = ffi.cast(pumas_medium_ptr, layer[1]._c)
            end
        end

        local self = _M.BaseGeometry:new()
        self._media = media
        self._layers = layers

        return setmetatable(self, mt)
    end
end


-------------------------------------------------------------------------------
-- The polytope geometry metatype
-------------------------------------------------------------------------------
do
    local mt = {}

    local ctype = ffi.typeof('struct pumas_geometry_polytope')
    local ctype_ptr = ffi.typeof('struct pumas_geometry_polytope *')
    local pumas_polytope_face_t = ffi.typeof('struct pumas_polytope_face')
    local pumas_geometry_ptr = ffi.typeof('struct pumas_geometry *')
    local pumas_medium_t = ffi.typeof('struct pumas_medium')
    local pumas_medium_ptr = ffi.typeof('struct pumas_medium *')

    local function new (self)
        return ffi.cast(pumas_geometry_ptr, self._refs[1])
    end

    local function dot (a, b)
        return a[0] * b[0] + a[1] * b[1] + a[2] * b[2]
    end


    local function cross (a, b, c)
        c[0] = a[1] * b[2] - a[2] * b[1]
        c[1] = a[2] * b[0] - a[0] * b[2]
        c[2] = a[0] * b[1] - a[1] * b[0]
    end

    -- Intersection of 3 planes
    -- Ref: https://mathworld.wolfram.com/Plane-PlaneIntersection.html
    local function intersect3 (x1, n1, x2, n2, x3, n3, x)
        local det =   n1[0] * n2[1] * n3[2]
                    + n2[0] * n3[1] * n1[2]
                    + n3[0] * n1[1] * n2[2]
                    - n3[0] * n2[1] * n1[2]
                    - n1[0] * n3[1] * n2[2]
                    - n2[0] * n1[1] * n3[2]
        if math.abs(det) < 1E-13 then return false end

        local x1n1 = dot(x1, n1)
        local x2n2 = dot(x2, n2)
        local x3n3 = dot(x3, n3)
        local n2n3 = ffi.new('double [3]')
        local n3n1 = ffi.new('double [3]')
        local n1n2 = ffi.new('double [3]')
        cross(n2, n3, n2n3)
        cross(n3, n1, n3n1)
        cross(n1, n2, n1n2)

        for k = 0, 2 do
            x[k] = (x1n1 * n2n3[k] + x2n2 * n3n1[k] +
                    x3n3 * n1n2[k]) / det
        end

        return true
    end

    local function convert_polytope (polytope, all_vertices, all_faces)
        -- Find the vertices
        local vertices = {}
        local vertex = ffi.new('double [3]')
        for i = 0, polytope.n_faces - 1 do
            for j = i + 1, polytope.n_faces - 1 do
                for k = j + 1, polytope.n_faces - 1 do
                    if intersect3(
                        polytope.faces[i].origin, polytope.faces[i].normal,
                        polytope.faces[j].origin, polytope.faces[j].normal,
                        polytope.faces[k].origin, polytope.faces[k].normal,
                        vertex)
                    then
                        local valid = true
                        for l = 0, polytope.n_faces - 1 do
                            if (l ~= i) and (l ~= j) and (l ~= k) then
                                local f = polytope.faces[l]
                                local d =
                                    f.normal[0] * (vertex[0] - f.origin[0]) +
                                    f.normal[1] * (vertex[1] - f.origin[1]) +
                                    f.normal[2] * (vertex[2] - f.origin[2])
                                if d > 0 then
                                    valid = false
                                    break
                                end
                            end
                        end
                        if valid then
                            local v = ffi.new('double [3]', vertex)
                            table.insert(vertices, {i, j, k, v})
                        end
                    end
                end
            end
        end

        -- Map the faces
        local faces = {}
        local index0 = #all_vertices
        for i = 0, polytope.n_faces - 1 do
            local index = {}
            for j, vertex in ipairs(vertices) do
                if (i == vertex[1]) or (i == vertex[2]) or (i == vertex[3]) then
                    table.insert(index, {index0 + j - 1, vertex[4]})
                end
            end

            if #index >= 3 then
                local c = ffi.new('double [3]')
                for j, vertex in ipairs(index) do
                    for k = 0, 2 do
                        c[k] = c[k] + vertex[2][k]
                    end
                end
                for k = 0, 2 do
                    c[k] = c[k] / #index
                end

                local ux = ffi.new('double [3]')
                local norm = 0
                for k = 0, 2 do
                    ux[k] = index[1][2][k] - c[k]
                    norm = norm + ux[k]^2
                end
                norm = 1 / math.sqrt(norm)
                for k = 0, 2 do
                    ux[k] = ux[k] * norm
                end

                local uy = ffi.new('double [3]')
                cross(polytope.faces[i].normal, ux, uy)

                for j, vertex in ipairs(index) do
                    local r = ffi.new('double [3]')
                    for k = 0, 2 do
                        r[k] = vertex[2][k] - c[k]
                    end
                    local x = dot(r, ux)
                    local y = dot(r, uy)

                    vertex[2] = math.atan2(y, x)
                end

                table.sort(index, function (a, b)
                    return a[2] < b[2]
                end)
                for j, vertex in ipairs(index) do
                    index[j] = vertex[1]
                end

                table.insert(faces, index)
            end
        end

        -- Update all vertices and faces
        for _, vertex in ipairs(vertices) do
            local r = vertex[4]
            table.insert(all_vertices,
                {tonumber(r[0]), tonumber(r[1]), tonumber(r[2])})
        end
        for _, face in ipairs(faces) do
            table.insert(all_faces, face)
        end

        -- Convert daughter volumes
        local daughter = polytope.base.daughters
        while daughter ~= nil do
            local p = ffi.cast('struct pumas_geometry_polytope *', daughter)
            convert_polytope(p, all_vertices, all_faces)
            daughter = daughter.next
        end
    end

    local function dump_ply (self, path)
        local vertices, faces = {}, {}
        convert_polytope(self._refs[1], vertices, faces)

        local header = string.format([[
ply
format binary_little_endian 1.0
comment PUMAS geometry
element vertex %d
property double x
property double y
property double z
element face %d
property list int int vertex_index
end_header
]], #vertices, #faces)

        local file = io.open(path, 'w')
        file:write(header)
        local v = ffi.new('double [3]')
        for i, vertex in ipairs(vertices) do
            v[0] = vertex[1]
            v[1] = vertex[2]
            v[2] = vertex[3]
            ffi.C.fwrite(v, ffi.sizeof('double'), 3, file)
        end
        local size = ffi.new('int [1]')
        for i, face in ipairs(faces) do
            size[0] = #face
            ffi.C.fwrite(size, ffi.sizeof(size), 1, file)
            local index = ffi.new('int [?]', #face, face)
            ffi.C.fwrite(index, ffi.sizeof('int'), #face, file)
        end
    end

    function mt:__index (k)
        if k == '_new' then
            return new
        elseif k == 'dump' then
            return dump_ply
        elseif (k == 'insert') or (k == 'remove') then
            return
        else
            return _M.BaseGeometry.__index[k]
        end
    end

    local function get_tag(depth, index)
        local tag = '#' .. depth
        if index > 0 then tag = tag .. '.' .. index end
        return tag
    end

    local point, vector

    local function build_polytopes (args, frame, refs, depth, index)
        local medium, data, daughters = args[1], args[2], args[3]

        if (medium ~= nil) and (medium.__metatype ~= 'medium') then
            raise{
                fname = 'Polytope ' .. get_tag(depth, index),
                argnum = 1,
                expected = 'a medium',
                got = a_metatype(medium),
                depth = depth + 2
            }
        end

        if type(data) ~= 'table' then
            raise{
                fname = 'Polytope ' .. get_tag(depth, index),
                argnum = 2,
                expected = 'a table',
                got = a_metatype(data),
                depth = depth + 2
            }
        end

        local n_faces = math.floor(#data / 6)
        if #data ~= 6 * n_faces then
            raise{
                fname = 'Polytope ' .. get_tag(depth, index),
                argnum = 2,
                expected = 'n x 6 values',
                got = #data,
                depth = depth + 2
            }
        end

        if (daughters ~= nil) and (type(daughters) ~= 'table') then
            raise{
                fname = 'Polytope ' .. get_tag(depth, index),
                argnum = 3,
                expected = 'nil or a table',
                got = a_metatype(daughters),
                depth = depth + 2
            }
        end

        local size = ffi.sizeof(ctype) +
                     n_faces * ffi.sizeof(pumas_polytope_face_t)
        local mother = ffi.cast(ctype_ptr, ffi.C.calloc(1, size))
        ffi.gc(mother, ffi.C.free)
        table.insert(refs, mother)

        mother.base.get = ffi.C.pumas_geometry_polytope_get
        if medium ~= nil then
            mother.medium = ffi.cast(pumas_medium_ptr, medium._c)
            refs[medium._c] = true
        end
        mother.n_faces = n_faces

        for i = 0, n_faces - 1 do
            mother.faces[i].origin[0] = data[6 * i + 1]
            mother.faces[i].origin[1] = data[6 * i + 2]
            mother.faces[i].origin[2] = data[6 * i + 3]
            mother.faces[i].normal[0] = data[6 * i + 4]
            mother.faces[i].normal[1] = data[6 * i + 5]
            mother.faces[i].normal[2] = data[6 * i + 6]

            if frame ~= nil then
                local origin = mother.faces[i].origin
                point:set(origin)
                point.frame = frame
                point:transform(nil)
                origin[0] = point.x
                origin[1] = point.y
                origin[2] = point.z

                local normal = mother.faces[i].normal
                vector:set(normal)
                vector.frame = frame
                vector:transform(nil)
                normal[0] = vector.x
                normal[1] = vector.y
                normal[2] = vector.z
            end
        end

        mother = ffi.cast(pumas_geometry_ptr, mother)

        if daughters ~= nil then
            local last_daughter
            for i, daughter_args in ipairs(daughters) do
                local daughter = build_polytopes(daughter_args, frame, refs,
                                                 depth + 1, i)
                if i == 1 then
                    mother.daughters = daughter
                else
                    last_daughter.next = daughter
                end
                daughter.mother = mother
                last_daughter = daughter
            end
        end

        return mother
    end

    function load_ply (path)
        error('not implemented')
    end

    function _M.PolytopeGeometry (args, frame)
        local self = _M.BaseGeometry:new()
        self._refs = {}

        if frame ~= nil then
            point = _M.CartesianPoint()
            vector = _M.CartesianVector()
        end

        if type(args) == 'string' then
            args = load_ply(args)
        end

        build_polytopes(args, frame, self._refs, 1, 0)

        if frame ~= nil then
            point = nil
            vector = nil
        end

        return setmetatable(self, mt)
    end
end


-------------------------------------------------------------------------------
-- The recorder metatype
-------------------------------------------------------------------------------
do
    local mt = {}

    do
        local ctype = ffi.typeof('struct pumas_recorder')

        function mt:__index (k)
            if k == '__metatype' then
                return 'recorder'
            elseif k == 'period' then
                return self._c.period
            elseif k == 'record' then
                return self._record
            else
                raise{
                    ['type'] = 'Recorder',
                    bad_member = k
                }
            end
        end
    end

    do
        local state_size = ffi.sizeof('struct pumas_state')
        function mt:__newindex (k, v)
            if k == 'record' then
                local wrapped_state = _M.State()
                rawget(self, '_c').record =
                    function (context, state, medium, event)
                        local wrapped_medium = media_table[addressof(medium)]
                        ffi.copy(wrapped_state._c, state, state_size)
                        v(wrapped_state, wrapped_medium, tonumber(event))
                    end
                rawset(self, '_record', v)
            elseif k == 'period' then
                rawget(self, '_c').period = v
            else
                raise{
                    ['type'] = 'Recorder',
                    bad_member = k
                }
            end
        end
    end

    local function default_callback (state, medium, event)
        print(event, medium, state) -- XXX pretty print
    end

    function _M.Recorder (callback, period)
        local ptr = ffi.new('struct pumas_recorder *[1]')
        _M._ccall(ffi.C.pumas_recorder_create, ptr, 0)
        local c = ptr[0]
        ffi.gc(c, function () ffi.C.pumas_recorder_destroy(ptr) end)

        local self = setmetatable({_c = c}, mt)

        self.record = callback or default_callback
        self.period = period or 1

        return self
    end
end


-------------------------------------------------------------------------------
-- Linear transforms
-------------------------------------------------------------------------------
do
    local mt = {__index = {}}

    mt.__index.__metatype = 'transform'

    do
        local raise_error = ErrorFunction{fname = 'from_euler'}

        function mt.__index:from_euler (axis, ...)
            if (self == nil) or (axis == nil) then
                local nargs = (self ~= nil) and 1 or 0
                raise_error{
                    argnum = 'bad',
                    expected = '3 or more',
                    got = nargs
                }
            end

            if type(axis) ~= 'string' then
                raise_error{
                    argnum = 2,
                    expected = 'a string',
                    got = a_metatype(axis)
                }
            end

            local angles = {...}
            if #angles ~= #axis then
                error('from_euler: expected ' .. #axis .. ' arguments but got ' ..
                      #angles .. '.', 2)
                raise_error{
                    argnum = 'bad',
                    expected = #axis + 2,
                    got = #angles + 2
                }
            end

            if #axis == 1 then
                local c, s = math.cos(angles[1]), math.sin(angles[1])
                if (axis == 'x') or (axis == 'X') then
                    self.rotation = {{  1,  0,  0},
                                     {  0,  c,  s},
                                     {  0, -s,  c}}
                    return self
                elseif (axis == 'y') or (axis == 'Y') then
                    self.rotation = {{  c,  0,  s},
                                     {  0,  1,  0},
                                     { -s,  0,  c}}
                    return self
                elseif (axis == 'z') or (axis == 'Z') then
                    self.rotation = {{  c,  s,  0},
                                     { -s,  c,  0},
                                     {  0,  0,  1}}
                    return self
                end
            end

            -- XXX implement the general case in C
            raise_error('not implemented')
        end
    end

    _M.Transform = ffi.metatype('struct pumas_coordinates_transform', mt)
end


-------------------------------------------------------------------------------
-- The Coordinates metatypes
-------------------------------------------------------------------------------
do
    local cartesian_point_t = ffi.typeof('struct pumas_cartesian_point')
    local cartesian_vector_t = ffi.typeof('struct pumas_cartesian_vector')
    local spherical_point_t = ffi.typeof('struct pumas_spherical_point')
    local spherical_vector_t = ffi.typeof('struct pumas_spherical_vector')
    local geodetic_point_t = ffi.typeof('struct pumas_geodetic_point')
    local horizontal_vector_t = ffi.typeof('struct pumas_horizontal_vector')

    local function CoordinatesType (ctype, setter, get, transform)
        local mt = {__index = {}}

        mt.__index.__metatype = 'coordinates'

        local double3_t = ffi.typeof('double [3]')
        local raw_coordinates
        if tostring(ctype):match('_point>$') then
            raw_coordinates = 'CartesianPoint'
        else
            raw_coordinates = 'CartesianVector'
        end

        function mt.__index:set (coordinates)
            if (self == nil) or (coordinates == nil) then
                local nargs = (self ~= nil) and 1 or 0
                raise{
                    fname = 'set',
                    argnum = 'bad',
                    expected = 2,
                    got = nargs
                }
            end

            if ffi.istype(double3_t, coordinates) then
                if type(raw_coordinates) == 'string' then
                    raw_coordinates = _M[raw_coordinates]()
                end
                raw_coordinates.x = coordinates[0]
                raw_coordinates.y = coordinates[1]
                raw_coordinates.z = coordinates[2]
                coordinates = raw_coordinates
            end

            local ct = ffi.typeof(coordinates)
            if ct == ctype then
                ffi.copy(self, coordinates, ffi.sizeof(ct))
            else
                local set = setter(ct)
                if set ~= nil then
                    set(self, coordinates)
                else
                    raise{
                        fname = 'set',
                        description = 'not implemented'
                    }
                end
            end
            return self
        end

        function mt.__index:get ()
            if self == nil then
                raise{
                    fname = 'get',
                    argnum = 1,
                    expected = 'coordinates',
                    got = 'nil'
                }
            end

            if type(raw_coordinates) == 'string' then
                raw_coordinates = _M[raw_coordinates]()
            end
            if get ~= nil then
                get(raw_coordinates, self)
            else
                ffi.copy(raw_coordinates, self, ffi.sizeof(self))
            end
            raw_coordinates:transform()

            return ffi.new('double [3]', raw_coordinates.x, raw_coordinates.y,
                           raw_coordinates.z)
        end

        if transform ~= nil then
            function mt.__index:transform (frame)
                if (self == nil) or (metatype(self) ~= 'coordinates') then
                    raise{
                        fname = 'transform',
                        argnum = 1,
                        expected = 'coordinates',
                        got = a_metatype(self)
                    }
                end

                transform(self, frame)
                return self
            end
        end

        return ffi.metatype(ctype, mt)
    end

    _M.CartesianPoint = CoordinatesType(cartesian_point_t,
        function (ct)
            if ct == geodetic_point_t then
                return ffi.C.pumas_coordinates_cartesian_point_from_geodetic
            elseif ct == spherical_point_t then
                return ffi.C.pumas_coordinates_cartesian_point_from_spherical
            end
        end,
        nil,
        ffi.C.pumas_coordinates_cartesian_point_transform)

    _M.CartesianVector = CoordinatesType(cartesian_vector_t,
        function (ct)
            if ct == horizontal_vector_t then
                return ffi.C.pumas_coordinates_cartesian_vector_from_horizontal
            elseif ct == spherical_vector_t then
                return ffi.C.pumas_coordinates_cartesian_vector_from_spherical
            end
        end,
        nil,
        ffi.C.pumas_coordinates_cartesian_vector_transform)

    _M.GeodeticPoint = CoordinatesType(geodetic_point_t,
        function (ct)
            if ct == cartesian_point_t then
                return ffi.C.pumas_coordinates_geodetic_point_from_cartesian
            elseif ct == spherical_point_t then
                return ffi.C.pumas_coordinates_geodetic_point_from_spherical
            end
        end,
        ffi.C.pumas_coordinates_cartesian_point_from_geodetic)

    _M.HorizontalVector = CoordinatesType(horizontal_vector_t,
        function (ct)
            if ct == cartesian_vector_t then
                return ffi.C.pumas_coordinates_horizontal_vector_from_cartesian
            elseif ct == spherical_vector_t then
                return ffi.C.pumas_coordinates_horizontal_vector_from_spherical
            end
        end,
        ffi.C.pumas_coordinates_cartesian_vector_from_horizontal,
        ffi.C.pumas_coordinates_horizontal_vector_transform)

    _M.SphericalPoint = CoordinatesType(spherical_point_t,
        function (ct)
            if ct == cartesian_point_t then
                return ffi.C.pumas_coordinates_spherical_point_from_cartesian
            elseif ct == geodetic_point_t then
                return ffi.C.pumas_coordinates_spherical_point_from_geodetic
            end
        end,
        ffi.C.pumas_coordinates_cartesian_point_from_spherical,
        ffi.C.pumas_coordinates_spherical_point_transform)

    _M.SphericalVector = CoordinatesType(spherical_vector_t,
        function (ct)
            if ct == cartesian_vector_t then
                return ffi.C.pumas_coordinates_spherical_vector_from_cartesian
            elseif ct == horizontal_vector_t then
                return ffi.C.pumas_coordinates_spherical_vector_from_horizontal
            end
        end,
        ffi.C.pumas_coordinates_cartesian_vector_from_spherical,
        ffi.C.pumas_coordinates_spherical_vector_transform)
end


-------------------------------------------------------------------------------
-- Local Earth frames
-------------------------------------------------------------------------------
do
    local pumas_cartesian_point_t = ffi.typeof('struct pumas_cartesian_point')
    local pumas_geodetic_point_t = ffi.typeof('struct pumas_geodetic_point')

    function _M.LocalFrame (origin)
        if origin == nil then
            raise{
                fname = 'LocalFrame',
                argnum = 'bad',
                expected = 1,
                got = 0
            }
        end

        local geodetic
        if ffi.istype(pumas_geodetic_point_t, origin) then
            geodetic = origin
        else
            geodetic = _M.GeodeticPoint():set(origin)
        end

        if (not ffi.istype(pumas_cartesian_point_t, origin)) or
           (origin.frame ~= nil) then
            origin = _M.CartesianPoint():set(origin)
                                       :transform(nil)
        end

        local frame = _M.Transform()
        ffi.C.pumas_coordinates_frame_initialise_local(
            frame, origin, geodetic)

        return frame
    end
end


-------------------------------------------------------------------------------
-- Free sky muons flux models
-------------------------------------------------------------------------------
do
    _M.MUON_MASS = 0.10565839

    local function ChargeRatio (charge_ratio)
        return function (charge)
            if charge == nil then
                return 1
            elseif charge < 0 then
                return 1 / (1 + charge_ratio)
            else
                return charge_ratio / (1 + charge_ratio)
            end
        end
    end

    local function GaisserFlux (normalisation, gamma, charge_ratio)
        local ratio = ChargeRatio(charge_ratio)

        return function (kinetic, cos_theta, charge)
            if cos_theta < 0 then return 0 end
            local Emu = kinetic + _M.MUON_MASS
            local ec = 1.1 * Emu * cos_theta
            local rpi = 1 + ec / 115
            local rK = 1 + ec / 850
            return normalisation * math.pow(Emu, -gamma) *
                   (1 / rpi + 0.054 / rK) * ratio(charge)
        end
    end

    -- Volkova's parameterization of cos(theta*)
    local cos_theta_star
    do
        local p = { 0.102573, -0.068287, 0.958633, 0.0407253, 0.817285 }

        function cos_theta_star (cos_theta)
            local cs2 = (cos_theta * cos_theta + p[1] * p[1] +
                         p[2] * math.pow(cos_theta, p[3]) +
                         p[4] * math.pow(cos_theta, p[5])) /
                        (1 + p[1] * p[1] + p[2] + p[4])
            return (cs2 > 0) and math.sqrt(cs2) or 0
        end
    end

    local function GcclyFlux (normalisation, gamma, charge_ratio)
        local gaisser = GaisserFlux(normalisation, gamma, charge_ratio)

        return function (kinetic, cos_theta, charge)
            local cs = cos_theta_star(cos_theta)
            if cs < 0 then return 0 end
            local Emu = kinetic + _M.MUON_MASS
            return math.pow(1 + 3.64 / (Emu * math.pow(cs, 1.29)), -gamma) *
                   gaisser(kinetic, cs, charge)
        end
    end

    -- Chirkin's parameterization of average mass overburden as function of
    -- x=cos(theta), in g/cm^2
    local mass_overburden
    do
        local p = { -0.017326, 0.114236, 1.15043, 0.0200854, 1.16714 }

        function mass_overburden (x)
            return 1E+02 / (p[1] + p[2] * math.pow(x, p[3]) +
                            p[4] * math.pow((1 - x * x), p[5]))
        end
    end

    -- Chirkin's parameterization of average muon path length as function of
    -- x=cos(theta), in m
    local path_length
    do
        local p = { 1.3144, 50.2813, 1.33545, 0.252313, 41.0344 }

        function path_length (x)
            return 1E+06 / (p[1] + p[2] * math.pow(x, p[3]) +
                            p[4] * math.pow((1 - x * x), p[5]))
        end
    end

    local function ChirkinFlux (normalisation, gamma, charge_ratio)
        local gaisser = GaisserFlux(normalisation, gamma, charge_ratio)

        local a = 2.62E-03
        local b = 3.05E-06
        local astar = 0.487E-03
        local bstar = 8.766E-06
        local X0 = 114.8
        local c0 = astar - bstar * a / b
        c0 = c0 * c0
        local c1 = (astar * astar - c0) / a
        local c2 = bstar * bstar / b
        local d1 = 0.054

        return function (kinetic, cos_theta, charge)
            local cs = cos_theta_star(cos_theta)
            if cs < 0 then return 0 end
            local Emu = kinetic + _M.MUON_MASS

            -- Calculate the effective initial energy, EI, and its derivative
            local EI, dEIdEf
            do
                local X = mass_overburden(cos_theta) - X0
                local ebx = math.exp(b * X)
                local Ef = kinetic + _M.MUON_MASS
                local Ei = ((a + b * Ef) * ebx - a) / b

                local sE = 0.5 * c2 * (Ei * Ei - Ef * Ef) + c1 * (Ei - Ef) +
                           c0 / b * math.log((a + b * Ei) / (a + b * Ef))
                local dXf = astar + bstar * Ef
                local dXi = astar + bstar * Ei
                local dsEdEf = ebx * dXi * dXi / (a + b * Ei) -
                               dXf * dXf / (a + b * Ef)
                local d0 = 1.1 * cs / 115
                local d2 = 1.1 * cs / 850
                local d01 = 1 / (1 + d0 * Ei)
                local d21 = 1 / (1 + d2 * Ei)
                local num1 = d0 * d01 * d01
                local num2 = d1 * d2 * d21 * d21
                local num = num1 + num2
                local iden = 1 / (d01 + d1 * d21)
                local fr = -gamma / Ei - num * iden
                local dfrdEf = gamma / (Ei * Ei) +
                               (num * num * iden + 2 * (d0 * num1 * d01 +
                                                        d2 * num2 * d21)) * iden
                EI = Ei + 0.5 * sE * fr
                dEIdEf = math.abs(ebx * (1 + 0.5 * dfrdEf * sE) +
                                  0.5 * fr * dsEdEf)
            end

            -- Calculate the survival factor (W)
            local d0 = path_length(cos_theta)
            local ctau = 658.65
            local W = math.exp(-d0 / ctau * _M.MUON_MASS / EI)

            -- Return the modified Gaisser's flux
            return dEIdEf * W * gaisser(EI, cs, charge)
        end
    end

    function _M.MuonFlux (model, options)
        local raise_error = ErrorFunction{fname = 'MuonFlux'}

        if model == nil then
            raise_error{
                argnum = 'bad',
                expected = '1 or 2',
                got = 0
            }
        end
        if options == nil then options = {} end

        local tag = model:lower()
        if tag == 'tabulation' then
            local normalisation, altitude = 1
            for k, v in pairs(options) do
                if k == 'normalisation' then
                    normalisation = v
                elseif k == 'altitude' then
                    altitude = v
                else
                    raise_error{
                        argnum = 2,
                        description = "unknown option '" .. k ..
                                      "' for 'tabulation' model"
                    }
                end
            end

            local data = ffi.C.pumas_flux_tabulation_data[1]
            -- XXX interpolate with altitude

            return function (kinetic, cos_theta, charge)
                if charge == nil then charge = 0 end
                return ffi.C.pumas_flux_tabulation_get(data, kinetic, cos_theta,
                                                       charge) * normalisation
            end
        end

        local charge_ratio, gamma, normalisation
        for k, v in pairs(options) do
            if k == 'charge_ratio' then charge_ratio = v
            elseif k == 'gamma' then
                gamma = v
            elseif k == 'normalisation' then normalisation = v
            else 
                raise_error{
                    argnum = 2,
                    description = "unknown option '" .. k ..
                                  "' for '" .. model .. "' model"
                }
            end
        end

        charge_ratio = charge_ratio or 1.2766
        -- Ref: CMS (https://arxiv.org/abs/1005.5332)

        if tag == 'gaisser' then
            gamma = gamma or 2.7
            normalisation = normalisation or 1.4E+03
            return GaisserFlux(normalisation, gamma, charge_ratio)
        elseif tag == 'gccly' then
            gamma = gamma or 2.7
            normalisation = normalisation or 1.4E+03
            return GcclyFlux(normalisation, gamma, charge_ratio)
        elseif tag == 'chirkin' then
            gamma = gamma or 2.715
            normalisation = normalisation or 9.814E+02
            return ChirkinFlux(normalisation, gamma, charge_ratio)
        else
            raise_error{
                argnum = 1,
                description = "'unknown flux model '" .. model .. "'"
            }
        end
    end
end


-------------------------------------------------------------------------------
-- Wrap and return the package
-------------------------------------------------------------------------------
return setmetatable(_M, {
    __call = function (self)
        -- Export all symbols to the global namespace
        for k, v in pairs(self) do
            if k:sub(1) ~= '_' then rawset(_G, k, v) end
        end
    end
})
