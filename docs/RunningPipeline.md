
# Running the pipeline

<p align="justify">
Before running the pipeline, please check the four points described in the configuration section. For the execution of the pipeline, the iSNVs environment must be activated:
</p>


```
conda activate iSNVs

```
<p align="justify">
The execution of the pipeline can be done in two different ways:
</p>

```
snakemake --cores 4 clean 

```

or 

```
snakemake --cores 4

```
<p align="justify">
If the user wants to use more or less than 4 CPUs to run the pipeline, the user can specify it in the previous lines, in that case it is also important to modify the nm_threads parameter in the config.yaml file.
</p>

<p align="justify">
You can test the pipeline with the SRA files found in the data subdirectory (SRR11494491.sra and SRR13178795.sra ) or you could try it with your own SARS-CoV-2 SRA files.
</p>
  
<p align="justify">
The results of the pipeline are located in a directory called Gene_PoInt_PosEnd, where PoInt is the initial genomic position of the gene and PosEnd is the final position of the gene (E.g. Gene_21563_25384).
</p>
