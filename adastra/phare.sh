#!/bin/bash
# Adastra SLURM info
# https://dci.dci-gitlab.cines.fr/webextranet/user_support/index.html#batch-scripts

set -ex
set -o pipefail

CWD="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)" && cd "$CWD"

## BEGIN SBATCH directives
#SBATCH --job-name=run100c
#SBATCH --output=run100c.txt
#SBATCH --constraint=GENOA
#SBATCH --nodes=2
#SBATCH --ntasks=192
#SBATCH --ntasks-per-node=192
#SBATCH --threads-per-core=1 # --hint=nomultithread
#SBATCH --time=24:00:00
##SBATCH --partition=genoa
#SBATCH --account=cad14812
#SBATCH --exclusive
##SBATCH --output=%A.out
#SBATCH --mail-type=ALL
#SBATCH --mail-user=philip.deegan@lpp.polytechnique.fr
## END SBATCH directives

module load cray-python/3.11.5 gcc-native/12.1 cray-hdf5-parallel

cd "$HOME/PHARE"
[ ! -f ".venv/bin/activate" ] && echo "error: venv not found" && exit 1
# shellcheck disable=SC1091
. .venv/bin/activate
export PYTHONPATH="${WORKDIR}/build:${PWD}:${PWD}/pyphare"

cd "$WORKDIR"
srun --ntasks=384 --ntasks-per-node=192 --cpus-per-task=1 -- python3 -Ou harris.py
