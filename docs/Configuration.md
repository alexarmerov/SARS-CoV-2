
# Configuration


#### Four points are important to keep in mind in the configuration step.

<p align="justify">
 1. Configuration of the config.yaml file. This file  is located in the SARS-CoV-2 directory and contains the main parameters of the analysis. These parameters are explained below, using the SARS-CoV-2 spike gene as an example:
</p>


##### - Initial genomic position of the gene.

```
start_position: 21563

```
##### - Final genomic position of the gene.

```
end_position: 25384

```
##### - Protein length.
```
length_protein: 1274

```
##### - Minimum number of reads covering a position. Positions with a number of reads lower than this threshold are not considered in the analysis.
```
coverage_position: 30

```
##### - Minimum protein coverage (proportion). Sequences with a ratio of covered positions less than this threshold are discarded.
```
coverage_protein: 0.9

```
##### - Number of threads available for workflow parallelization. Please specify the number of CPUs available on your system.
```
nm_threads: 4

```
##### - Genome reference in FASTA format.
```
reference_genome: CoV2.fasta

```
##### - Path to VirVarSeq scripts. Please, replace PathVirVarSeq with the path to the VirVarSeq directory on your system.
```
path_virvarseq: /PathVirVarSeq/VirVarSeq

```
##### - Adapters in FASTA format, input for trimmomatic. This file should be located in the genomes subdirectory. 
```
adapters: genomes/adapters.fasta

```
<p align="justify">
If you want to analyze another gene different to the spike, you must specify the initial and final genomic positions and the length of the protein. For example, to analyze the nucleocapsid gene, the following parameters must be modified:
</p>
  
##### - Initial position of the nucleocapsid in the SARS-CoV-2 genome.

```
start_position: 28274

```
##### - Final position of the nucleocapsid in the SARS-CoV-2 genome.

```
end_position: 29533

```
##### - Protein nucleocapsid length.

```
length_protein: 419

```
<p align="justify">
Please modify the parameters that are specific to the system on which the pipeline is run. Pay particular attention to path_virvarseq and nm_threads parameters. 
</p>
  
#### 2. Reference genome
<p align="justify">
The reference genome is located in the genomes subdirectory. This is a FASTA file. If the user wants to use another viral genome, it is necessary to place the FASTA file in this subdirectory and modify the reference_genome parameter in the config.yaml file.
</p>
  
#### 3. Data
<p align="justify">
The input files to the pipeline are located in the data subdirectory. These are Sequence Read Archive (SRA) files, a format for high throughput sequencing data. The limit of the number of samples that can be analyzed is determined by the computational resources of the user. Before running the pipeline please uncompress the test data with the following command:
 </p>

```
unzip data/SRR13178852.sra.zip

```

#### 4. List samples
<p align="justify">
In the samples subdirectory is the samples.txt file. This file contains a complete list of samples to be analyzed (sra files), one id sample per line. It is important that this list fully matches the files present in the data subdirectory.
</p>
<p align="justify">
An example of the content of the samples.txt file is presented below:
</p>

```
cat samples/samples.txt
SRR11494491
SRR13178795

```


