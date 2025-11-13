#!/usr/bin/env bash

# some links if needed
# https://docs.idcs.mesocentre.ip-paris.fr/cholesky/slurm_job_management
# https://docs.idcs.mesocentre.ip-paris.fr/cholesky/slurm_queues_description/

## BEGIN SBATCH directives
#SBATCH --job-name=0000
#SBATCH --output=0000.txt
#
#SBATCH --ntasks=400
#SBATCH --nodes=10
#SBATCH --exclusive
#SBATCH --time=24:00:00
#SBATCH --partition=cpu_dist
#SBATCH --account=phare
#SBATCH --mail-type=ALL
#SBATCH --mail-user=you@email.lol
## END SBATCH directives

## load modules
set -ex

module load cmake gcc/13.2.0 openmpi hdf5 git/2.31.1

WORKDIR="/mnt/beegfs/workdir/$(whoami)" # not in env sometimes
cd "$WORKDIR/PHARE"
# shellcheck disable=SC1091
. .venv/bin/activate
export PYTHONPATH="${PWD}/build:${PWD}:${PWD}/pyphare"

PRELOAD="/mnt/beegfs/softs/opt/core/gcc/13.2.0/lib64/libstdc++.so"
export LD_PRELOAD="${PRELOAD}"

cd "$WORKDIR/tests/0000"
mpirun -n "$SLURM_NTASKS" python3 -O job.py
