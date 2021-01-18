indir=./fastq
outdir=./results
samples=./samples/samples.txt
ref=./genomes/CoV2.fasta
startpos=$1
endpos=$2
region_start=$1
region_len=$3
qv=20

## Specify path to VirVarSeq libraries 
export PERL5LIB=/home/software/VirVarSeq/lib/
log=samples/samples.log 


## Specify path to VirVarSeq scripts

/Path2VirVarSeq/consensus.pl --samplelist $samples --ref $ref --indir $indir --outdir $outdir --start $startpos --end $endpos >> VirVarSeq.log 2>&1

