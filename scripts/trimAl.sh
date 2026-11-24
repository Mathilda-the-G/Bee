#!/usr/bin/env bash
set -euo pipefail

IN_DIR="mafft_linsi/fructo_mes/"
OUT_DIR="trimAl"
TRIM_OPTS="-automated1"

mkdir -p "$OUT_DIR"

shopt -s nullglob
files=("$IN_DIR"/*.aln)

for f in "${files[@]}"; do
    base=$(basename "$f" .aln)
    echo "Trimming $base ..."
    trimal -in "$f" -out "$OUT_DIR/${base}.trimmed.aln" -fasta $TRIM_OPTS
done

echo "Done. Trimmed alignments are in $OUT_DIR/"
