# selective_sweeps_pipeline
A pipeline for scanning all genes of a species to detect signals of selective sweeps, based on OmegaPlus.

It can be run on any Linux system (without job scheduler), or can be easily deployed to any HPC. I provided SLURM syntax specifying 2 CPUs threads, 4GB RAM per CPU and 23 HOURS run time: these can be changed according to your dataset. Given that OmegaPlus is run on a per gene basis doing only 3 scans per gene it is very fast, so there is very little advantage in using more than 2 threads.

# Input: 
SNP VCF file (with tabix index) and a .gff file with genes.

# Software: OmegaPlus v3.0.3 and bcftools v1.16
Download the OmegaPlus v3.0.3 Apptainer image here: https://github.com/RepAdapt/selective_sweeps_pipeline/releases/download/v3.0.3/OmegaPlus.sif


<pre>wget https://github.com/RepAdapt/selective_sweeps_pipeline/releases/download/v3.0.3/OmegaPlus.sif</pre>

Download the bcftools v1.16 Apptainer image here: <pre> singularity run https://depot.galaxyproject.org/singularity/bcftools:1.16--hfe4b78e_1 </pre>

# DO NOT USE YET, STILL UNDER DEVELOPMENT
