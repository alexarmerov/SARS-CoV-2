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
A first step is to retrieve the pipeline from github with git.
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


Installation of software requires conda. Installation of conda is described [here](https://docs.conda.io/projects/conda/en/latest/user-guide/install/index.html). Once installed conda, the simplest way to install the software is to use packages_install.sh script, available in the directory SARS-CoV-2. This script creates a conda environment called iSNVs in which the pipeline will be executed.


```
chmod +x packages_install.sh
./packages_install.sh

```

An important step is the installation of the VirVarSeq toolkit. ViVarSeq can be retrieved from [here](https://sourceforge.net/projects/virtools/?source=directory). Then follow the instructions for installation.


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
  
