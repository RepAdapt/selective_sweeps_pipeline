#!/bin/bash
#SBATCH --time=0-23:00
#SBATCH --cpus-per-task=2
#SBATCH --mem-per-cpu=4G
#SBATCH --account=def-yeaman

module load apptainer

./omegaplus_pipeline.sh -vcf final_variants.vcf.gz -gff GCF_000001735.4_TAIR10.1_genomic_CHR_MATCHED.gff
