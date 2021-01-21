-------------------------------------------------------------------------------
-- Runtime wrapper for LuaJIT-Pumas
-- Author: Valentin Niess
-- License: GNU LGPL-3.0
-------------------------------------------------------------------------------
local ffi = require('ffi')
local jit = require('jit')

local runtime = {}


-------------------------------------------------------------------------------
-- Catch seg faults
-------------------------------------------------------------------------------
ffi.cdef [[
typedef void (*sighandler_t)(int);
sighandler_t signal(int, sighandler_t);
]]

ffi.C.signal(11, function ()
    error('SIGSEGV', 2)
end)


-------------------------------------------------------------------------------
-- Put the JIT loader to the end and add a loader for embedded C packages
-------------------------------------------------------------------------------
package.loaders = (function ()
    local t = package.loaders
    return {
        t[2], t[3], t[4], t[1],
        function (modname)
            return loadcfunction('luaopen_'..modname:gsub('[.]', '_'))
        end
    }
end) ()

-- The lfs embedded C package can be loaded now
local lfs = require('lfs')


-------------------------------------------------------------------------------
-- Set the executable prefix
-------------------------------------------------------------------------------
local pathsep = (jit.os == 'Windows') and '\\' or '/'

local prefix = (function ()
    local exe = arg[0]

    if exe:match(pathsep) then
        local pwd = lfs.currentdir()
        local pattern = pathsep..'[^'..pathsep..']+$'
        local dirname = exe:gsub(pattern, '')
        if jit.os ~= 'Windows' then  dirname = dirname:gsub(pattern, '') end
        lfs.chdir(dirname)
        local prefix = lfs.currentdir()
        lfs.chdir(pwd)
        return prefix
    else
        return lfs.currentdir()
    end
end) ()

_PREFIX = prefix


-------------------------------------------------------------------------------
-- Use relative search paths for packages
-------------------------------------------------------------------------------
local function Path (...)
    return table.concat({...}, pathsep)
end


package.path = (function ()
    local path
    if jit.os == 'Windows' then
        -- XXX is this correct?
        path = Path(prefix, 'lua', '5.1', '')
    else
        path = Path(prefix, 'share', 'lua', '5.1', '')
    end

    local init = Path('?', 'init.lua')
    path = {'?.lua', init, path..'?.lua', path..init}
    return table.concat(path, ';')
end) ()


package.cpath = (function ()
    local cpath, tag
    if jit.os == 'Windows' then
        -- XXX is this correct?
        tag = '?.dll'
        cpath = Path(prefix, 'lua', '5.1', tag)
    else
        tag = '?.so'
        cpath = Path(prefix, 'lib', 'lua', '5.1', tag)
        if jit.os == 'OSX' then
            -- XXX are both .dylib and .so Lua packages supported on OSX?
            tag = '?.dylib;'..tag
            local tmp = Path(prefix, 'lib', 'lua', '5.1', '?.dylib')
            cpath = tmp..';'..cpath
        end
    end

    return table.concat({tag, cpath}, ';')
end) ()


-------------------------------------------------------------------------------
-- Banner for the REPL
-------------------------------------------------------------------------------
runtime.NOTICE = string.format(
    'LuaJIT Pumas (%s)  Copyright (C) 2020 UCA, CNRS/IN2P3, LPC',
    _RUNTIME_VERSION)


-------------------------------------------------------------------------------
-- The REPL
-------------------------------------------------------------------------------
function runtime.repl ()
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
        for _ = 1, index do table.remove(arg) end
        dofile(arg[0])
        if interactive ~= true then return end
    elseif interactive == false then
        return
    end

    local inspect = require('inspect')
    local linesep = jit.os == 'Windows' and '\r\n' or '\n'

    io.stdout:write(runtime.NOTICE)
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


-------------------------------------------------------------------------------
-- Return the package
-------------------------------------------------------------------------------
return runtime
