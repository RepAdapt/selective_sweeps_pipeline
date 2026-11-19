#!/bin/bash
#SBATCH --time=0-8:00
#SBATCH --cpus-per-task=2
#SBATCH --mem-per-cpu=4G
#SBATCH --account=def-yeaman

# change run time according to your dataset size
# number of cpu per task needs to reflect the number of threads used by omegaplus, which I set to 2 in the omegaplus_pipeline.sh script

module load apptainer
module load htslib

./omegaplus_pipeline.sh -vcf /home/gabnoc/projects/def-yeaman/repadapt_datasets/filtered_vcfs/rawg0029_aedes_notoscriptus_paris_filtered.filtered.vcf.gz -gff test.gff
