# selective_sweeps_pipeline
STILL UNDER DEVELOPMENT

A pipeline for scanning all genes of a species to detect signals of selective sweeps, based on OmegaPlus.


It can be run on any Linux system without job scheduler, or can be deployed to any HPC.


I provided SLURM syntax for HPC deployment in run.sh (change this according to your HPC job scheduler), specifying 2 CPUs threads, 4GB RAM per CPU and 48 HOURS run time. These requirements can be changed, but given that OmegaPlus is run on a per gene basis and we take only 3 scans per gene the analysis is very fast, so there is very little advantage in using more than 2 threads or more RAM. Run time might have to be increased for very large datasets.

Apptainer is required.

# Input: 
SNP VCF (vcf.gz) file (with tabix index .tbi) and a .gff file with genes.


A tabix index (.tbi) of the VCF file should have been created as part of the SNP calling pipeline. This can be generated with:
<pre> tabix -p vcf vcf_file.vcf.gz </pre>


# Software: OmegaPlus v3.0.3 and bcftools v1.16
Download the OmegaPlus v3.0.3 Apptainer image here: https://github.com/RepAdapt/selective_sweeps_pipeline/releases/download/v3.0.3/OmegaPlus.sif

<pre>wget https://github.com/RepAdapt/selective_sweeps_pipeline/releases/download/v3.0.3/OmegaPlus.sif</pre>

Download the bcftools v1.16 Apptainer image with: <pre> singularity pull https://depot.galaxyproject.org/singularity/bcftools:1.16--hfe4b78e_1 </pre>


Place the OmegaPlus and bcftools Apptainer images in a directory named "apptainer" within your working directory: 

<pre>mkdir apptainer</pre>
<pre>mv OmegaPlus.sif bcftools:1.16--hfe4b78e_1 apptainer</pre>


# Project Directory Structure
<pre>
working-dir/
├── your_data.vcf.gz
├── your_data.vcf.gz.tbi
├── annotations.gff
└── apptainer/
    ├── OmegaPlus.sif
    └── bcftools-1.16--hfe4b78e_1.sif</pre>


# Run this pipeline from the working-dir with:
<pre> chmod +x omegaplus_pipeline.sh </pre>
<pre> ./omegaplus_pipeline.sh -vcf vcf_file.vcf.gz -gff genes.gff </pre>

On an HPC, edit the run.sh script with your VCF and gff files names and then:
<pre> sbatch run.sh </pre>


