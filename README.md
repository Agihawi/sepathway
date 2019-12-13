# Pipeline to extract proteins and pathway analysis


Ensure:
- Assembled Genomes (complete) are in the `genomes/` directory and are in the format: `{sample}.fna.gz`
- Singularity image files in the bin directory: `sepathway.sif` `prokka.sif` and `R_environment.sif` - (see notes on how to obtain these)
- Ensure you have a working version of python/snakemake and singularity (type: `source dependencies` for UEA cluster)

Then launch the pipeline:
`./1_launch_snake.sh`

Pathway output will be generated in the `interproscan/` directory

# Collating Pathway Results:
You can then collate all results for each pathway using an R container with:

`cd bin/ && singularity exec R_environment.sif Rscript collate_pathways.R;  cd ../`

You may receive the message `Fatal: Kernel too old` - copy and run the above code on another machine 


### Downloading Genomes

Kai Blin's NCBI-genome-downloader is also installed in the prokka.sif container making downloading genomes easy.

Example:
- Launch the singularity 
`singularity shell bin/prokka.sif`
- Download the all complete bacterial genomes for the genus Fusobacterium to the genomes/ folder
`ncbi-genome-download --format fasta --assembly-level complete --genus Fusobacterium -o genomes/
- Move all genomes to the genomes folder
`mv genomes/refseq/*/*/*.gz genomes/; rm -rf genomes/refseq/`

More options can be observed with `ncbi-genome-download --help`

you can exit the singularity any time with `exit`


If something goes wrong and you need to cancel the pipeline. Before re-launching, ensure the directory is unlocked:
`snakemake --snakefile run_ipsn.snake --unlock`


### Notes:

#### Obtaining singularity image files:
All def files used to create singularity images are in `dmp/`

Downloading from sylabs (ensure singularity is installed):
- navigate to bin: `cd bin/`
- download interproscan singularity: ``
- download prokka singularity: `singularity pull library://a_gihawi/prokka/prokka.sif:latest`
- download R singularity: `singularity pull library://a_gihawi/default/tidyverse_environment:latest`
