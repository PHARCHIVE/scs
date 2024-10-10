#!/usr/bin/env bash
## Script to configure and build phare with one thread

set -ex
set -o pipefail
shopt -s expand_aliases

alias glog="git log --pretty=oneline --abbrev-commit"
alias cls="clear; printf '\033[3J'"

module load gcc/12.2.0 cmake/3.21.3 python/3.11.5 hdf5/1.12.0-mpi openmpi/4.1.5

cd "$HOME"
[ ! -d "PHARE" ] && git clone https://github.com/PHAREHUB/PHARE --recursive

cd PHARE
[ ! -d ".venv" ] && python3 -m venv .venv
[ ! -f ".venv/bin/activate" ] && echo "error: venv not working as expected" && exit 1

# shellcheck disable=SC1091
. .venv/bin/activate
[ ! -f ".pip_installed" ] && python3 -m pip install -r requirements.txt && echo 1 >.pip_installed

export PYTHONPATH="${WORK}/build:${PWD}:${PWD}/pyphare"

cd "$WORK"

# write script if missing
[ ! -f "build.sh" ] && cat >build.sh <<EOL
mkdir -p build
cd build
CMAKE_CXX_FLAGS="-DNDEBUG -g0 -O3 -march=native -mtune=native" # -DPHARE_DIAG_DOUBLES=1
cmake ~/PHARE/ -DCMAKE_BUILD_TYPE=Release -DCMAKE_CXX_FLAGS="\${CMAKE_CXX_FLAGS}" -Dphare_configurator=ON
make
EOL
chmod +x build.sh
[ ! -d "build" ] && ./build.sh
