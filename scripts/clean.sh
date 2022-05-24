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

if [  -s $dir/Variants/*.coverage.csv  ]
then
   rm $dir/Variants/*.coverage.csv
fi

if [  -s $dir/Variants/*non.synonym.csv  ]
then
   rm  $dir/Variants/*non.synonym.csv
fi

if [  -s $dir/Variants/*variants.synonym.csv  ]
then
   rm   $dir/Variants/*variants.synonym.csv
fi

if [  -s $dir/codon_table/*.stat  ]
then
  rm $dir/codon_table/*.stat
fi

if [  -s $dir/alignmentConsensus/*WthDuplicates.bam*  ]
then
  mv $dir/alignmentConsensus/*WthDuplicates.bam* $dir 
  rm $dir/alignmentConsensus/*
  mv $dir/*WthDuplicates.bam* $dir/alignmentConsensus 
fi


if [  -s $dir/consensus/*bt2  ]
then
  rm  $dir/consensus/*bt2
fi

if [  -d $dir/map_vs_consensus  ]
then
  rm -r $dir/map_vs_consensus
fi

if [  -s $dir/alignmentBowtie/*WthDuplicates.bam*  ]
then
  mv $dir/alignmentBowtie/*WthDuplicates.bam* $dir
  rm $dir/alignmentBowtie/*
  mv $dir/*WthDuplicates.bam* $dir/alignmentBowtie
fi

if [  -s  report.reads.txt ]
then
mv report.reads.txt $dir
fi

if [ -s report.minority.variants.txt  ]
then
mv report.minority.variants.txt $dir
fi
