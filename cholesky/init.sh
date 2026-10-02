#!/usr/bin/env bash
## Script to configure and build phare with one thread

set -ex
set -o pipefail

CWD="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)" && cd "$CWD"
WORKDIR="/mnt/beegfs/workdir/$(whoami)" # not in env sometimes

module load cmake gcc/13.2.0 openmpi hdf5 git/2.31.1

# needed during pip install for some reason
export CC=/mnt/beegfs/softs/opt/core/gcc/13.2.0/bin/gcc
export CXX=/mnt/beegfs/softs/opt/core/gcc/13.2.0/bin/g++

cd "$WORKDIR"
[ ! -d "PHARE" ] && git clone https://github.com/PhilipDeegan/PHARE -b 3d_new --recursive --depth 10 --shallow-submodules

cd PHARE
[ ! -d ".venv" ] && /mnt/beegfs/softs/opt/core/python-envs/lspython/bin/python3 -m venv .venv
[ ! -f ".venv/bin/activate" ] && echo "error: venv not working as expected" && exit 1

# shellcheck disable=SC1091
. .venv/bin/activate
[ ! -f ".pip_installed" ] && python3 -m pip install -r requirements.txt && echo 1 >.pip_installed

export PYTHONPATH="${PWD}/build:${PWD}:${PWD}/pyphare"

cd ..

# write script if missing
[ ! -f "build.sh" ] && cat >build.sh <<EOL
cd PHARE
mkdir -p build
cd build
CMAKE_CXX_FLAGS="-DNDEBUG -g0 -O3 -march=native -mtune=native  -DPHARE_DIAG_DOUBLES=1"
cmake .. -Dtest=OFF -DCMAKE_BUILD_TYPE=Release -DCMAKE_CXX_FLAGS="\${CMAKE_CXX_FLAGS}"
make -j 10
EOL
chmod +x build.sh

# shellcheck disable=SC2015
[ ! -d "build" ] && ./build.sh || true
