#!/bin/bash

# Software pipeline installation 

# Activate conda base environment

conda activate base

#  Install mamba and then create the iSNVs environment by installing snakemake at the same time. 

conda install -c conda-forge mamba
mamba create -c conda-forge -c bioconda -n iSNVs snakemake python=3.7
conda activate iSNVs

# Install software

conda install -c bioconda sra-tools=2.8.0
conda install -c bioconda trimmomatic=0.39
conda install -c bioconda bowtie2=2.4.2
conda install -c bioconda samtools=1.7
conda install -c bioconda picard=2.23.8
conda install -c bioconda biopet-bamstats
conda update --all
conda install -c bioconda perl-statistics-basic
conda install -c bioconda fastqc
