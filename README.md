# PUMAS-LuaJIT
_Bringing PUMAS to LuaJIT_

**This is Work In Progress ...**


## Installation

On Linux and OSX you can
[download](https://github.com/niess/pumas-luajit/releases/download/linux/pumas-luajit)
the pre-compiled `pumas-luajit` runtime published as a
[rolling release](https://github.com/niess/pumas-luajit/releases).
Note that you'd probably need to change the mode of the downloaded file to
`executable`, e.g. on Linux:
```bash
wget https://github.com/niess/pumas-luajit/releases/download/linux/pumas-luajit
chmod u+x pumas-luajit
```

Alternatively you can compile `pumas-luajit` from source by running the
provided Makefile as:
```bash
make install PREFIX=$(pwd) MACOSX_DEPLOYMENT_TARGET=10.7
```
The `MACOSX_DEPLOYMENT_TARGET` argument is not needed on Linux but must be
provided on OSX. In the latter case the deployment target version must be equal
or greater than 10.7.

Windows is not yet supported.
