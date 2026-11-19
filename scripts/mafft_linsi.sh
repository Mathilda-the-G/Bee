#!/usr/bin/env bash
set -euo pipefail

IN_DIR="orthofinder_results/of_ingroup_single_copy"
OUT_DIR="mafft/of_ingroup"
JOBS="3"          # number of alignments to run at once

mkdir -p "$OUT_DIR"

align_one() {
    f="$1"; out_dir="$2"
    base=$(basename "$f")
    base="${base%.*}"
    mafft --localpair --maxiterate 1000 > "$out_dir/${base}.aln"
}
export -f align_one

find "$IN_DIR" -maxdepth 1 -type f \( -name "*.fa" -o -name "*.fasta" -o -name "*.faa" \) \
    | parallel -j "$JOBS" align_one {} "$OUT_DIR"

echo "Done: $(ls "$OUT_DIR"/*.fasta | wc -l) alignments in $OUT_DIR"