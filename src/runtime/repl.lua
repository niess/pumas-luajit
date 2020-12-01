local repl = {}


repl.NOTICE = string.format(
    'LuaJIT+Pumas (%s)  Copyright (C) 2020 UCA, CNRS/IN2P3, LPC',
    _RUNTIME_VERSION)


-- Set the main program
function repl.__main__()
    local interactive
    local index = 1
    while index <= #arg do
        local optstr = arg[index]
        if #optstr == 1 or string.match(optstr, '^[^-]') then
            break
        end
        index = index + 1

        local opt = optstr:sub(2, 2)
        if opt == 'i' then
            interactive = true
        elseif opt == '-' then
            break
        else
            local optarg
            if #optstr == 2 then
                optarg = arg[index]
                index = index + 1
            else
                optarg = optstr:sub(3)
            end

            if opt == 'e' then
                local chunk, err = loadstring(optarg)
                if err then error(err, 2) end
                chunk()
                if interactive ~= true then
                    interactive = false
                end
            elseif opt == 'l' then
                require(optarg)
            else
                error('invalid option -'..opt, 2)
            end
        end
    end

    if arg[index] ~= nil then
        for i = 0, #arg do arg[i - index] = arg[i] end
        for i = 1, index do table.remove(arg) end
        dofile(arg[0])
        if interactive ~= true then return end
    elseif interactive == false then
        return
    end

    local inspect = require('inspect')
    local jit = require('jit')
    local ffi = require('ffi')

    local linesep = jit.os == 'Windows' and '\r\n' or '\n'

    io.stdout:write(repl.NOTICE)
    io.stdout:write(linesep)

    local prompt, read_command = '>> '
    local has_readline, lib = pcall(ffi.load, 'readline')
    if has_readline then
        ffi.cdef [[
            const char * rl_readline_name;
            char * readline(const char *);
            void add_history(const char *);
            void free(void *);
        ]]

        lib.rl_readline_name = 'pumas'

        read_command = function ()
            local line = lib.readline(prompt)
            if line == nil then return end
            if line[0] ~= 0 then lib.add_history(line) end
            local command = ffi.string(line)
            ffi.C.free(line)
            return command
        end
    else
        read_command = function ()
            io.stdout:write(prompt)
            return io.stdin:read()
        end
    end

    local options = {indent = "", newline = " "}

    while true do
        local command = read_command()
        if not command then break end

        if command:find('^!') then
            os.execute(command:sub(2))
        else
            -- XXX nil should show as "nil"
            local f, result, ok
            f, result = loadstring('return '..command, '=stdin')
            if result ~= nil then f, result = loadstring(command, '=stdin') end
            if result == nil then ok, result = pcall(f) end
            if result ~= nil then
                io.stdout:write(inspect(result, options))
                io.stdout:write(linesep)
            end
        end
    end
    io.stdout:write(linesep)
end


return repl
