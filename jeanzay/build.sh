#!/usr/bin/env bash

set -exu

#module load gcc/12.2.0 python/3.11.5 openmpi/4.1.5 hdf5/1.12.0-mpi-cuda
module load gcc/12.2.0 cmake/3.21.3 python/3.11.5 openmpi/4.1.5 hdf5/1.12.0-mpi
#module load gcc/12.2.0 cmake/3.21.3 python/3.11.5 hdf5/1.12.0-mpi openmpi/4.1.5

free -g
lscpu

echo "$HDF5_ROOT"
ls -l "$HDF5_ROOT/lib"

cd "$HOME/PHARE"
# shellcheck disable=SC1091
. .venv/bin/activate
export PYTHONPATH="${WORK}/build:${PWD}:${PWD}/pyphare"
cd "$WORK"
mkdir -p build
cd build

#CMAKE_CXX_FLAGS="-DNDEBUG -g0 -O3 -march=native -mtune=native -DPHARE_LOG_LEVEL=1 "
CMAKE_CXX_FLAGS="-g3 -O3 -march=cascadelake -fno-omit-frame-pointer"

echo "LD_LIBRARY_PATH=$LD_LIBRARY_PATH"

(
  cmake ~/PHARE/ -DCMAKE_BUILD_TYPE=RelWithDebInfo -DCMAKE_CXX_FLAGS="${CMAKE_CXX_FLAGS}" \
    -Dphare_configurator=ON -DwithPhlop=OFF -Dtest=OFF
  make VERBOSE=1 -j10

) 1> >(tee "$WORK/.build.sh.out") 2> >(tee "$WORK/.build.sh.err" >&2)
