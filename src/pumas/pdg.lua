-------------------------------------------------------------------------------
-- PDG related utilities for PUMAS
-- Author: Valentin Niess
-- License: GNU LGPL-3.0
-------------------------------------------------------------------------------
local error = require('pumas.error')
local material_ = require('pumas.material')
local metatype = require('pumas.metatype')
local os = require('pumas.os')

local https
do
    local ok
    ok, https = pcall(require, 'ssl.https')
    if not ok then return false end -- Disable the pdg sub-package
end

local Pdg = {__index = {}}
local pdg = setmetatable({}, Pdg)


-------------------------------------------------------------------------------
-- Base URL of PDG website and version (year)
-------------------------------------------------------------------------------
local function get_url (year)
    return "https://pdg.lbl.gov/"..year.."/AtomicNuclearProperties"
end

pdg.year = 2020
pdg.url = get_url(pdg.year)


-------------------------------------------------------------------------------
-- Wrap the year setter
-------------------------------------------------------------------------------
function Pdg:__newindex (key, value)
    if key == 'year' then
        self.url = get_url(value)
    end

    rawset(self, key, value)
end


-------------------------------------------------------------------------------
-- Wrapper for HTML requests
-------------------------------------------------------------------------------
local function request (url)
    local ok, html, code = pcall(https.request, url)
    if not ok then
        error.raise('error in https.request'..os.LINESEP..html)
    end

    if code ~= 200 then
        error.raise(string.format(
            'could not get <%s>%s%s', url, os.LINESEP, html))
    end

    return html
end


-------------------------------------------------------------------------------
-- Iterator over lines in a string
-------------------------------------------------------------------------------
local function string_lines (s)
    if s:sub(-1) ~= '\n' then s = s .. '\n' end
    return s:gmatch('(.-)[\r\n]')
end


-------------------------------------------------------------------------------
-- Fetch the index of atomic elements and/or materials
-------------------------------------------------------------------------------
function Pdg.__index.get_index (target)
    if target == nil then
        target = 'all'
    elseif type(target) ~= 'string' then
        error.raise{fname = 'get_index', argnum = 1,
            expected = 'a string or nil', got = metatype.a(target)}
    else
        local targets = {all = true, elements = true, materials = true}
        if not targets[target] then
            local expected = "'"..table.concat(targets, "', '").."'"
            error.raise{fname = 'get_index', argnum = 1,
                expected = expected, got = "'"..target.."'"}
        end
    end

    local html = request(pdg.url .. '/index.html')

    local function camelify (snake)
        snake = snake:gsub('(%w)(%w*)[_-]?',
            function(a, b) return string.upper(a) .. b end)
        return snake:gsub('[_-]', '')
    end

    local exceptions = {
        AcetyleneCHCH = 'Acetylene',
        PolymethylmethacrylateAcrylic = 'Acrylic',
        AirDry1Atm = 'Air',
        BorosilicateGlassPyrexCorning7740 = 'BorosilicateGlass',
        CarbonGemDiamond = 'CarbonDiamond',
        Epotek3011 = 'EpoTek301',
        GlucoseDextroseMonohydrate = 'Glucose',
        M3WAX = 'M3Wax',
        NylonDuPontElvamide8062M = 'NylonDuPontElvamide',
        PolyethyleneTerephthalateMylar = 'Mylar',
        PolyvinylchloridePVC = 'PVC',
        PolyvinylideneChlorideSaran = 'PolyvinylideneChloride',
        SiliconDioxideFusedQuartz = 'SiliconDioxide',
        SolidCarbonDioxideDryIce = 'CarbonDioxideIce',
        PolytetrafluoroethyleneTeflon = 'Teflon',
        WaterLiquid = 'Water'}

    local elements, materials = {}, {}
    local categories = {'elements', 'inorganics', 'inorganics', 'inorganics',
        'scintillators', 'organics', 'polymers', 'mixtures', 'biologicals'}
    local ic = 1
    local category = categories[ic]

    for line in string_lines(html) do
        if line:match('^<![-][-]') then goto nextline end

        local pattern = "<a href='?HTML/([%a%d_]*)[.]html'?>(.-)<"
        local ref_ = line:match(pattern)

        if ref_ then
            for ref, body in line:gmatch(pattern) do
                local name
                if #body > 2 then
                    name = body:match(
                        '%d+[ ]+(%u%l?)[ ]+%a+[ ]+[(]?[%a ]+[)]?')
                else
                    name = body:match('^%u%l?')
                end

                if target ~= 'materials' and not elements[name] then
                    elements[name] = ref
                end

                if target ~= 'elements' then
                    local camel = camelify(ref:gsub('_%u%l?$', ''))
                    local exception = exceptions[camel]
                    if exception then
                        camel = exception
                    end
                    materials[camel] = {reference = ref, element = name,
                        category = category}
                end
            end
        elseif target ~= 'elements' then
            local ref = line:match('<option[ ]+value=([^>]*)>.*<')
            if ref == '"#"' then
                ic = ic + 1
                category = categories[ic]
            elseif ref then
                ref = ref:match "'?HTML/([%a%d_-]*)[.]html'?"
                if ref then
                    local name = ref
                    if (category == 'inorganics' or
                        category == 'scintillators') and
                        not name:match('Paris$') then
                        name = name:gsub('_%u%a*$', '')
                    end
                    name = camelify(name):gsub('^%d*', '')
                    name = name:gsub('ICRP$', '')
                               :gsub('ICRU$', '')
                    local exception = exceptions[name]
                    if exception then
                        name = exception
                    end
                    materials[name] = {reference = ref, category = category}
                end
            end
        end
        ::nextline::
    end

    if target == 'materials' then
        return materials
    elseif target == 'elements' then
        return elements
    else
        return elements, materials
    end
end


-------------------------------------------------------------------------------
-- Fetch the raw PDG data using an HTTP GET request
-------------------------------------------------------------------------------
local function dataurl (ref)
    return pdg.url..'/HTML/'..ref..'.html'
end


local function getdata (ref, map)
    local html = request(dataurl(ref))

    local is_material = false
    do
        local count = 0
        for _, _ in pairs(map) do
            count = count + 1
            if count == 4 then
                is_material = true
                break
            end
        end
    end

    local href
    local data, composition = {}, {}
    local current_table, n_tables, line_index, key = 0, 0, 0
    for line in string_lines(html) do
        if current_table == 0 then
            if line:match('^<table') then
                n_tables = n_tables + 1
                current_table = n_tables
            elseif is_material and href == nil then
                local tmp = line:match [[^<a href="..(/MUE/muE_.*[.]txt)]]
                if tmp then href = tmp end
            end
        elseif line:match('</[Tt][Aa][Bb][Ll][Ee]>') then
            current_table = 0
        elseif current_table == 1 then
            if line_index == 0 then
                local tag = line:match('^<t[dr]>(.+)')
                if tag then
                    for k, v in pairs(map) do
                        if tag:match(k) then
                            key = v
                            break
                        end
                    end
                end
                if key then
                    line_index = line_index + 1
                end
            elseif line_index == 2 then
                local v = line:gsub('[(]%d+[)]', '')
                              :gsub('[%[%]</td>]', '')
                data[key] = tonumber(v)
                key = nil
                line_index = 0
            else
                if line:match('^<td>') then
                    line_index = line_index + 1
                end
            end
        elseif current_table == 2 then
            local symbol, Z, A, w = line:match(
                '<tr><td><center>([%a]+)[ ]*</td>\z
                 <td>([%d ]+)</td>\z
                 <td><center>([%d. ]+)</td>\z
                 <td><center>([%d. ]+)</td>')
            if symbol then
                table.insert(composition,
                    {symbol, tonumber(Z), tonumber(A), tonumber(w)})
            end
        end
    end

    if is_material then
        data.composition = composition
    end

    return data
end


-------------------------------------------------------------------------------
-- Get the PDG data for an atomic element
-------------------------------------------------------------------------------
function Pdg.__index.get_element (reference)
    if type(reference) ~= 'string' then
        error.raise{fname = 'get_element', argnum = 1,
            expected = 'a string', got = metatype.a(reference)}
    end

    local map = {['Atomic number'] = 'Z', ['Atomic mass'] = 'A',
        ['Mean excitation energy'] = 'I'}

    return getdata(reference, map)
end


-------------------------------------------------------------------------------
-- Get the PDG data for a material
-------------------------------------------------------------------------------
function Pdg.__index.get_material (reference, element)
    if type(reference) ~= 'string' then
        error.raise{fname = 'get_material', argnum = 1,
            expected = 'a string', got = metatype.a(reference)}
    end

    if element and type(element) ~= 'string' then
        error.raise{fname = 'get_element', argnum = 2,
            expected = 'a string or nil', got = metatype.a(element)}
    end

    local map = {['&#060;<I>Z/A</I>&#062;'] = 'ZoA',['Atomic number'] = 'Z',
        ['Atomic mass'] = 'A', ['Specific gravity'] = 'rho',
        ['Mean excitation energy'] = 'I', ['Radiation length'] = 'X0',
        ['Muon critical energy'] = 'Ec'}

    local data = getdata(reference, map)
    if element then
        data.composition = {{element, 0, 0, 1}}
    elseif reference == 'standard_rock' then
        data.composition = {{'Rk', 0, 0, 1}} -- Patch for standard rock
    end

    if element and (not data.rho) then
        data.rho = 14 -- Default density for heavy elements
    end

    local elements = {}
    for _, v in ipairs(data.composition) do
        elements[v[1]] = v[4]
    end

    return {
        elements = elements, density = data.rho, I = data.I
    }
end


-------------------------------------------------------------------------------
-- Wrapper for logging flushed messages
-------------------------------------------------------------------------------
local function log (verbose, msg)
    if verbose then
        print(msg)
        io.flush()
    end
end

-------------------------------------------------------------------------------
-- Generate a table of atomic elements from the PDG data
-------------------------------------------------------------------------------
function Pdg.__index.generate_elements (path, verbose)
    if path then
        if type(path) ~= 'string' then
            error.raise{fname = 'generate_elements', argnum = 1,
                expected = 'a string', got = metatype.a(path)}
        end
    else
        path = 'elements.lua'
    end

    log(verbose, 'building elements index from PDG data')
    local index = pdg.get_index('elements')

    local elements = {}
    for name, ref in pairs(index) do
        log(verbose, 'fetching PDG data for '..name)
        table.insert(elements, {name, pdg.get_element(ref), ref})
    end

    table.sort(elements, function(a, b)
        a, b = a[2], b[2]
        if a.Z == b.Z then
            return a.A < b.A
        else
            return a.Z < b.Z
        end
    end)

    log(verbose, 'generating '..path)

    local pdg_elements = {string.format([[
-- Tabulated atomic elements from the Particle Data Group (PDG)
-- Ref: %s/index.html
return {
]], pdg.url)}

    for _, e in ipairs(elements) do
        local padding = (#e[1] == 1) and ' ' or ''
        table.insert(pdg_elements,
            string.format(
                '    -- Ref: %s/HTML/%s.html'..os.LINESEP..
                '    %s%s = {A = %G, I = %G, Z = %d},',
                pdg.url, e[3], e[1], padding, e[2].A, e[2].I * 1E-09, e[2].Z))
    end
    table.insert(pdg_elements, string.format([[

    -- Fictious Rockium element for Standard Rock
    -- Ref: %s/standardrock.html
    Rk = {A = 22, I = 1.364E-07, Z = 11}
}
]], pdg.url))

    local source = table.concat(pdg_elements, os.LINESEP)

    local f = io.open(path, 'w')
    f:write(source)
    f:close()
end


-------------------------------------------------------------------------------
-- Generate a table of materials from the PDG data
-------------------------------------------------------------------------------
function Pdg.__index.generate_materials (path, verbose)
    if path then
        if type(path) ~= 'string' then
            error.raise{fname = 'generate_materials', argnum = 1,
                expected = 'a string', got = metatype.a(path)}
        end
    else
        path = 'materials.lua'
    end

    local insert, format, upper = table.insert, string.format, string.upper

    log(verbose, 'building materials index from PDG data')
    local index = pdg.get_index('materials')

    local materials = {}
    for name, datum in pairs(index) do
        log(verbose, 'fetching PDG data for '..name)
        local ok, result = pcall(
            pdg.get_material, datum.reference, datum.element)
        if ok then
            insert(materials, {name, datum.reference, result, datum.category})
        else
            log(verbose, '--> failed to fetch PDG data from '..
                dataurl(datum.reference))
        end
    end

    log(verbose, 'generating '..path)

    table.sort(materials, function(a, b)
        local name_a, name_b = a[1], b[1]
        return name_a:lower() < name_b:lower()
    end)

    local pdg_materials = {format([[
-- Tabulated materials from the Particle Data Group (PDG)
-- Ref: %s/index.html

return {
]], pdg.url)}

    local tab = string.rep(' ', 4)
    local tab2 = string.rep(tab, 2)
    for _, v in ipairs(materials) do
        local name = v[2]:gsub('_%u%l?$', '')
                         :gsub('^%w', function(a) return upper(a) end)
                         :gsub('[_]', ' ')
        insert(pdg_materials, tab..'-- '..name)
        insert(pdg_materials, format('%s-- Category: %s', tab, v[4]))
        insert(pdg_materials, format(
            '%s-- Ref: %s/HTML/%s.html', tab, pdg.url, v[2]))
        local mat = v[3]
        mat.density = mat.density * 1E+03 -- g/cm^3 -> kg/m^3
        mat.I = mat.I * 1E-09 -- eV -> GeV
        mat = material_.Material(mat)
        local m = {}
        for k, v_ in pairs(mat) do
            if k == 'state' then
                table.insert(m, k.." = '"..v_.."'")
            elseif k ~= 'elements' then
                table.insert(m, k..string.format(' = %.7G', v_))
            end
        end
        do
            local mi = {}
            for ki, vi in pairs(mat.elements) do
                table.insert(mi, ki..string.format(' = %.7G', vi))
            end
            table.insert(m, 'elements = {'..table.concat(mi, ', ')..'}')
        end
        local raw = table.concat(m, ', ')
        local repr, line, n = {}, tab2, 0
        for s in raw:gmatch('[^,]+') do
            s = s:gsub('[{ ] ', '{'):gsub(' }', '}')
            local dn = #s
            if n > 0 then dn = dn + 1 end
            if n + dn > 71 then
                insert(repr, line .. ',')
                line, n = tab2, 0
                s = s:gsub('^[ ]*', '')
                dn = #s
            end
            if   n > 0
            then line = line .. ',' .. s
            else line = line .. s
            end
            n = n + dn
        end
        if n > 0 then insert(repr, line) end
        repr = table.concat(repr, os.LINESEP)
        insert(pdg_materials, format('    %s = {', v[1]))
        insert(pdg_materials, repr)
        insert(pdg_materials, tab .. '},' .. os.LINESEP)
    end

    insert(pdg_materials, '}')
    insert(pdg_materials, '')
    pdg_materials = table.concat(pdg_materials, os.LINESEP)

    local f = io.open(path, 'w')
    f:write(pdg_materials)
    f:close()
end


-------------------------------------------------------------------------------
-- Update the elements and materials data from the PDG website
-------------------------------------------------------------------------------
function Pdg.__index.update ()
    -- XXX locate the source location / get this from pumas?

    print('updating elements and materials PDG data. This might take \z
        several minutes ...')

    pdg.generate_elements('elements.lua', true)
    pdg.generate_materials('materials.lua', true)
end


-------------------------------------------------------------------------------
-- Register the subpackage
-------------------------------------------------------------------------------
function pdg.register_to (t)
    t.pdg = pdg
end

error.register('Pdg', Pdg)


-------------------------------------------------------------------------------
-- Return the package
-------------------------------------------------------------------------------
return pdg
