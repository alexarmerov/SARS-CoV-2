# SARS-CoV-2
Pipeline for the identification of iSNVs from NGS data
Pipeline for the identification of iSNVs from NGS data.

Required Software:

- sra-tools 2.8.0
- trimmomatic 0.39
- bowtie2 2.4.2
- samtools 1.7
- VirVarSeq
- picard 2.23.8

In the run.sh and run.codon.sh scripts, please specify the path to the libraries and VirVarSeq scripts

For the execution of the pipeline, it is necessary to create four directories:

- genomes: SARS-CoV-2 genome sequences (CoV2.fasta)
- scripts: scripts used by the pipeline
- samples: is this directory specified the Ids of samples in the samples.txt file
- data: fastq files input

It's also necessary a configuration file (config.yaml) withe the following parameters:

- start_position: first genomic position of the gene
- end_position: last genomic position of the gene
- length_protein: length in amino acids of the protein
- coverage_position: minimum number of reads covering a specific position
- coverage_protein: Minimum percentage of positions covered


Input:

It's required the fastq files avec the extension "_1.fastq" and "_2.fastq"

Output:

In the directory Gene_start_position_end_position/Variants the {id}.non.synonym.genome.csv and {id}.synonym.genome.csv files have the iSNVs non synonymous and synonymous identified in the {id} sample.  

