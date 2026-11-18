#!/bin/sh

#SBATCH -A naiss2026-4-1938-cpu
#SBATCH -p cpu
#SBATCH -J orthofinder_a_kunkeei
#SBATCH -t 01:00:00
#SBATCH -c 4
#SBATCH -e of_a_kunkeei.err
#SBATCH -o of_a_kunkeei.out

PROJ=/nobackup/proj/disk/naiss2026-4-1938
APPS=$PROJ/apps
BEE=$PROJ/shared/Bee
OUTPUTDIR=$PROJ/personal/$USER/OrthoFinder/Results_a_kunkeei

# Load Python 3.13 (required for running OrthoFinder)
module load Python/3.13.5-bare-gcc-2025b-eb

# Activate virtual environment
. $APPS/of3_env/bin/activate

# Run OrthoFinder
orthofinder -f $BEE/files/proteins_annotated/A.kunkeii -t 4 -o $OUTPUTDIR

