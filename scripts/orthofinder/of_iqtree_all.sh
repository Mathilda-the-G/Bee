#!/bin/sh

#SBATCH -A naiss2026-4-1938-cpu
#SBATCH -p cpu
#SBATCH -J orthofinder_all
#SBATCH -t 00:30:00
#SBATCH -c 4
#SBATCH -e of_iqtree_all.err
#SBATCH -o of_iqtree_all.out

PROJECT=/nobackup/proj/disk/naiss2026-4-1938
APPS=$PROJECT/apps
BEE=$PROJECT/shared/Bee
OUTPUTDIR=$PROJECT/personal/daer9945/OrthoFinder

# Load Python 3.13 (required for running OrthoFinder)
module load Python/3.13.5-bare-gcc-2025b-eb

# Activate virtual environment
. $APPS/of3_env/bin/activate

# Move outgroup file so all input files are in the same directory
mv $BEE/files/proteins_annotated/outgroup/GCF_000014445.1.faa $BEE/files/proteins_annotated

# Run a new OrthoFinder analysis with corrected species tree from iqtree
orthofinder -f $BEE/files/proteins_annotated -s $BEE/results/iqtree/fructo_concat_GCF_nolength.treefile -o $OUTPUTDIR/Results_Nov18 -t 4

mv $BEE/files/proteins_annotated/GCF_000014445.1.faa $BEE/files/proteins_annotated/outgroup
