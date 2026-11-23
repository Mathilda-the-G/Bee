#!/bin/bash
#SBATCH -A naiss2026-4-1938-cpu
#SBATCH -p cpu
#SBATCH -n 1
#SBATCH -c 16
#SBATCH -t 24:00:00
#SBATCH -J iqtree
#SBATCH -o logs/iqtree_%j.out
#SBATCH --mail-type=ALL
#SBATCH --mail-user=chikiet-freddy.truong.3945@student.uu.se

PROJ=/nobackup/proj/disk/naiss2026-4-1938
SIF=$PROJ/apps/iqtree3_3.1.4.sif
REPO=$PROJ/shared/Bee
cd $REPO/results/iqtree/trimmed

apptainer exec -B $PROJ $SIF iqtree3 \
  -s ../amas/concat_trimmed.fasta \
  -p ../amas/partitions.nex \
  -m MFP \
  -B 1000 \
  -o OHALGOHG \
  -T 16 \
  --prefix fructo_concat
