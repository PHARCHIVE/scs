#!/bin/bash

## BEGIN SBATCH directives
#SBATCH --job-name=run100c
#SBATCH --output=run100c.txt
#SBATCH --constraint=GENOA
#SBATCH --nodes=2
#SBATCH --ntasks=192
#SBATCH --ntasks-per-node=192
#SBATCH --threads-per-core=1 # --hint=nomultithread
#SBATCH --time=02:00:00
##SBATCH --partition=genoa
#SBATCH --account=cad14812
#SBATCH --exclusive
##SBATCH --output=%A.out
#SBATCH --mail-type=ALL
#SBATCH --mail-user=philip.deegan@lpp.polytechnique.fr
## END SBATCH directives

module load cray-python/3.11.5 gcc-native/12.1 cray-hdf5-parallel

cd $HOME/PHARE
. .venv/bin/activate
export PYTHONPATH="${WORKDIR}/build:${PWD}:${PWD}/pyphare"

cd $WORKDIR
mkdir -p plog # perf files go here
srun --ntasks=384 --ntasks-per-node=192 --cpus-per-task=1 -- ./perf.sh
