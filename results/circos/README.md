Only the chromosome (longest sequence) is plotted. 
Plasmids are left out.

The plot is rotated so ORI is at the top and TER near the bottom.

From outside in:
    Grey ring: Position along the chromosome
    Outer gene ring: Genes on forward (+) strand
    Inner gene ring: Genes on reverse (-) strand
    GC skew: Purple = more G, Yellow = more C

Gene colors:
    Red - Fructobacillus-specific coregenes: 
        In all 8 Fructobacillus genomes, no matching gene with the outgroup
    Blue - Core genes shared with the outgroup:
        In all 8 Fructobacillus genomes + in the outgroup (L. mesenteroides)
    Green - Accessory genes:
        In 2-7 of the 8 Fructobacillus genomes
    Orange - Unique genes (genome specific):
        Only in 1 specific genome.


How ori and ter are found:

Replication starts at ori and ends at ter. The two strands are copied differently, which leaves a small excess of G over C on one half of the chromosome and the reverse on the other half. The GC skew therefore changes sign at ori and ter. Adding the skew up along the sequence gives a curve whose minimum is ori and maximum is ter.

As a check, the gene dnaA (which starts replication) should lie next to ori. Positions are accurate to about one window (5 kb).

The sequence start (0.00 Mb) is just where the assembly was cut open. It has no biological meaning, which is why the plots are rotated to put ori at the top.