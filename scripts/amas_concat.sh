#!/bin/bash
# Rename headers to genome prefix and concatenate the 764 single-copy alignments
PROJ=/nobackup/proj/disk/naiss2026-4-1938
REPO=$PROJ/shared/Bee
AMAS=$PROJ/apps/AMAS.py
IN=$REPO/results/mafft/of_all_Single_Copy
OUT=$REPO/results/amas

mkdir -p $OUT/renamed
for f in $IN/*.aln; do
  sed -E 's/^>([A-Z]+)_[0-9]+/>\1/' "$f" > $OUT/renamed/$(basename "$f")
done

cd $OUT
python3 $AMAS concat -i renamed/*.aln -f fasta -d aa \
  -t concat.fasta -p partitions.nex --part-format nexus
