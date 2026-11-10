#!/bin/bash
#SBATCH -A naiss2026-4-1938-cpu
#SBATCH -p cpu
#SBATCH -J checkm2
#SBATCH -t 01:00:00
#SBATCH -n 8
#SBATCH --mail-type=ALL
#SBATCH --mail-user=chikiet-freddy.truong.3945@student.uu.se
#SBATCH -o checkm2_%j.out

APPS=/nobackup/proj/disk/naiss2026-4-1938/apps
BEE=/nobackup/proj/disk/naiss2026-4-1938/shared/Bee
DB=$(find $APPS/checkm2_db -name '*.dmnd')

apptainer exec -B /nobackup/proj/disk/naiss2026-4-1938 $APPS/checkm2.sif checkm2 predict \
  --threads 8 \
  --database_path $DB \
  --input $BEE/data/genomes \
  --output-directory $BEE/results/checkm2 \
  -x fna
