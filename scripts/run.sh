#!/bin/bash

# This script obtains a consensus sequence of the alignment of the clean reads to the reference genome

startpos=$1
endpos=$2
genome=$3
path=$4
log=$5
 
# Parameters:
# startpos: initial genomic position of the gene 
# endpos: final genomic position of the gene
# genome: reference genome
# path: path to the scripts of VirVarSeq


indir=./fastq
outdir=./results
samples=./samples/samples.txt
ref=./genomes/$genome



## Specify path to VirVarSeq libraries 

export PERL5LIB=$path/lib


### Get the consensus sequence 

$path/consensus.pl --samplelist $samples --ref $ref --indir $indir --outdir $outdir --start $startpos --end $endpos >> $log 2>&1

