#!/usr/bin/env bash

# some links if needed
# https://docs.idcs.mesocentre.ip-paris.fr/cholesky/slurm_job_management
# https://docs.idcs.mesocentre.ip-paris.fr/cholesky/slurm_queues_description/

## BEGIN SBATCH directives
#SBATCH --job-name=run052a
#SBATCH --output=run052a.txt
#
#SBATCH --ntasks=40
#SBATCH --nodes=1
#SBATCH --time=10:00:00
#SBATCH --partition=cpu_shared
#SBATCH --account=phare
#SBATCH --mail-type=ALL
#SBATCH --mail-user=your@lpp.polytechnique.fr
## END SBATCH directives

set -ex
set -o pipefail

module load cmake gcc/13.2.0 openmpi hdf5

cd "$HOME/PHARE"
# shellcheck disable=SC1091
. .venv/bin/activate
export PYTHONPATH="${PWD}/build:${PWD}:${PWD}/pyphare"

PRELOAD="/mnt/beegfs/softs/opt/core/gcc/13.2.0/lib64/libstdc++.so"
export LD_PRELOAD="${PRELOAD}"
mpirun -n "$SLURM_NTASKS" python3 -O harris.py
