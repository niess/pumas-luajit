# PUMAS-LuaJIT
_A LuaJIT wrapper for the PUMAS Monte Carlo engine_

**This is Work In Progress**

The `pumas` LuaJIT package allows to use the
[PUMAS](https://niess.github.io/pumas-pages/) C Monte Carlo engine from a high
level language: [Lua](http://www.lua.org/). Native performances are achieved
thanks to the excellent Just-In-Time compiler of [LuaJIT](https://luajit.org/).

## Installation

> Installation on Windows is not yet supported but might be considered in the
> future. Meanwhile one might use
> [Windows Subsystem for Linux](https://docs.microsoft.com/en-gb/windows/wsl/)
> instead.

The `luajit` executable and the `pumas` package are available as a single
runtime: `pumas-luajit`. This runtime can be
[downloaded](https://github.com/niess/pumas-luajit/releases/download/linux/pumas-luajit)
as a [rolling release](https://github.com/niess/pumas-luajit/releases).  Note
that you need to change the mode of the downloaded file to executable, e.g. as:
```bash
wget https://github.com/niess/pumas-luajit/releases/download/linux/luajit-pumas
chmod u+x luajit-pumas
```

The `luajit-pumas` runtime can also be compiled from source by running
the provided Makefile as:
```bash
make install PREFIX=$(pwd) MACOSX_DEPLOYMENT_TARGET=10.7
```
The `MACOSX_DEPLOYMENT_TARGET` argument is not needed on Linux but must be
provided on OSX. In the latter case the deployment target version must be equal
or greater than 10.7.

For Lua users, the `pumas` package is also available independently as a binary
[rock](http://rajatorrent.com.luarocks.org/modules/niess/pumas). It can be used
with alternative LuaJIT runtimes e.g. the [LÖVE](https://love2d.org/) game
engine.

## Documentation

A **preliminary** documentation is available as
[GitHub Pages](https://niess.github.io/pumas-luajit/). You might also try the
provided [examples](examples), e.g as:
```bash
luajit-pumas examples/materials.lua
```

## License
The `pumas` LuaJIT package is  under the **GNU LGPLv3** license. See the
provided [LICENSE](LICENSE) and [COPYING.LESSER](COPYING.LESSER) files. The
[examples](examples) however have a separate public domain license and can be be
copied without any restriction.
