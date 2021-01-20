-------------------------------------------------------------------------------
-- Earth geometry for PUMAS
-- Author: Valentin Niess
-- License: GNU LGPL-3.0
-------------------------------------------------------------------------------
local ffi = require('ffi')
local call = require('pumas.call')
local clib = require('pumas.clib')
local compat = require('pumas.compat')
local error = require('pumas.error')
local base = require('pumas.geometry.base')
local topography = require('pumas.geometry.topography')
local metatype = require('pumas.metatype')

local earth = {}


-------------------------------------------------------------------------------
-- The Earth geometry metatype
-------------------------------------------------------------------------------
local EarthGeometry = {}

local ctype = ffi.typeof('struct pumas_geometry_earth')
local ctype_ptr = ffi.typeof('struct pumas_geometry_earth *')
local pumas_geometry_ptr = ffi.typeof('struct pumas_geometry *')


local function new (self)
    local c = ffi.cast(ctype_ptr, ffi.C.calloc(1, ffi.sizeof(ctype)))

    c.base.get = clib.pumas_geometry_earth_get
    c.base.reset = clib.pumas_geometry_earth_reset
    c.base.destroy = clib.pumas_geometry_earth_destroy
    c.media = self._media
    c.n_layers = #self._layers

    call(clib.turtle_stepper_create, c.stepper)

    if self._geoid_undulations then
        local undulations
        if metatype(self._geoid_undulations) == 'TopographyData' then
            undulations = self._geoid_undulations
        else
            undulations = topography.TopographyData(self._geoid_undulations)
        end

        clib.turtle_stepper_geoid_set(c.stepper[0], undulations._c)
        rawset(self, '_undulations', undulations)
    end

    for i, layer in ipairs(self._layers) do
        local _, data = unpack(layer)

        if i > 1 then
            call(clib.turtle_stepper_add_layer, c.stepper[0])
        end

        for j = #data, 1, -1 do
            local datum = data[j]
            if type(datum._elevation) == 'number' then
                call(datum._stepper_add, c.stepper[0],
                        datum._elevation + datum.offset)
            else
                call(datum._stepper_add, c.stepper[0],
                        datum._c, datum.offset)
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
            f:write(require('pumas.data.igrf13'))
            f:close()
        else
            magnet = self._magnet
        end

        local errmsg = call.protected(
            ffi.C.gull_snapshot_create, c.magnet.snapshot, magnet,
            matches[1], matches[2], matches[3])
        if self._magnet == true then os.remove(magnet) end
        if errmsg then
            error.raise{
                fname = 'EarthGeometry.new',
                description = errmsg
            }
        end

        c.base.magnet = clib.pumas_geometry_earth_magnet
    else
        c.magnet.snapshot[0] = nil
    end

    return ffi.cast(pumas_geometry_ptr, c)
end


function EarthGeometry:__index (k)
    if k == 'magnet' then
        return self._magnet
    elseif k == 'date' then
        return self._date
    elseif k == '_new' then
        return new
    else
        return base.BaseGeometry.__index[k]
    end
end


function EarthGeometry:__newindex (k, v)
    if (k == 'magnet') or (k == 'date') or (k == 'geoid_undulations') then
        local key = '_'..k
        if v == rawget(self, key) then return end

        local mt, expected = metatype(v)
        if k == 'date' then
            if (mt ~= 'string') and (mt ~= 'nil') then
                expected = 'a string or nil'
            end
        elseif k == 'magnet' then
            if (mt ~= 'string') and (mt ~= 'nil') and (mt ~= 'boolean') then
                expected = 'a boolean, a string or nil'
            end
        else
            if (mt ~= 'string') and (mt ~= 'nil') and
                (mt ~= 'TopographyData') then
                expected = 'a TopographyData table, a string or nil'
            end
        end

        if expected then
            error.raise{
                fname = k,
                expected = expected,
                got = metatype.a(v)
            }
        end

        if k == 'geoid_undulations' then
            if (mt == 'TopographyData') and
                not ffi.istype('struct turtle_map *', v._c) then
                error.raise{
                    fname = k,
                    description = 'invalid TopographyData format'
                }
            end

            rawset(self, '_undulations', nil)
        end

        rawset(self, key, v)
        self:_invalidate()
    else
        error.raise{
            ['type'] = 'EarthGeometry',
            bad_member = k
        }
    end
end


-------------------------------------------------------------------------------
-- The Earth geometry constructor
-------------------------------------------------------------------------------
do
    local raise_error = error.ErrorFunction{fname = 'EarthGeometry'}

    local function new_ (cls, ...)
        local nargs = select('#', ...)
        if nargs == 0 then
            raise_error{argnum = 'bad', expected = '1 or more', got = 0}
        end

        local layers = compat.table_new(nargs, 0)
        local ilayer = 0
        local magnet, date, geoid_undulations

        local function add(args, index)
            for i, arg in ipairs(args) do
                if arg.magnet then magnet = arg.magnet end
                if arg.date then date = arg.date end
                if arg.geoid_undulations then
                    geoid_undulations = arg.geoid_undulations
                end

                local medium, data = arg.medium, arg.data
                if (not medium) and (not data) and type(arg) == 'table' then
                    add(arg, index or i)
                else
                    if (metatype(medium) ~= 'Medium') and (medium ~= nil) then
                        raise_error{argnum = (index or i)..' (medium)',
                            expected = 'a Medium table or nil',
                            got = metatype.a(medium)}
                    end

                    if not data then
                        raise_error{argnum = (index or i)..' (data)',
                            expected = 'a TopographyData(Set) table',
                            got = metatype.a(data)}
                    end

                    local mt = metatype(data)
                    if (mt ~= 'table') and (mt ~= 'TopographyDataSet') then
                        data = {data}
                    end

                    for j, datum in ipairs(data) do
                        local mt_ = metatype(datum)
                        if (mt_ == 'string') or (mt_ == 'number') then
                            data[j] = topography.TopographyData(datum)
                        elseif mt_ ~= 'TopographyData' then
                            raise_error{argnum = (index or i)..' (data)',
                                expected = 'a TopographyData table, a number \z
                                    or a string', got = metatype.a(data)}
                        end
                    end

                    ilayer = ilayer + 1
                    layers[ilayer] = {medium, data}
                end
            end
        end

        add{...}

        -- Revert the order of layers such that the first entry is the top
        -- layer
        do
            local tmp = compat.table_new(#layers, 0)
            for i, v in ipairs(layers) do
                tmp[#layers - i + 1] = v
            end
            layers = tmp
        end

        -- XXX Provide elevation and frame methods?

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

        local self = base.BaseGeometry:new()
        self._media = media
        self._layers = layers

        self = setmetatable(self, cls)
        self.magnet = magnet
        self.date = date
        self.geoid_undulations = geoid_undulations

        return self
    end

    earth.EarthGeometry = setmetatable(EarthGeometry, {__call = new_})
end


-------------------------------------------------------------------------------
-- Return the package
-------------------------------------------------------------------------------
return earth
