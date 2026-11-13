#!/bin/bash
#SBATCH -A naiss2026-4-1938-cpu
#SBATCH -p cpu
#SBATCH -J checkm2_kunkeei
#SBATCH -t 01:00:00
#SBATCH -c 8
#SBATCH --mail-type=ALL
#SBATCH --mail-user=chikiet-freddy.truong.3945@student.uu.se
#SBATCH -o checkm2_kunkeei_%j.out

# Positive control: CheckM2 v1.1.0 on A. kunkeei genomes (same setup as scripts/checkm2.sh)

PROJ=/nobackup/proj/disk/naiss2026-4-1938
APPS=$PROJ/apps
BEE=$PROJ/shared/Bee
DB=$(find "$APPS"/checkm2_db -name '*.dmnd')

GENOMES=$(find "$BEE"/files/raw_data/ncbi_dataset/data_a_kunkeei -name 'GCF_*_genomic.fna' | sort)

apptainer exec -B "$PROJ" "$APPS"/checkm2.sif checkm2 predict \
  --threads 8 \
  --database_path "$DB" \
  --input $GENOMES \
  --output-directory "$BEE"/results/checkm2/a_kunkeei \
  --force
