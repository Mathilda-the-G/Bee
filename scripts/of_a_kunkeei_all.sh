#!/bin/sh

#SBATCH -A naiss2026-4-1938-cpu
#SBATCH -p cpu
#SBATCH -J of_a_kunkeei_all
#SBATCH -t 00:30:00
#SBATCH -c 4
#SBATCH -e of_a_kunkeei_all.err
#SBATCH -o of_a_kunkeei_all.out

# Positive control: add the outgroup (L. mesenteroides, LMES) to the
# A. kunkeei OrthoFinder run, same way as of_all.sh did for Fructobacillus.

PROJ=/nobackup/proj/disk/naiss2026-4-1938
APPS=$PROJ/apps
BEE=$PROJ/shared/Bee
WORK=$PROJ/personal/$USER/OrthoFinder_a_kunkeei
ENV=$APPS/of3_env

# Work on a copy of the A. kunkeei run (from the repo) so the original is not touched
mkdir -p $WORK
rm -rf $WORK/Results_core
cp -r $BEE/results/orthofinder/of_a_kunkeei $WORK/Results_core

# Load Python 3.13 (required for running OrthoFinder)
module load Python/3.13.5-bare-gcc-2025b-eb

# Use the shared OrthoFinder environment directly (its tools must be on PATH)
export PATH=$ENV/bin:$PATH

# Add outgroup to the existing A. kunkeei analysis (output: a new Results_core_* folder in $WORK)
$ENV/bin/python $ENV/bin/orthofinder --assign $BEE/files/proteins_annotated/outgroup --core $WORK/Results_core -t 4
