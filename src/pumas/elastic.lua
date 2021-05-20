-------------------------------------------------------------------------------
-- Interface to the PUMAS elastic functions
-- Author: Valentin Niess
-- License: GNU LGPL-3.0
-------------------------------------------------------------------------------
local clib = require('pumas.clib')
local error = require('pumas.error')
local metatype = require('pumas.metatype')

-- XXX Allow Element or Material to be provided as target
local Elastic = {}

do
    local raise_error = error.ErrorFunction{['type'] = 'elastic'}

    function Elastic:__index (k)
        if type(k) ~= 'string' then
            raise_error{bad_key = true, expected = 'a string',
                got = metatype.a(k)}
        end

        local f = self._functions[k]
        if f then
            return f
        else
            local getter = function () return clib['pumas_elastic_'..k] end
            local ok
            ok, f = pcall(getter)
            if ok then
                self._functions[k] = f
                return f
            else
                raise_error{bad_member = k}
            end
        end
    end
end


do
    function Elastic.__newindex ()
        error.raise{['type'] = 'pumas', not_mutable = 'elastic'}
    end
end


-------------------------------------------------------------------------------
-- Return the package
-------------------------------------------------------------------------------
return setmetatable({_functions = {}}, Elastic)
