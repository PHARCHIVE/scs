#!/usr/bin/env bash

## BEGIN SBATCH directives
#SBATCH --job-name=run051c
#SBATCH --output=run051c.txt
#SBATCH --ntasks=80
#SBATCH --ntasks-per-node=40
#SBATCH --hint=nomultithread
#SBATCH --time=20:00:00
#SBATCH --partition=cpu_p1
#SBATCH --account=wrb@cpu
#SBATCH --mail-type=ALL
#SBATCH --mail-user=philip.deegan@lpp.polytechnique.fr
## END SBATCH directives

# SLURM INFO
# http://www.idris.fr/jean-zay/cpu/jean-zay-cpu-exec_partition_slurm.html
# http://www.idris.fr/eng/jean-zay/cpu/jean-zay-cpu-exec_partition_slurm-eng.html
set -ex
set -o pipefail
CWD="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)" && cd "$CWD"

module load gcc/12.2.0 cmake/3.21.3 python/3.11.5 hdf5/1.12.0-mpi openmpi/4.1.5

cd "$HOME/PHARE"
[ ! -f ".venv/bin/activate" ] && echo "error: venv not found" && exit 1
# shellcheck disable=SC1091
. .venv/bin/activate
export PYTHONPATH="${WORK}/build:${PWD}:${PWD}/pyphare"

cd "$WORK"
srun --ntasks=80 --ntasks-per-node=40 --cpus-per-task=1 -- python3 harris.py
