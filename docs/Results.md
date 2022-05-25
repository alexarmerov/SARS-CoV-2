# Results

<p align="justify">
The results of the pipeline are located in a directory called Gene_PoInt_PosEnd, where PoInt is the initial genomic position of the gene and PosEnd is the final position of the gene. In this document the subdirectory with the spike results (Gene_21563_25384) is used as an example.
</p>

<p align="justify">
The pipeline produces several results that we divide between main and secondary. 
</p>
 
## Main results

<p align="justify">
1. File: report.reads.txt, subdirectory: Gene_21563_25384.

 It is a report of the number of paired-end reads in some of the main steps of the pipeline.  
</p>
 
##### Columns:
###### - sample: id sample  
###### - number_raw_reads: number of raw paired-end reads        
###### - number_trimmed_reads: number of trimmed paired-end reads    
###### - reads_aligned_reference: number of paired-end reads aligning to the SARS-CoV-2 genome 
###### - reads_aligned_consensus: number of paired-end reads aligning to the consensus sequence

<p align="justify">
2. File: report.minority.variants.txt, subdirectory: Gene_21563_25384

This file describes the parameters under which the pipeline was executed. If the pipeline identified iSNVs, this file retrieves the id sample and the number of synonymous and nonsynonymous variants.
</p>

<p align="justify">
3. File: SRR11494491.synonym.genome.csv, subdirectory: Gene_21563_25384/Variants

 The minority synonymous and nonsynonymous variants identified in a sample are found in files with extensions ".synonym.genome.csv" and "non.synonym.genome.csv", respectively.
</p>

##### Columns:
###### - aminoacid_position: amino acid position in protein
###### - reference_codon: codon with the highest frequency
###### - codon: codon minority variant  
###### - aminoacid_reference: amino acid of the codon with the highest frequency    
###### - aminoacid: amino acid of codon minority variant       
###### - nucleotide: minority variant      
###### - genomic_position: the minority variant genomic position       
###### - number_reads_codon: number of reads aligning to codon minority variant      
###### - number_reads_position: total number of reads aligning to protein position   
###### - codon_frequency: codon minority variant frequency or alternative allele frequency (AAF) 


<p align="justify">
4. File: SRR13178795.codon, subdirectory: Gene_21563_25384/codon_table

Raw results of VirVarSeq scripts.
</p>
 
##### Columns:
###### - SAMPLE: id sample  
###### - POSITION: amino acid position in protein       
###### - REF_CODON: codon with the highest frequency       
###### - CODON: current codon   
###### - REF_AA: amino acid of the codon with the highest frequency  
###### - AA: amino acid of current codon     
###### - FWD_CNT: number of forward reads aligning to the current codon  
###### - FWD_DENOM: total number of forward reads that align with the protein position
###### - REV_CNT: number of reverse reads aligning to the current codon
###### - REV_DENO: total number of reverse reads aligning to the protein position 
###### - FWD_MEAN_MIN_QUAL: mean of the minimum Phred quality score for the forward reads      
###### - REV_MEAN_MIN_QUAL: mean of the minimum Phred quality score for the reverse reads       
###### - FWD_FREQ: frequency of the current codon determined from the alignment of the forward reads        
###### - REV_FREQ: frequency of the current codon determined from the alignment of the reverse reads        
###### - LOW_FREQ: lowest frequency        
###### - LOW_FREQ_DIRECTION: direction of the lowest frequency (reverse or forward)      
###### - FWD_STDDEV_MIN_QUAL:  standard deviation of minimum Phred quality score distribution for forward reads  
###### - REV_STDDEV_MIN_QUAL: standard deviation of minimum Phred quality score distribution for reverse reads 
###### - CNT: total number of reads supporting the current codon     
###### - DENOM: total number of reads supporting protein position   
###### - FREQ: Frequency of the current codon 


<p align="justify">
5. File: SRR11494491.majority.csv, subdirectory: Gene_21563_25384/Variants

Codons with the highest frequency. The fields in this file are the same as described above.
</p>

## Secondary results  
<p align="justify">
These results allow visualizing minority variants and some could be used in downstream analysis.
</p>

<p align="justify">
1. Quality control

 File: SRR11494491_1.clean_fastqc.html, subdirectory: Gene_21563_25384/QC

Fastqc files describing the quality of clean reads.
</p>

<p align="justify">
2. The following results could be used to display minority variants in a browser.
</p>
<p align="justify">
 - File:SRR11494491.WthDuplicates.bam, subdirectory: Gene_21563_25384/alignmentBowtie

 BAM file of the alignment of the clean reads to the SARS-CoV-2 genome. 
</p>
<p align="justify"> 
- File: SRR11494491_consensus.fa, subdirectory: Gene_21563_25384/consensus

Consensus sequence (FASTA file).
</p>
<p align="justify"> 
- File:SRR11494491.WthDuplicates.bam, subdirectory: Gene_21563_25384/alignmentConsensus

BAM file of the alignment of the clean reads to the consensus sequences.
</p>
