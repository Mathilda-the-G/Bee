#!/bin/bash
#SBATCH -A naiss2026-4-1938-cpu
#SBATCH -p cpu
#SBATCH -n 1
#SBATCH -c 16
#SBATCH -t 24:00:00
#SBATCH -J iqtree_linsi
#SBATCH -o logs/iqtree_linsi_%j.out
#SBATCH --mail-type=ALL
#SBATCH --mail-user=chikiet-freddy.truong.3945@student.uu.se

# IQ-TREE3 on the concatenated MAFFT L-INS-i alignments
# (764 single-copy orthologs, 8 Fructobacillus + LMES, reoriented genomes)

PROJ=/nobackup/proj/disk/naiss2026-4-1938
SIF=$PROJ/apps/iqtree3_3.1.4.sif
REPO=$PROJ/shared/Bee
OUT=$REPO/results/iqtree/fructo_mes_linsi

mkdir -p $OUT
cd $OUT

apptainer exec -B $PROJ $SIF iqtree3 \
  -s ../../amas/fructo_mes_linsi/concat.fasta \
  -p ../../amas/fructo_mes_linsi/partitions.nex \
  -m MFP \
  -B 1000 \
  -alrt 1000 \
  -o OHALGOHG \
  -T 16 \
  --prefix fructo_mes_linsi
