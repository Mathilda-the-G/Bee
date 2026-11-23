#!/bin/bash
# Rename headers to genome prefix and concatenate the 764 single-copy
# MAFFT L-INS-i alignments (8 Fructobacillus + LMES, reoriented genomes)
PROJ=/nobackup/proj/disk/naiss2026-4-1938
REPO=$PROJ/shared/Bee
AMAS=$PROJ/apps/AMAS.py
IN=$REPO/results/mafft_linsi/fructo_mes
OUT=$REPO/results/amas/fructo_mes_linsi

mkdir -p $OUT/renamed
for f in $IN/*.aln; do
  sed -E 's/^>([A-Z]+)_[0-9]+/>\1/' "$f" > $OUT/renamed/$(basename "$f")
done

cd $OUT
python3 $AMAS concat -i renamed/*.aln -f fasta -d aa \
  -t concat.fasta -p partitions.nex --part-format nexus
python3 $AMAS summary -i concat.fasta -f fasta -d aa -o summary.txt
