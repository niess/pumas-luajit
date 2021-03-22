#! /bin/bash

set -e

ROCK_VER=scm-1

HEREROCKS_DIR=$(pwd)/share/hererocks
LUAROCKS=${HEREROCKS_DIR}/bin/luarocks

if [[ ! -d ${HEREROCKS_DIR} ]]; then
    mkdir -p ${HEREROCKS_DIR}
    cd ${HEREROCKS_DIR}
    wget https://raw.githubusercontent.com/luarocks/hererocks/latest/hererocks.py
    chmod u+x hererocks.py
    ./hererocks.py -j latest -r latest .
    cd -

    ${LUAROCKS} install luacov
    ${LUAROCKS} install luacov-html
    ${LUAROCKS} install busted
fi

if [[ ! -d build-release ]]; then
    make install PREFIX=$(pwd)
    ${LUAROCKS} make dist/pumas-${ROCK_VER}.rockspec
fi

if [[ ! -d lib/lua ]]; then
    mkdir lib
    cd lib
    ln -s ${HEREROCKS_DIR}/lib/lua
    cd ..
fi

if [[ ! -d share/lua ]]; then
    cd share
    ln -s ${HEREROCKS_DIR}/share/lua
    cd ..
fi

if [[ ! -d docs/docs/coverage ]]; then
    ./bin/luajit-pumas spec/run.lua -c
fi
