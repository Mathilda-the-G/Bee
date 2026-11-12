#!/bin/sh

#SBATCH -A naiss2026-4-1938-cpu
#SBATCH -p cpu
#SBATCH -J orthofinder_ingroup
#SBATCH -t 01:00:00
#SBATCH -c 4
#SBATCH -e of_ingroup.err
#SBATCH -o of_ingroup.out

APPS=/nobackup/proj/disk/naiss2026-4-1938/apps
BEE=/nobackup/proj/disk/naiss2026-4-1938/shared/Bee
OUTPUTDIR=/nobackup/proj/disk/naiss2026-4-1938/personal/daer9945/OrthoFinder

# Load Python 3.13 (required for running OrthoFinder)
module load Python/3.13.5-bare-gcc-2025b-eb

# Activate virtual environment
. $APPS/of3_env/bin/activate

# Run OrthoFinder
orthofinder -f $BEE/files/proteins_annotated -t 4 -o $OUTPUTDIR
