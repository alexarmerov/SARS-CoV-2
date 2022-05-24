
## Introduction

<p align="justify">
SARS-CoV-2 is a new pathogen with devastating consequences globally. The convergence of new sequencing technologies and bioinformatic tools have made it possible to continuously monitor the diversity of this virus. However, this monitoring has focused on variants of consensus sequences. Less attention has been given to variants that occur at a low frequency, called intra-host single-nucleotide variants (iSNVs). We developed a bioinformatics pipeline for the identification of iSNVs in next-generation sequencing (NGS) data.
</p>
 
<p align="justify">
The pipeline identifies synonymous and nonsynonymous iSNVs and their respective frequencies in a viral gene. The characterization of iSNVs in coding sequences is based on the identification of codons supported by filtered reads according to various quality criteria. This approach has the advantage of taking into account the sequence context in which the variant emerges. In the pipeline, some of the scripts from the VirVarSeq toolkit  are used for the identification iSNVs based on codons.
</p>

<p align="justify">
The pipeline was developed to identify iSNVs in paired-end short Illumina reads. The pipeline has been used mainly in sequences obtained with the ARTIC system of amplicon-based sequencing. We have also tested it on sequences obtained with the shotgun approach.
</p>
 
## Pipeline
 
<p align="justify">
The pipeline was developed with Snakemake, which allows analysis scalability and reproducibility. The figure below describes the main steps of the pipeline. There are two main stages in the pipeline. In the first one, a consensus sequence is obtained from the alignment of the reads to the reference sequence of SARS-CoV-2. Then the reads are realigned to the consensus sequence and the iSNVs are identified. 
</p>

<img src="https://user-images.githubusercontent.com/26271184/169827528-067ed7d4-36e1-4a55-bd54-559a1553fc47.png" width="600" height="600">

## Documentation 

1. [Installation](docs/Installation.md)
2. [Pipeline configuration](docs/Configuration.md)
3. [Running the pipeline](docs/RunningPipeline.md)
4. [Results](docs/Results.md)
5. [Troubleshooting](docs/Troubleshooting.md)

## Getting Help

If you identify a bug or other problem with the pipeline, please file an [issue](../../../../alexarmerov/SARS-CoV-2/issues)
 
## Citations

This pipeline was developed for our analyzes of SARS-CoV-2 iSNVs. If you use this pipeline, you could cite the following publication:

Armero, A., Berthet, N., & Avarre, J. C. (2021). Intra-Host Diversity of SARS-Cov-2 Should Not Be Neglected: Case of the State of Victoria, Australia. Viruses, 13(1), 133. https://doi.org/10.3390/v13010133.
