#!/bin/bash
#SBATCH -A naiss2026-4-1938-cpu
#SBATCH -p cpu
#SBATCH -J checkm2
#SBATCH -t 01:00:00
#SBATCH -c 8
#SBATCH --mail-type=ALL
#SBATCH --mail-user=chikiet-freddy.truong.3945@student.uu.se
#SBATCH -o checkm2_%j.out

# CheckM2 v1.1.0 (biocontainers 1.1.0--pyhdfd78af_2) on the RefSeq (GCF) genomes

PROJ=/nobackup/proj/disk/naiss2026-4-1938
APPS=$PROJ/apps
BEE=$PROJ/shared/Bee
DB=$(find "$APPS"/checkm2_db -name '*.dmnd')

# All GCF genome files under files/ncbi_dataset/ (Fructobacillus + outgroup)
GENOMES=$(find "$BEE"/files/ncbi_dataset -name 'GCF_*_genomic.fna' | sort)

apptainer exec -B "$PROJ" "$APPS"/checkm2.sif checkm2 predict \
  --threads 8 \
  --database_path "$DB" \
  --input $GENOMES \
  --output-directory "$BEE"/results/checkm2 \
  --force
