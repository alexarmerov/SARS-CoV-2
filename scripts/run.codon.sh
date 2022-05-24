#!/bin/bash
# Identification of minority variants in the alignments of the reads against the consensus sequences


region_start=$1
region_len=$2
genome=$3
path=$4
log=$5
qv=20


# Parameters:           
# region_start: position in the genome of the first base of the gene
# region_len: protein length in amino acids
# genome: reference genome   
# path: path to the scripts of VirVarSeq                                                              # qv: quality threshold 


outdir=./results
samples=./samples/samples.txt
ref=./genomes/$genome


## Path to VirVarSeq libraries

export PERL5LIB=$path/lib/


## Identification of synonymous and non-synonymous substitutions; estimation of the frequency of these substitutions

$path/codon_table.pl --samplelist $samples --ref $ref --outdir $outdir --start=$region_start --len=$region_len --trimming=0 --qual=$qv >> $log 2>&1

