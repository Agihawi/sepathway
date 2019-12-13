#!/bin/bash

# Run the snakemake file
snakemake --snakefile run_ipsn.snake --keep-going

#collate results
cd bin/ && singularity exec R_environment.sif Rscript collate_pathways.R;  cd ../
