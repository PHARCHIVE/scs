#!/usr/bin/env bash

## BEGIN SBATCH directives
#SBATCH --job-name=run052a
#SBATCH --output=run052a.txt
#
#SBATCH --ntasks=80
#SBATCH --time=24:00:00
#SBATCH --partition=cpu_dist
#SBATCH --account=phare
#SBATCH --mail-type=ALL
#SBATCH --mail-user=nicolas.aunai@lpp.polytechnique.fr
## END SBATCH directives

## load modules
module load cmake gcc/10.2.0 openmpi hdf5 mambaforge

conda activate phare

export PYTHONPATH="$WORKDIR/builds/c911d4dbe7/:/mnt/beegfs/home/LPP/nicolas.aunai/phare/pyphare"

## execution
mpirun -n "$SLURM_NTASKS" python harris.py
