# PUMAS-LuaJIT
_Bringing PUMAS to LuaJIT_

**This is Work In Progress ...**


## Installation

On Linux you can [download](https://github.com/niess/pumas-luajit/releases/download/linux/pumas-luajit)
the pre-compiled `pumas-luajit` runtime published as a [rolling release](https://github.com/niess/pumas-luajit/releases).
Note that you'd probably need to change the mode of the downloaded file to
`executable`, e.g. as:
```bash
wget https://github.com/niess/pumas-luajit/releases/download/linux/pumas-luajit
chmod u+x pumas-luajit
```

On OSX you might be successful in running the Makefile, as:
```bash
make install PREFIX=$(pwd)
```

Windows is not yet supported.