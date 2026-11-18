#!/bin/sh

#SBATCH -A naiss2026-4-1938-cpu
#SBATCH -p cpu
#SBATCH -J orthofinder_all
#SBATCH -t 00:10:00
#SBATCH -c 4
#SBATCH -e of_all.err
#SBATCH -o of_all.out

PROJ=/nobackup/proj/disk/naiss2026-4-1938
APPS=$PROJ/apps
BEE=$PROJ/shared/Bee
OUTPUTDIR=$PROJ/personal/$USER/OrthoFinder/all

# Load Python 3.13 (required for running OrthoFinder)
module load Python/3.13.5-bare-gcc-2025b-eb

# Activate virtual environment
. $APPS/of3_env/bin/activate

# Add outgroup to the existing OrthoFinder analysis
orthofinder --assign $BEE/files/proteins_annotated/outgroup --core $OUTPUTDIR/Results_Nov12 -t 4
