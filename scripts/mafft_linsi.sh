#!/usr/bin/env bash
#SBATCH -A naiss2026-4-1938-cpu
#SBATCH -c 1
#SBATCH -t 00:10:00
#SBATCH -J mafft_linsi
#SBATCH --output=%x.%j.out
#SBATCH --error=%x.%j.err
set -euo pipefail

BIND="/nobackup/proj/disk/naiss2026-4-1938"
SIF="/nobackup/proj/disk/naiss2026-4-1938/apps/mafft.sif"
IN_DIR="results/orthofinder/of_fructo_mes/Single_Copy_Ortholog_Sequences"
OUT_DIR="results/mafft_linsi/fructo_mes"

mkdir -p "$OUT_DIR"

shopt -s nullglob
for f in "$IN_DIR"/*.fa "$IN_DIR"/*.fasta "$IN_DIR"/*.faa; do
    base=$(basename "$f")
    base="${base%.*}"
    apptainer exec --bind "$BIND" "$SIF" \
        mafft --localpair --maxiterate 1000 "$f" > "$OUT_DIR/${base}.aln"
done

echo "Done: $(ls "$OUT_DIR"/*.aln | wc -l) alignments in $OUT_DIR"