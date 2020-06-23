#! /bin/bash

SCRIPT=$(cat <<-END
  cd /pwd
  trap "chown -fR $(id -u):$(id -g) bin build-release src/pumas/*.so" EXIT
  make install PREFIX=\$(pwd)
END
)

docker run --mount type=bind,source=$(pwd),target=/pwd                         \
           quay.io/pypa/manylinux2014_x86_64 /bin/bash -c "${SCRIPT}"
