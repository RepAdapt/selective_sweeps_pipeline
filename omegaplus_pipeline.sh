#!/bin/bash

# Specify your inputs: vcf + gff. It also needs a VCF index file which can be generated with tabix: tabix -p final_variants.vcf.gz
VCF=""
GFF=""

# Parse arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        -vcf) VCF="$2"; shift ;;
        -gff)   GFF="$2"; shift ;;
        *) echo "Unknown parameter: $1"; exit 1 ;;
    esac
    shift
done

# Validate required arguments
if [[ -z "$VCF" || -z "$GFF" ]]; then
    echo "Error: Missing required arguments."
    echo "Usage: $0 -vcf <vcf_file> -gff <gff_file>"
    exit 1
fi

# Optional: check files exist
if [[ ! -f "$VCF" ]]; then
    echo "Error: VCF file not found: $VCF"
    exit 1
fi

if [[ ! -f "$GFF" ]]; then
    echo "Error: GFF file not found: $GFF"
    exit 1
fi

echo "VCF file: $VCF"
echo "GFF file: $GFF"




# This script runs OmegaPlus by gene using 2 CPUs threads. You can adjust the number of threads in the SLURM specification above AND in the OmegaPlus command at line 38. There is little to no advantage in using more threads.
# We use a OmegaPlus grid of size 3 for each gene which results in 3 measurements: one at the first SNP in a gene, one at the last SNP and one equidistant between these (approx. in the middle of the gene).
# Adjust time limit according to the number of genes in your dataset (now 23 hours).


### Formatting the gff: extracting genes, adding 1000 bp flanks on either side and saving original coordinates (without flanks) ###

awk -F'\t' '$3 == "gene"' $GFF | awk '{OFS="\t"}{print $1,$4-1000,$5+1000,$1":"$4"-"$5}' | awk '{OFS="\t"}{if ($2 > 0)  print $1":"$2"-"$3,$4; else print $1":"1"-"$3,$4;}' > genes_coord.txt




### OmegaPlus ###

# The code below loop over all genes. For each gene, it extracts from the VCF (with bcftools) the gene region with 1000 bp added on either side
# Then OmegaPlus is run on each expanded gene using a grid size of 3, minwin 500 and maxwin 100000
# Each output file name includes the original (start and end without added flanks) gene coordinates formatted as CHROM:start-end 


regex='(.+)	(.+)'


while read p; do

if [[ $p =~ $regex ]];  then 	apptainer exec apptainer/bcftools\:1.16--hfe4b78e_1 bcftools view $VCF --regions ${BASH_REMATCH[1]} -Ov -o temp_${BASH_REMATCH[2]}\.vcf; apptainer run apptainer/OmegaPlus.sif -input temp_${BASH_REMATCH[2]}\.vcf -minwin 500 -maxwin 100000 -grid 3 -name output_${BASH_REMATCH[2]} -seed 12345 -threads 2; fi
        rm temp_${BASH_REMATCH[2]}\.vcf
        tail -n +3 OmegaPlus_Report.output_${BASH_REMATCH[2]} | awk -v var="${BASH_REMATCH[2]}" 'BEGIN {OFS="\t"} {print var, $2}' >> temp.txt	
        rm OmegaPlus_Report*
        rm OmegaPlus_Info*
        
done < genes_coord.txt




# Format results: for each gene only retain the measurement (out of 3 measurements) in the center

awk 'NR % 3 == 2' temp.txt  > OmegaPlus_$VCF\_final_output.txt
rm temp.txt

