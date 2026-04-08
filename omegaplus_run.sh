mkdir results

FILE="final_variants.vcf.gz"
regex='(.+)	(.+)'

while read p; do

if [[ $p =~ $regex ]];  then 	apptainer exec singularity/bcftools\:1.16--hfe4b78e_1 bcftools view $FILE --regions ${BASH_REMATCH[1]} -Ov -o $FILE\_${BASH_REMATCH[2]}\.vcf; apptainer run singularity/OmegaPlus.sif -input $FILE\_${BASH_REMATCH[2]}\.vcf -minwin 500 -maxwin 100000 -grid 3 -name $FILE\_${BASH_REMATCH[2]} -seed 12345 -threads 2; fi
	rm $FILE\_${BASH_REMATCH[2]}\.vcf
done < genes_coord.txt

mv OmegaPlus_Report* results
mv OmegaPlus_Info* results
