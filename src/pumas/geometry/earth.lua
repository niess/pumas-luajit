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
local readonly = require('pumas.readonly')
local layer_ = require('pumas.geometry.layer')
local topography = require('pumas.geometry.topography')
local uniform = require('pumas.medium.uniform')
local metatype = require('pumas.metatype')

local earth = {}


-- XXX Add a geoid metatype / interface ?


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
    local layers = readonly.rawget(self.layers)
    c.n_layers = #layers

    call(clib.turtle_stepper_create, c.stepper)

    if self._geoid_undulations then
        clib.turtle_stepper_geoid_set(c.stepper[0], self._geoid_undulations._c)
    end

    for i = #layers, 1, -1 do
        local data = layers[i].data

        if i < #layers then
            call(clib.turtle_stepper_add_layer, c.stepper[0])
        end

        for j = #data, 1, -1 do
            local datum = data[j]
            if datum._elevation then
                call(datum._stepper_add, c.stepper[0], datum._c, datum.offset)
            else
                call(datum._stepper_add, c.stepper[0], datum.offset)
            end
        end
    end

    c.magnet.workspace[0] = nil
    if self._magnet then
        local date = self._date or '01/01/2021'
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
    if k == 'date' then
        return self._date
    elseif k == 'geoid_undulations' then
        return self._geoid_undulations
    elseif k == 'magnet' then
        return self._magnet
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
            local undulations
            if metatype(v) == 'TopographyData' then
                undulations = v
            else
                undulations = topography.TopographyData(v)
            end

            if not ffi.istype('struct turtle_map *', undulations._c) then
                error.raise{
                    fname = k,
                    description = 'invalid TopographyData format'
                }
            end
            v = undulations
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

        local self = base.BaseGeometry:new()
        local layers = compat.table_new(nargs, 0)
        local ilayer = 0
        local magnet, date, geoid_undulations

        local function add(args, index)
            for i, arg in ipairs(args) do
                if metatype(arg) == 'table' then
                    if arg.magnet then magnet = arg.magnet end
                    if arg.date then date = arg.date end
                    if arg.geoid_undulations then
                        geoid_undulations = arg.geoid_undulations
                    end
                end

                local medium, data = arg.medium, arg.data
                if (not medium) and (not data) and type(arg) == 'table' then
                    add(arg, index or i)
                else
                    do
                        local mt = metatype(medium)
                        if mt == 'string' then
                            medium = uniform.UniformMedium(medium)
                        elseif (mt ~= 'Medium') and (mt ~= 'nil') then
                            raise_error{argnum = (index or i)..' (medium)',
                                expected = 'a Medium table or nil',
                                got = metatype.a(medium)}
                        end
                    end

                    if not data then
                        raise_error{argnum = (index or i)..' (data)',
                            expected = 'a TopographyData(set) table',
                            got = metatype.a(data)}
                    end

                    local mt = metatype(data)
                    if (mt ~= 'table') and (mt ~= 'TopographyDataset') then
                        data = {data}
                    end

                    if mt == 'TopographyDataset' then
                        data = data:clone()
                    else
                        for j, datum in ipairs(data) do
                            local mt_ = metatype(datum)
                            if (mt_ == 'string') or (mt_ == 'number') then
                                data[j] = topography.TopographyData(datum)
                            elseif mt_ ~= 'TopographyData' then
                                raise_error{argnum = (index or i)..' (data)',
                                    expected = 'a TopographyData table, \z
                                        a number or a string',
                                        got = metatype.a(data)}
                            end
                        end
                        data = topography.TopographyDataset(data)
                    end

                    for _, datum in data:ipairs() do
                        rawset(datum, '_geometry', self)
                    end

                    ilayer = ilayer + 1
                    layers[ilayer] = layer_.TopographyLayer(medium, data)
                end
            end
        end

        add{...}

        -- XXX Provide elevation and frame methods?

        local pumas_medium_ptr = ffi.typeof('struct pumas_medium *')
        local pumas_medium_ptrarr = ffi.typeof('struct pumas_medium **')
        local size = ffi.sizeof(pumas_medium_ptr)
        local media = ffi.cast(pumas_medium_ptrarr, ffi.C.calloc(#layers, size))
        ffi.gc(media, ffi.C.free)
        for i, layer in ipairs(layers) do
            if layer.medium ~= nil then
                media[#layers - i] = ffi.cast(pumas_medium_ptr, layer.medium._c)
            end
        end

        self._media = media
        self.layers = readonly.Readonly(layers)

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
