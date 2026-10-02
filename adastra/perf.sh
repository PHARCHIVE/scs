#!/usr/bin/env bash

set -eu

RANK="${SLURM_PROCID}"
echo "PYTHONPATH=$PYTHONPATH"
cd "$WORKDIR"
module load cray-python/3.11.5 gcc-native/12.1 cray-hdf5-parallel
/usr/bin/perf record -o "plog/perf.${RANK}.data" --call-graph dwarf --event instructions,cpu-cycles,cache-misses,branches --aio --sample-cpu -F 1000 ./build/src/phare/phare-exe harris.py
