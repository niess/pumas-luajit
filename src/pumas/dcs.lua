-------------------------------------------------------------------------------
-- Interface to the PUMAS DCS library
-- Author: Valentin Niess
-- License: GNU LGPL-3.0
-------------------------------------------------------------------------------
local ffi = require('ffi')
local clib = require('pumas.clib')
local error = require('pumas.error')
local metatype = require('pumas.metatype')

local Dcs = {}


local function parse_tag (s, raise_error)
    local process_name, model = s:match('^([^ ]+)[ ]*([^ ]*)$')
    local process
    if process_name then
        if process_name == 'bremsstrahlung' then
            process = clib['PUMAS_PROCESS_BREMSSTRAHLUNG']
        elseif process_name == 'pair_production' then
            process = clib['PUMAS_PROCESS_PAIR_PRODUCTION']
        elseif process_name == 'photonuclear' then
            process = clib['PUMAS_PROCESS_PHOTONUCLEAR']
        else
            process_name = nil
        end
    end
    if process_name == nil then
        raise_error{argname = s, description = 'invalid process'}
    end
    if #model == 0 then
        model = nil
    end

    return process, model, process_name
end


do
    local raise_error = error.ErrorFunction{['type'] = 'dcs'}

    function Dcs:__index (k)
        if type(k) ~= 'string' then
            raise_error{bad_key=true, expected = 'a string',
                got = metatype.a(k)}
        end

        local f = self._lib[k]
        if f then
            return f
        else
            f = ffi.new('pumas_dcs_t * [1]')
            local process, model, process_name = parse_tag(k, raise_error)
            local rc = clib.pumas_dcs_get(process, model, f)
            if rc ~= clib.PUMAS_RETURN_SUCCESS then
                raise_error{bad_key=true, description = 'model '..model..
                    ' not found for '..process_name..' process'}
            else
                f = f[0]
                self._lib[k] = f
                return f
            end
        end
    end
end


do
    local raise_error = error.ErrorFunction{['type'] = 'dcs'}

    function Dcs:__newindex (k, v)
        if type(k) ~= 'string' then
            raise_error{bad_key=true, expected = 'a string',
                got = metatype.a(k)}
        end

        local process, model, process_name = parse_tag(k, raise_error)
        if model == nil then
            raise_error{bad_key = true,
                description = 'missing model name for '..process_name..
                ' process'}
        end

        if self._lib[k] then
            raise_error{bad_key = true, description = 'model '..model..
                ' already registered for '..process_name..' process'}
        else
            local function wrapped_f ()
                wrapped_f = ffi.cast('pumas_dcs_t *', v)
            end
            local ok, msg = pcall(wrapped_f)
            if not ok then
                raise_error{bad_value=true, description = msg}
            end

            local rc = clib.pumas_dcs_register(process, model, wrapped_f)
            if rc == clib.PUMAS_RETURN_MODEL_ERROR then
                raise_error{bad_key = true, description = 'model '..model..
                    ' already registered for '..process_name..' process'}
            elseif rc == clib.PUMAS_RETURN_MEMORY_ERROR then
                raise_error{bad_key = true,
                    description = 'max stack size reached'}
            else
                self._lib[k] = v
            end
        end
    end
end


-------------------------------------------------------------------------------
-- Return the package
-------------------------------------------------------------------------------
return setmetatable({_lib = {}}, Dcs)
