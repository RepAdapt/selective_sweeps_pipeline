#!/bin/bash
#SBATCH --time=0-48:00
#SBATCH --cpus-per-task=2
#SBATCH --mem-per-cpu=4G
#SBATCH --account=def-yeaman

# change run time according to your dataset size
# number of cpu per task needs to reflect the number of threads used by omegaplus, which I set to 2 in the omegaplus_pipeline.sh script

module load apptainer

./omegaplus_pipeline.sh -vcf final_variants.vcf.gz -gff Egrandis1_0_genomic_CHR_MATCHED.gff
