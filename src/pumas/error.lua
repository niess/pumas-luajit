-------------------------------------------------------------------------------
-- Generic error messages for the PUMAS wrapper
-- Author: Valentin Niess
-- License: GNU LGPL-3.0
-------------------------------------------------------------------------------

local error_ = {}


-------------------------------------------------------------------------------
-- Table of API functions
--
-- This table keeps weak references of all pumas API functions. It is used for
-- computing the stack depth when raising an error.
-------------------------------------------------------------------------------
local api_functions = setmetatable({}, {__mode='k'})
error_.api_functions = api_functions


-------------------------------------------------------------------------------
-- Register an API function or metatable
-------------------------------------------------------------------------------
do
    local function register_meta (k, v, index)
        v = v[index]
        if v then
            k = k..'.'..index

            if type(v) == 'function' then
                api_functions[v] = k
            elseif type(v) == 'table' then
                for ki, vi in pairs(v) do
                    if type(vi) == 'function' then
                        api_functions[vi] = k..'.'..ki
                    end
                end
                local mt = getmetatable(v)
                if mt and mt[index] then
                    api_functions[mt[index]] = k
                end
            end
        end
    end

    function error_.register (k, v)
        if type(v) == 'function' then
            api_functions[v] = k
        elseif type(v) == 'table' then
            local mt = getmetatable(v)
            if mt and mt.__call then
                api_functions[mt.__call] = k..'.__call'
            end

            if rawget(v, '__index') then
                register_meta(k, v, '__index')
            end

            if rawget(v, '__newindex') then
                register_meta(k, v, '__newindex')
            end
        end
    end
end


-------------------------------------------------------------------------------
-- Generic error messages formater
-------------------------------------------------------------------------------
function error_.raise (args)
    local msg
    if type(args) == 'string' then
        msg = args
    else
        -- Format the error message
        msg = {}

        if args.header ~= nil then
            table.insert(msg, args.header)
        elseif args.type ~= nil then
            if args.bad_member ~= nil then
                table.insert(msg, "'"..args.type.."' has no member named '"..
                                  args.bad_member.."'")
            elseif args.not_mutable ~= nil then
                table.insert(msg, "cannot modify '"..args.not_mutable..
                                  " for '"..args.type.."'")
            else
                table.insert(msg, "an unknown error occured related to '"..
                                  args.type.."'")
            end
        else
            if args.argnum ~= nil then
                if args.argnum == 'bad' then
                    table.insert(msg, 'bad number of argument(s)')
                else
                    table.insert(msg, 'bad argument #'..args.argnum)
                end
            elseif args.argname ~= nil then
                table.insert(msg, "bad argument '"..args.argname.."'")
            else
                table.insert(msg, "bad argument(s)")
            end

            if args.fname ~= nil then
                table.insert(msg, "to '"..args.fname.."'")
            end
        end

        local description = {}
        if args.description ~= nil then
            table.insert(description, args.description)
        else
            if args.expected ~= nil then
                table.insert(description, 'expected '..args.expected)
            end
            if args.got ~= nil then
                table.insert(description, 'got '..args.got)
            end
        end

        if #description > 0 then
            description = table.concat(description, ', ')
            table.insert(msg, '('..description..')')
        end
        msg = table.concat(msg, ' ')
    end

    -- Compute the depth
    local depth = 1
    do
        local level = 1
        while true do
            local info = debug.getinfo(level, 'Sf')
            if not info or (info.what == 'main') then break end
            level = level + 1
            if info.what == 'Lua' then
                if api_functions[info.func] then
                    depth = level
                end
            end
        end
    end

    error(msg, depth)
end


-------------------------------------------------------------------------------
-- Generate an error function with default format parameters
-------------------------------------------------------------------------------
function error_.ErrorFunction (default_args)
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

        error_.raise(args)
    end
end


-------------------------------------------------------------------------------
-- Return the package
-------------------------------------------------------------------------------
return error_
