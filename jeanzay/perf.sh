#!/usr/bin/env bash
set -exu

RANK="${SLURM_PROCID}"

perf record -o "plogs/perf.${RANK}.data" -a -F 1000 ./build/src/phare/phare-exe harris_perf.py

