#!/usr/bin/env bash

set -ex
set -o pipefail

CWD="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)" && cd "$CWD"

# Adastra SLURM info
# https://dci.dci-gitlab.cines.fr/webextranet/user_support/index.html#batch-scripts

## BEGIN SBATCH directives
#SBATCH --job-name=run051c
#SBATCH --output=run051c.txt
#SBATCH --constraint=GENOA
#SBATCH --nodes=1
#SBATCH --ntasks=80
#SBATCH --ntasks-per-node=80
#SBATCH --threads-per-core=1 # --hint=nomultithread
#SBATCH --time=24:00:00
#SBATCH --account=cad14812
#SBATCH --exclusive
#SBATCH --mail-type=ALL
#SBATCH --mail-user=philip.deegan@lpp.polytechnique.fr
##SBATCH --partition=genoa
## END SBATCH directives

# shellcheck disable=SC1091
. "${CWD}/mod.sh"

cd "$HOME/PHARE"
[ ! -f ".venv/bin/activate" ] && echo "error: venv not found" && exit 1

# shellcheck disable=SC1091
. .venv/bin/activate
export PYTHONPATH="${WORKDIR}/build:${PWD}:${PWD}/pyphare"

cd "$WORKDIR"
srun --ntasks=80 --ntasks-per-node=80 --cpus-per-task=1 -- python3 -uO harris.py
