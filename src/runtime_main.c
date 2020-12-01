/* C89 standard library */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
/* Lua library */
#include <lauxlib.h>
#include <lua.h>
#include <lualib.h>
/* For symbol resolution */
#ifdef _WIN32
#include <windows.h>
#else
#include <dlfcn.h>
#endif


#ifndef RUNTIME_VERSION
#define RUNTIME_VERSION "undefined"
#endif


static int l_loadcfunction(lua_State * L)
{
        const char * name = lua_tostring(L, -1);
        if (name == NULL) return 0;

        void * f;
#if defined(_WIN32)
        f = GetProcAddress(GetModuleHandleA(NULL), name);
#elif defined(__APPLE__)
        f = dlsym(RTLD_SELF, name);
#else
        f = dlsym(NULL, name);
#endif
        if (f == NULL) return 0;

        lua_pushcfunction(L, f);
        return 1;
}


static int l_perror(lua_State * L)
{
        /* Ensure that the error message is a string */
        lua_getglobal(L, "tostring");
        lua_insert(L, -2);
        lua_call(L, 1, 1);

        /* Call the traceback */
        lua_getglobal(L, "debug");
        lua_getfield(L, -1, "traceback");
        lua_remove(L, -2);
        lua_insert(L, -2);
        lua_pushnumber(L, 3);
        lua_call(L, 2, 1);

        /* Dump the result to stderr */
        const char * msg = lua_tostring(L, -1);
        fputs(msg, stderr);
        fputs("\n", stderr);

        /* The error message is returned as well */
        return 1;
}


static int execute(lua_State * L, const char * command)
{
        lua_pushcfunction(L, &l_perror);
        luaL_loadbuffer(L, command, strlen(command), "=stdin");
        return lua_pcall(L, 0, LUA_MULTRET, 1);
}


int main(int argc, char * argv[])
{
        /* Initialise Lua */
        struct lua_State * L = luaL_newstate();
        luaL_openlibs(L);

        /* Export the C function loader and the error messenger to Lua */
        lua_pushcfunction(L, l_loadcfunction);
        lua_setglobal(L, "loadcfunction");

        lua_pushcfunction(L, l_perror);
        lua_setglobal(L, "perror");

        /* Forward the arguments */
        lua_createtable(L, argc, 0);
        int i;
        for (i = 0; i < argc; i++) {
                lua_pushstring(L, argv[i]);
                lua_rawseti(L, -2, i);
        }
        lua_setglobal(L, "arg");

        /* Export the version tag */
        lua_pushstring(L, RUNTIME_VERSION);
        lua_setglobal(L, "_RUNTIME_VERSION");

        /* Load the runtime patcher, look for pre-loaded packages and start
         * the REPL
         */
        const int rc = execute(L, "                                            \
            local runtime = require('runtime')                                 \
            runtime.__preload__()                                              \
            pumas = require('pumas')                                           \
            local repl = require('runtime.repl')                               \
            repl.__main__()                                                    \
        ");

        lua_close(L);
        exit(rc);
}
