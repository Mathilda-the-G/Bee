#!/usr/bin/env bash
#SBATCH -A naiss2026-4-1938-cpu
#SBATCH -c 1
#SBATCH -t 20
#SBATCH -J dnaapler
#SBATCH --output=%x.%j.out
#SBATCH --error=%x.%j.err
set -euo pipefail

BIND="/nobackup/proj/disk/naiss2026-4-1938"
SIF="/nobackup/proj/disk/naiss2026-4-1938/apps/dnaapler.sif"
IN_DIR="files/raw_data/ncbi_dataset/data_fructo/reversed"
OUT_DIR="results/dnaapler2"

mkdir -p "$OUT_DIR"

shopt -s nullglob
for f in "$IN_DIR"/*.fna; do
    base=$(basename "$f" .fna)
    apptainer exec -B "$BIND" "$SIF" \
        dnaapler chromosome -i "$f" -o "$OUT_DIR/$base" -p "$base" -t 20 -f
done