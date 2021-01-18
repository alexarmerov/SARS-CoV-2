from os.path import join
import re
import string
DIR = "data"
IDS, = glob_wildcards(join(DIR, "{id}.sra"))
configfile: "./config.yaml"
genome = "CoV2.fasta"

rule all:
    input:
      expand("trimming/{id}_1.clean.fastq", id=IDS)

rule Trimming:
    input:
        "data/{id}_1.fastq"
    output:
        "trimming/{id}_1.clean.fastq"
    shell:"""

       trimmomatic SE  {input} {output}  ILLUMINACLIP:TruSeq3-SE:2:30:10  LEADING:6 TRAILING:6  SLIDINGWINDOW:4:20 MINLEN:40

    """

rule alignentBowtiePaire:
       input:
         "trimming/{id}_1.clean.fastq",
       output:
         "alignmentBowtie/{id}.sam"
       shell:"""

        bowtie2 -x genomes/CoV2  -U {input}  -S {output}  --no-unal

          """


rule getBam:
       input:
         "alignmentBowtie/{id}.sam"

       output:
         "alignmentBowtie/{id}.bam"

       shell:"""

        samtools view -S -b {input} > {output}

   """


rule sortBowtie:
       input:
         "alignmentBowtie/{id}.bam"
       output:
         "alignmentBowtie/{id}.sorted.bam"
       shell:"""

           samtools sort {input} -o {output}

        """

rule RemoveUnmappede:
       input:
        "alignmentBowtie/{id}.sorted.bam"
       output:
        "alignmentBowtie/{id}.mapped.bam"
       shell:"""

           samtools view -b -F 4 {input} > {output}

	      """


rule MarkDuplicates:
       input:
         "alignmentBowtie/{id}.mapped.bam"
       output:
        bam="alignmentBowtie/{id}.WthDuplicates.bam",
        metrics="alignmentBowtie/{id}.metricsDuplicates.txt"
       shell:"""

picard  MarkDuplicates I={input} O={output.bam} M={output.metrics} REMOVE_DUPLICATES=true


        """

rule indexBowtie:
       input:
        "alignmentBowtie/{id}.WthDuplicates.bam"
       output:
        "alignmentBowtie/{id}.WthDuplicates.bam.bai"
       shell:"""

           samtools index  {input}

        """



rule BackToSam:
       input:
        "alignmentBowtie/{id}.WthDuplicates.bam"
       output:
        "results/map_vs_ref/{id}.sam"
       shell:"""

        samtools view -h -o {output} {input}

       """

rule Copie:
       input:
          "data/{id}_1.fastq",
       output:
         R1="fastq/Sample_{id}/{id}_1.fastq",
         R2="fastq/Sample_{id}/{id}_2.fastq"
       shell:"""

        cp {input} {output.R1}
        cp {input} {output.R2}

       """


rule Compress:
       input:
         R1="fastq/Sample_{id}/{id}_1.fastq",
         R2="fastq/Sample_{id}/{id}_2.fastq"
       output:
         R1="fastq/Sample_{id}/{id}_1.fastq.gz",
         R2="fastq/Sample_{id}/{id}_2.fastq.gz"
       shell:"""

        gzip {input.R1}
        gzip {input.R2} 

       """

rule Consensus:
       input:
         expand("results/map_vs_ref/{id}.sam", id=IDS)
       output:
         expand("results/consensus/{id}_consensus.fa", id=IDS)
       params:
         pos_start = str(config["start_position"]),
         pos_end = str(config["end_position"]),  
         length = str(config["length_protein"])
       shell:"""

       scripts/run.sh {params.pos_start} {params.pos_end} {params.length}

       """


rule alignmentConsensus:
       input:
          rd="trimming/{id}_1.clean.fastq",
	  consensus="results/consensus/{id}_consensus.fa"
       output:
         "alignmentConsensus/{id}.sam"
       shell:"""

bowtie2-build {input.consensus} results/consensus/{wildcards.id}
bowtie2 --local -x results/consensus/{wildcards.id} -U {input.rd} -S {output} --no-unal

          """

rule getBamConsensus:
       input:
         "alignmentConsensus/{id}.sam"

       output:
         "alignmentConsensus/{id}.bam"
       shell:"""

        samtools view -S -b {input} > {output}

   """


rule sortBAMConsensus:
       input:
         "alignmentConsensus/{id}.bam"
       output:
         "alignmentConsensus/{id}.sorted.bam"
       shell:"""

           samtools sort {input} -o {output}

        """

rule MarkDuplicatesConsensus:
       input:
        "alignmentConsensus/{id}.sorted.bam"
       output:
        bam="alignmentConsensus/{id}.WthDuplicates.bam",
        metrics="alignmentConsensus/{id}.metricsDuplicates.txt"
       shell:"""

picard  MarkDuplicates I={input} O={output.bam} M={output.metrics} REMOVE_DUPLICATES=true


        """


rule indexBAMConsensus:
       input:
        "alignmentConsensus/{id}.WthDuplicates.bam"
       output:
        "alignmentConsensus/{id}.WthDuplicates.bam.bai"
       shell:"""

           samtools index  {input}

        """


rule BackToSamConsensus:
       input:
         "alignmentConsensus/{id}.WthDuplicates.bam"
       output:
         "results/map_vs_consensus/{id}.sam"
       shell:"""

       samtools view -h -o {output} {input}

       """

rule Codons:
       input:
         expand("results/map_vs_consensus/{id}.sam", id=IDS)
       output:
         expand("results/codon_table/{id}.codon", id=IDS)
       params:
         pos_start = str(config["start_position"]),
         pos_end = str(config["end_position"]),  
         length = str(config["length_protein"])
       shell:"""

      scripts/run.codon.sh {params.pos_start} {params.pos_end} {params.length}

       """


rule  SaveResults:
       input:
         results="results",
         consensus="alignmentConsensus"
       output:
         directory("Gene_"+str(config["start_position"])+"_"+str(config["end_position"]))
       shell:"""

        mv  {input.results} {output}
        mv  {input.consensus} {output} 

       """

rule  Variants:
       input:
        expand("Gene_"+str(config["start_position"])+"_"+str(config["end_position"])+'/codon_table/{id}.codon', id=IDS),
        dir="Gene_"+str(config["start_position"])+"_"+str(config["end_position"])+'/codon_table/'
       output:
        directory("Gene_"+str(config["start_position"])+"_"+str(config["end_position"])+'/Variants')
       params:
        pos_start = str(config["start_position"]),
        length = str(config["length_protein"]),
        cv = str(config["coverage_position"]),
        cp = str(config["coverage_protein"]) 
       shell:"""

        scripts/pipeline.variants.consensus1.sh {input.dir} {params.pos_start} {params.length} {params.cv} {params.cp}

       """


