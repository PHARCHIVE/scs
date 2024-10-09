#!/usr/bin/env bash
set -eu

RANK="${SLURM_PROCID}"

cd $HOME/PHARE
. .venv/bin/activate # pip installed stuff
export PYTHONPATH="${WORKDIR}/build:${PWD}:${PWD}/pyphare"

which python3 && python3 -V

cd $WORKDIR
# verify phare-exe is available
ldd build/src/phare/phare-exe

# perf needs python3.12 to work
# if you want perf files for all ranks, comment out the else block and the ifs
if [ "${RANK}" == "0" ]; then

    /usr/bin/perf record -o plog/perf.${RANK}.data --call-graph dwarf \
      --event instructions,cpu-cycles,cache-misses,branches --aio --sample-cpu -F 1000 \
      ./build/src/phare/phare-exe harris.py

else
    ./build/src/phare/phare-exe harris.py
fi
