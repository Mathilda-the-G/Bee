r"""
Setup:
Make a python environment and install pyCirclize
    python -m venv $HOME\venvs\circos
    & $HOME\venvs\circos\Scripts\Activate.ps1
    pip install pycirclize

Use the Python version
    Press Ctrl+Shift+P, choose Python: Select Interpreter, and pick circos
    If it isn't listed, choose “Enter interpreter path” and browse to
    C:\Users\<you>\venvs\circos\Scripts\python.exe
"""

from pathlib import Path
import numpy as np
import pandas as pd
from pycirclize import Circos
from matplotlib.patches import Patch
 
# ---- settings ----
REPO = Path(__file__).resolve().parent.parent      # the Bee folder
PROKKA = REPO / "results" / "prokka"
OF_IN = REPO / "results" / "orthofinder" / "of_ingroup" / "Orthogroups"
OF_ALL = REPO / "results" / "orthofinder" / "of_all" / "Orthogroups"
OUTGROUP = "GCF_000014445.1"
OUT = REPO / "results" / "circos"
OUT.mkdir(parents=True, exist_ok=True)
 
COLORS = {
    "Fructobacillus-specific core": "#c0392b",   # red
    "core, shared with outgroup":   "#2471a3",   # blue
    "accessory":                    "#27ae60",   # green
    "unique":                       "#f39c12",   # orange
}
 
 
# ---- reading files ----
def read_gff(path):
    """CDS positions and sequence sizes from a Prokka GFF."""
    sizes, genes = {}, []
    with open(path) as fh:
        for line in fh:
            if line.startswith("##FASTA"):
                break
            if line.startswith("##sequence-region"):
                _, seqid, _, end = line.split()
                sizes[seqid] = int(end)
                continue
            if line.startswith("#"):
                continue
            f = line.rstrip("\n").split("\t")
            if f[2] != "CDS":
                continue
            attrs = dict(x.split("=", 1) for x in f[8].split(";"))
            genes.append({"seqid": f[0], "start": int(f[3]), "end": int(f[4]),
                          "strand": f[6], "locus_tag": attrs["locus_tag"],
                          "gene": attrs.get("gene", "")})
    return sizes, pd.DataFrame(genes)
 
 
def read_sequence(path, seqid):
    """One sequence from the ##FASTA part at the end of a Prokka GFF."""
    seq, in_fasta, keep = [], False, False
    with open(path) as fh:
        for line in fh:
            if line.startswith("##FASTA"):
                in_fasta = True
            elif in_fasta and line.startswith(">"):
                keep = line[1:].split()[0] == seqid
            elif in_fasta and keep:
                seq.append(line.strip())
    return "".join(seq).upper()
 
 
def genes_in(cell):
    """Turn an Orthogroups.tsv cell ('A_001, A_002') into a list of gene IDs."""
    return [] if pd.isna(cell) else cell.split(", ")
 
 
def gc_skew(seq, window=5000):
    """(G - C) / (G + C) in non-overlapping windows."""
    pos, skew = [], []
    for i in range(0, len(seq), window):
        w = seq[i:i + window]
        g, c = w.count("G"), w.count("C")
        pos.append(i + len(w) / 2)
        skew.append((g - c) / (g + c) if g + c else 0)
    return np.array(pos), np.array(skew)
 
 
# ---- gene categories (done once, for all genomes) ----
og_in = pd.read_csv(OF_IN / "Orthogroups.tsv", sep="\t", index_col=0)
unassigned = pd.read_csv(OF_IN / "Orthogroups_UnassignedGenes.tsv", sep="\t", index_col=0)
og_all = pd.read_csv(OF_ALL / "Orthogroups.tsv", sep="\t", index_col=0)
GENOMES = list(og_in.columns)                      # the 8 Fructobacillus
 
category = {}
for _, row in og_in.iterrows():
    n = sum(len(genes_in(c)) > 0 for c in row)
    cat = "core" if n == 8 else "accessory" if n >= 2 else "unique"
    for genome in GENOMES:
        for g in genes_in(row[genome]):
            category[g] = cat
for genome in GENOMES:
    for g in unassigned[genome].dropna():
        category[g] = "unique"
 
with_outgroup = set()
for _, row in og_all[og_all[OUTGROUP].notna()].iterrows():
    for genome in GENOMES:
        with_outgroup.update(genes_in(row[genome]))
 
 
def final_category(gene):
    cat = category.get(gene, "unique")
    if cat == "core":
        return "core, shared with outgroup" if gene in with_outgroup else "Fructobacillus-specific core"
    return cat
 
 
# ---- short names from the metadata (GCA_... -> GCF_...) ----
meta = pd.read_csv(REPO / "metadata" / "genome_metadata.tsv", sep="\t")
NAMES = {acc: strain.split()[-1].replace("_", "")
         for acc, strain in zip(meta.accession, meta.species_strain)}
 
# ---- one plot per genome ----
def plot_genome(genome):
    name = NAMES.get(genome, genome)
    gff = PROKKA / f"{genome}_annotated" / f"{genome}.gff"
 
    sizes, genes = read_gff(gff)
    chrom = max(sizes, key=sizes.get)              # longest sequence = chromosome
    size = sizes[chrom]
    genes = genes[genes.seqid == chrom].copy()
    genes["category"] = genes.locus_tag.map(final_category)
 
    pos, skew = gc_skew(read_sequence(gff, chrom))
    cum_skew = np.cumsum(skew)
    ori = pos[np.argmin(cum_skew)]
    ter = pos[np.argmax(cum_skew)]
    dnaA = genes[genes.gene == "dnaA"]
    d = abs(dnaA.start.iloc[0] - ori) if len(dnaA) else np.nan
    dnaA_dist = min(d, size - d)
    print(f"{name}: ori {ori:,.0f}, ter {ter:,.0f}, dnaA {dnaA_dist:,.0f} bp from ori")
 
    # rotate the whole circle so ori is at the top (positions stay the same)
    start = -360 * ori / size
    circos = Circos({chrom: size}, start=start, end=start + 360)
    sector = circos.sectors[0]
 
    axis = sector.add_track((98, 100))
    axis.axis(fc="lightgrey", ec="none")
    axis.xticks_by_interval(250_000, label_formatter=lambda v: f"{v/1e6:.2f} Mb")
 
    fwd = sector.add_track((88, 96))
    rev = sector.add_track((79, 87))
    for g in genes.itertuples():
        track = fwd if g.strand == "+" else rev
        track.rect(g.start - 1, g.end, fc=COLORS[g.category], lw=0)
 
    lim = np.abs(skew).max()
    sk = sector.add_track((62, 76))
    sk.fill_between(pos, np.where(skew > 0, skew, 0), vmin=-lim, vmax=lim, color="#7d3c98", lw=0)
    sk.fill_between(pos, np.where(skew < 0, skew, 0), vmin=-lim, vmax=lim, color="#d4ac0d", lw=0)
 
    cs = sector.add_track((46, 60))
    cs.line(pos, cum_skew, vmin=cum_skew.min(), vmax=cum_skew.max(), color="black", lw=1)
 
    for label, x in (("ori", ori), ("ter", ter)):
        sector.rect(max(0, x - 2000), min(size, x + 2000), r_lim=(46, 100), fc="black", lw=0)
        sector.text(label, x=x, r=107, size=10, fontweight="bold")
 
    circos.text(f"{name}\n{size/1e6:.2f} Mb", size=12)
    fig = circos.plotfig()
    handles = [Patch(color=c, label=k) for k, c in COLORS.items()]
    fig.legend(handles=handles, loc="lower right", fontsize=8, frameon=False)
    fig.savefig(OUT / f"{name}_circos.png", dpi=200)
 
    counts = genes.category.value_counts().to_dict()
    return {"genome": name, "accession": genome, "size_bp": size,
            "ori": round(ori), "ter": round(ter), "dnaA_to_ori_bp": round(dnaA_dist), **counts}
 
 
summary = pd.DataFrame([plot_genome(g) for g in GENOMES]).fillna(0)
summary.to_csv(OUT / "summary.tsv", sep="\t", index=False)
print(summary.to_string(index=False))
 