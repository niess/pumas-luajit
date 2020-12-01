-------------------------------------------------------------------------------
-- Generic error messages for the PUMAS wrapper
-- Author: Valentin Niess
-- License: GNU LGPL-3.0
-------------------------------------------------------------------------------

local error_ = {}


-------------------------------------------------------------------------------
-- Generic error messages formater
-------------------------------------------------------------------------------
function error_.raise (args)
    local msg = {}

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
            if type(args.argnum) == 'number' then
                table.insert(msg, 'bad argument #'..args.argnum)
            else
                table.insert(msg, 'bad number of argument(s)')
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

    local depth
    if args.depth == nil then
        depth = 2
    else
        depth = args.depth
    end

    error(msg, depth + 1)
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

        if args.depth ~= nil then
            args.depth = args.depth + 1
        else
            args.depth = 3
        end

        raise(args)
    end
end


-------------------------------------------------------------------------------
-- Return the package
-------------------------------------------------------------------------------
return error_
