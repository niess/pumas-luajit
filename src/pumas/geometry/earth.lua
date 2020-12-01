-------------------------------------------------------------------------------
-- Earth geometry for PUMAS
-- Author: Valentin Niess
-- License: GNU LGPL-3.0
-------------------------------------------------------------------------------
local ffi = require('ffi')
local call = require('pumas.call')
local error = require('pumas.error')
local base = require('pumas.geometry.base')
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

    c.base.get = ffi.C.pumas_geometry_earth_get
    c.base.reset = ffi.C.pumas_geometry_earth_reset
    c.base.destroy = ffi.C.pumas_geometry_earth_destroy
    c.media = self._media
    c.n_layers = #self._layers

    call(ffi.C.turtle_stepper_create, c.stepper)
    for i, layer in ipairs(self._layers) do
        local _, data, offset = unpack(layer)

        if i > 1 then
            call(ffi.C.turtle_stepper_add_layer, c.stepper[0])
        end

        for j = #data, 1, -1 do
            local datum = data[j]
            if type(datum._elevation) == 'number' then
                call(datum._stepper_add, c.stepper[0],
                        datum._elevation + offset)
            else
                call(datum._stepper_add, c.stepper[0],
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

        c.base.magnet = ffi.C.pumas_geometry_earth_magnet
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
    if (k == 'magnet') or (k == 'date') then
        local key = '_'..k
        if v == rawget(self, key) then return end

        local tp = type(v)
        if (tp ~= 'string') and (tp ~= 'nil') and (tp ~= 'boolean') then
            error.raise{
                fname = k,
                expected = 'a string',
                got = metatype.a(v)
            }
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
function earth.EarthGeometry (...)
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

    local self = base.BaseGeometry:new()
    self._media = media
    self._layers = layers

    return setmetatable(self, EarthGeometry)
end


-------------------------------------------------------------------------------
-- Return the package
-------------------------------------------------------------------------------
return earth
