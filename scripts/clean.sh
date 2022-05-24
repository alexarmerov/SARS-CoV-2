#!/bin/bash

# Remove redundant directories and files

dir=$1

# Parameters:
# dir: directory output 

if [  -d fastq  ]
then
   rm -r fastq     
fi
 

if [  -d count  ]
then
   rm -r count
fi

if [  -d logs  ]
then
   rm -r logs
fi

if [  -d data  ]
then
   rm data/*.fastq
fi

if [  -d genomes  ]
then
   rm genomes/*.bt2
fi

if [  -d $dir/Variants  ]
then
   rm $dir/Variants/*.coverage.csv $dir/Variants/*non.synonym.csv $dir/Variants/*variants.synonym.csv
fi

if [  -d $dir/codon_table  ]
then
  rm $dir/codon_table/*.stat
fi

if [  -d $dir/alignmentConsensus  ]
then
  mv $dir/alignmentConsensus/*WthDuplicates.bam* $dir 
  rm $dir/alignmentConsensus/*
  mv $dir/*WthDuplicates.bam* $dir/alignmentConsensus 
fi


if [  -d $dir/consensus  ]
then
  rm  $dir/consensus/*bt2
fi

if [  -d $dir/map_vs_consensus  ]
then
  rm -r $dir/map_vs_consensus
fi

if [  -d $dir/alignmentBowtie  ]
then
  mv $dir/alignmentBowtie/*WthDuplicates.bam* $dir
  rm $dir/alignmentBowtie/*
  mv $dir/*WthDuplicates.bam* $dir/alignmentBowtie
fi

if [  -s  report.reads.txt ] && [ -s report.minority.variants.txt  ]
then
mv report.reads.txt report.minority.variants.txt $dir
fi