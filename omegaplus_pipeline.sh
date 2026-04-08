#!/bin/bash
#SBATCH --time=0-23:00
#SBATCH --cpus-per-task=2
#SBATCH --mem-per-cpu=4G
#SBATCH --account=def-yeaman

module load apptainer


# This script runs OmegaPlus by gene using 2 CPUs threads. You can adjust the number of threads in the SLURM specification above AND in the OmegaPlus command at line 38. There is little to no advantage in using more threads.
# We use a OmegaPlus grid of size 3 for each gene which results in 3 measurements: one at the first SNP in a gene, one at the last SNP and one equidistant between these (approx. in the middle of the gene).
# Adjust time limit according to the number of genes in your dataset (now 23 hours).


### Formatting the gff: extracting genes, adding 1000 bp flanks on either side and saving original coordinates (without flanks) ###

awk -F'\t' '$3 == "gene"' *.gff | awk '{OFS="\t"}{print $1,$4-1000,$5+1000,$1":"$4"-"$5}' | awk '{OFS="\t"}{if ($2 > 0)  print $1":"$2"-"$3,$4; else print $1":"1"-"$3,$4;}' > genes_coord.txt




### OmegaPlus ###

mkdir omegaplus_raw_output

# Specify your VCF file name. It also needs a VCF index file which can be generated with tabix: tabix -p final_variants.vcf.gz

FILE="final_variants.vcf.gz"


# The code below loop over all genes. For each gene, it extracts from the VCF (with bcftools) the gene region with 1000 bp added on either side
# Then OmegaPlus is run on each expanded gene using a grid size of 3, minwin 500 and maxwin 100000
# Each output file name includes the original (start and end without added flanks) gene coordinates formatted as CHROM:start-end 


regex='(.+)	(.+)'


while read p; do

if [[ $p =~ $regex ]];  then 	apptainer exec apptainer/bcftools\:1.16--hfe4b78e_1 bcftools view $FILE --regions ${BASH_REMATCH[1]} -Ov -o $FILE\_${BASH_REMATCH[2]}\.vcf; apptainer run apptainer/OmegaPlus.sif -input $FILE\_${BASH_REMATCH[2]}\.vcf -minwin 500 -maxwin 100000 -grid 3 -name $FILE\_${BASH_REMATCH[2]} -seed 12345 -threads 2; fi
	rm $FILE\_${BASH_REMATCH[2]}\.vcf
	mv OmegaPlus_Report* omegaplus_raw_output
	mv OmegaPlus_Info* omegaplus_raw_output
done < genes_coord.txt




# Format results

mkdir temp_dir

while read p; do

if [[ $p =~ $regex ]];  then tail -n +3 omegaplus_raw_output/OmegaPlus_Report.*.vcf.gz_${BASH_REMATCH[2]} | awk -v var="${BASH_REMATCH[2]}" 'BEGIN {OFS="\t"} {print var, $2}' > temp_dir/formatted_${BASH_REMATCH[2]}; fi

done < genes_coord.txt



cat temp_dir/formatted_* > temp_dir/temp.txt
awk 'NR % 3 == 2' temp_dir/temp.txt  > OmegaPlus_$FILE\_final_output.txt
rm -r temp_dir

