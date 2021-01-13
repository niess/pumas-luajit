-------------------------------------------------------------------------------
-- Base transport medium for PUMAS
-- Author: Valentin Niess
-- License: GNU LGPL-3.0
-------------------------------------------------------------------------------
local ffi = require('ffi')
local clib = require('pumas.clib')
local error = require('pumas.error')

local base = {}


-------------------------------------------------------------------------------
-- Cross utilities between C media and their Lua wrappers
-------------------------------------------------------------------------------
do
    local function addressof (ptr)
        return tonumber(ffi.cast('uintptr_t', ptr))
    end

    local media_table = setmetatable({}, {__mode = 'v'})

    function base.get (c_medium)
        return media_table[addressof(c_medium)]
    end

    function base.add (medium)
        media_table[addressof(medium._c)] = medium
    end

    local last_version
    local index = ffi.new('int [1]')

    function base.update (physics)
        if last_version == physics._version then
            return true
        end

        for _, medium in pairs(media_table) do
            if medium.material and (medium.material ~= 'Transparent') then
                local rc = clib.pumas_physics_material_index(physics._c[0],
                    medium.material, index)
                if rc ~= clib.PUMAS_RETURN_SUCCESS then
                    return false, medium
                else
                    local m = ffi.cast('struct pumas_medium *', medium._c)
                    m.material = index[0]
                end
            end
        end
        last_version = physics._version

        return true
    end
end


-------------------------------------------------------------------------------
-- The base medium
--
-- Note: this is an incomplete metatype intended to be inherited. It provides
-- common functionalities for media types.
-------------------------------------------------------------------------------
local BaseMedium = {}
base.BaseMedium = BaseMedium


function BaseMedium.__index (_, k, strtype)
    if k == '__metatype' then
        return 'Medium'
    else
        error.raise{['type'] = strtype, bad_member = k}
    end
end


function BaseMedium:__newindex (k, v, strtype)
    if k == 'material' then
        rawset(self, 'material', v)
    else
        error.raise{['type'] = strtype, bad_member = k}
    end
end


function BaseMedium.new (ctype, ctype_ptr, material)
    local c = ffi.cast(ctype_ptr, ffi.C.calloc(1, ffi.sizeof(ctype)))
    ffi.gc(c, ffi.C.free)

    local obj = {_c = c, material = material}
    base.add(obj)

    return obj
end


-------------------------------------------------------------------------------
-- Return the package
-------------------------------------------------------------------------------
return base
