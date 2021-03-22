#! /bin/bash

API_KEY=${1}

set -e

ARCH=linux-x86_64
ROCK_VER=scm-1

HEREROCKS_DIR=share/hererocks
LUAROCKS=${HEREROCKS_DIR}/bin/luarocks
MOONROCKS=${HEREROCKS_DIR}/bin/moonrocks

if [[ ! -d ${HEREROCKS_DIR} ]]; then
    mkdir -p ${HEREROCKS_DIR}
    cd ${HEREROCKS_DIR}
    wget https://raw.githubusercontent.com/luarocks/hererocks/latest/hererocks.py
    chmod u+x hererocks.py
    ./hererocks.py -j latest -r latest .
    cd -

    ${LUAROCKS} install lua-cjson
    ${LUAROCKS} install moonrocks
fi

if [ ! -z "${API_KEY}" ]; then
    mkdir -p ~/.moonrocks
    cat <<EOT > ~/.moonrocks/config.lua
{
  key = '${API_KEY}'
}
EOT
fi

${LUAROCKS} make dist/pumas-${ROCK_VER}.rockspec

${LUAROCKS} install busted
mkdir lib
cd lib
ln -s ../${HEREROCKS_DIR}/lib/lua
cd ..
cd share
ln -s ../${HEREROCKS_DIR}/share/lua
cd ..
./bin/luajit-pumas spec/run.lua

${LUAROCKS} pack pumas
${MOONROCKS} upload pumas-${ROCK_VER}.${ARCH}.rock
