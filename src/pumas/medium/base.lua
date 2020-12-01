-------------------------------------------------------------------------------
-- Base transport medium for PUMAS
-- Author: Valentin Niess
-- License: GNU LGPL-3.0
-------------------------------------------------------------------------------
local ffi = require('ffi')
local call = require('pumas.call')
local error = require('pumas.error')
local metatype = require('pumas.metatype')

local base = {}


-------------------------------------------------------------------------------
-- Mapping between C media and their Lua wrappers
-------------------------------------------------------------------------------
do
    local function addressof (ptr)
        return tonumber(ffi.cast('uintptr_t', ptr))
    end

    local media_table = {}

    function base.get (c_medium)
        return media_table[addressof(c_medium)]
    end

    function base.add (medium)
        media_table[addressof(medium._c)] = medium
    end
end


-------------------------------------------------------------------------------
-- The base medium
--
-- Note: this is an incomplete metatype intended to be inherited. It provides
-- common functionalities for media types.
-------------------------------------------------------------------------------
-- XXX Set materials from 'Material' object or string ref. MATERIALS
local BaseMedium = {}
base.BaseMedium = BaseMedium

local ctype = ffi.typeof('struct pumas_medium')


function BaseMedium:__index (k, strtype)
    if k == '__metatype' then
        return 'medium'
    elseif k == 'material' then
        return self._material
    else
        error.raise{
            ['type'] = strtype,
            bad_member = k,
            depth = 3
        }
    end
end


local function parse_material (v, strtype)
    local raise_error = error.ErrorFunction{
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
        call(ffi.C.pumas_material_index, v, index)
        return index[0]
    elseif type(v) == 'number' then
        if (n == 1) and (v ~= 0) then
            raise_error{
                expected = 0,
                got  = v
            }
        elseif (v < 0) or (v >= n) then
            raise_error{
                expected = 'a value between 0 and '..tostring(n - 1),
                got  = v
            }
        end
        return v
    else
        raise_error{
            expected = 'a number or a string',
            got = metatype.a(v)
        }
    end
end


function BaseMedium:__newindex (k, v, strtype)
    if k == 'material' then
        self._c.medium.material = parse_material(v, strtype)
        rawset(self, '_material', v)
    else
        error.raise{
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
    base.add(obj)

    local index = parse_material(material, strtype)
    return obj, index
end


-------------------------------------------------------------------------------
-- Return the package
-------------------------------------------------------------------------------
return base
