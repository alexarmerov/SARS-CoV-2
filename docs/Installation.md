# Installation

#### Operating system requirements
<p align="justify">
The pipeline was developed on macOS Mojave 10.14.6 and has to be tested on Ubuntu 20.04.
The software was installed with the following system requirements:
 </p>

- Python 3.7.12
- Conda 4.12.0
- Git 2.20.1
- Perl 5

#### Pipeline software installation
<p align="justify">
1. A first step is to retrieve the pipeline from github with git.
</p>
<p align="justify">
Clone the pipeline
</p>

```
git clone https://github.com/alexarmerov/SARS-CoV-2

```

<p align="justify">
Change directory
</p>

```
cd SARS-CoV-2

```
<p align="justify">
At this point, you could activate the scripts execution permissions with the following command:
</p>

```
chmod +x scripts/*

```
 
2. Installation of software requires conda. Installation of conda is described [here](https://docs.conda.io/projects/conda/en/latest/user-guide/install/index.html). Once installed conda, run the following commands: 

- Activate conda base environment

```
conda activate base

```
- Install mamba and then create the iSNVs environment by installing snakemake at the same time. 

```
conda install -c conda-forge mamba
mamba create -c conda-forge -c bioconda -n iSNVs snakemake python=3.7

```

- Activate iSNVs environment
```
conda activate iSNVs

```

- Install software

```
conda install -c bioconda sra-tools=2.8.0
conda install -c bioconda trimmomatic=0.39
conda install -c bioconda bowtie2=2.4.2
conda install -c bioconda samtools=1.7
conda install -c bioconda picard=2.23.8
conda install -c bioconda biopet-bamstats
conda update --all
conda install -c bioconda perl-statistics-basic
conda install -c bioconda fastqc

```

3. An important step is the installation of the VirVarSeq toolkit. ViVarSeq can be retrieved from [here](https://sourceforge.net/projects/virtools/?source=directory). Then follow the instructions for installation.


#### The following is a list of the main bioinformatics software installed in the iSNVs environment.

  - Snakemake 7.7.0 
  - Sra-tools 2.8.0
  - Trimmomatic 0.39
  - Bowtie2 2.4.2
  - Samtools 1.7
  - Picard 2.23.8
  - Biopet-bamstats 1.0.1
  - Fastqc 0.11.9
  - VirVarSeq 2013-10-01 
  
