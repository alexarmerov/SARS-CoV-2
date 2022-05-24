from os.path import join
import re
import string
DIR = "data"
IDS, = glob_wildcards(join(DIR, "{id}.sra"))
configfile: "./config.yaml"


rule all:
    input:
      "Gene_"+str(config["start_position"])+"_"+str(config["end_position"])+"/report.reads.txt"
     

# Get fastq files from sra file

rule fastq:
    input:
      "data/{id}.sra"
    output:
      fw="data/{id}_1.fastq",
      rv="data/{id}_2.fastq"
    params:
      dir=directory("data/")
    threads:
      int(config["nm_threads"])
    log:"logs/fastq/{id}.log"
    shell:"""

  fastq-dump  --split-files  {input}  -O {params.dir}  2> {log}

    """

# Count raw reads

rule countRaw:
    input:
      expand("data/{id}_1.fastq", id=IDS)
    output:
      "count/count.raw.txt"
    log:"logs/countRaw.log"
    shell:"""

   scripts/count_fastq.sh {input} {output}  2> {log}

    """


# Trimming reads

rule trimming:
    input:
        fw="data/{id}_1.fastq",
        rv="data/{id}_2.fastq",
        lk="count/count.raw.txt"
    output:
        tf="trimming/{id}_1.clean.fastq",
        tr="trimming/{id}_2.clean.fastq",
        uf="trimming/{id}_1.unpaired.fq.gz",
        ur="trimming/{id}_2.unpaired.fq.gz"
    threads:
        int(config["nm_threads"])
    params:
        ad=str(config["adapters"])
    log:"logs/trimming/{id}.log"
    shell:"""

       trimmomatic PE -threads {threads} {input.fw} {input.rv} {output.tf} {output.uf} {output.tr} {output.ur} ILLUMINACLIP:{params.ad}:2:30:10  LEADING:6 TRAILING:6  SLIDINGWINDOW:4:20 MINLEN:40 2> {log}

    """


# Count trimming reads

rule countTri:
    input:
      expand("trimming/{id}_1.clean.fastq", id=IDS),
    output:
      "count/count.trimming.txt"
    log:"logs/countTri.log"
    shell:"""

   scripts/count_fastq.sh {input} {output} 2> {log}

    """

# Quality control

rule fastqc:
    input:
        tf="trimming/{id}_1.clean.fastq",
        tr="trimming/{id}_2.clean.fastq",
        lk="count/count.trimming.txt"
    output:
        qctf="QC/{id}_1.clean_fastqc.html",
        qctr="QC/{id}_2.clean_fastqc.html"
    threads:
        int(config["nm_threads"])
    params:
        dir="QC",
    log:"logs/qc/{id}.log"
    shell:"""

     fastqc  --threads {threads} {input.tf} --outdir={params.dir}  2> {log} 
     fastqc  --threads {threads} {input.tr} --outdir={params.dir}  2>> {log}

      
    """

rule gunzip:
    input:
        fw="trimming/{id}_1.unpaired.fq.gz",
	rv="trimming/{id}_2.unpaired.fq.gz",
        lk="QC/{id}_1.clean_fastqc.html"
    output:
       fw="trimming/{id}_1.unpaired.fq",
       rv="trimming/{id}_2.unpaired.fq"
    log:"logs/countTri/{id}.log"
    shell:"""

        gunzip {input.fw} -c > {output.fw} 2> {log}
        gunzip {input.rv} -c > {output.rv} 2>> {log}
        rm {input.fw} {input.rv} 2> {log}

    """

# Alignment paired-end reads to sequence reference

rule alignentBowtiePairedEnd:
       input:
         fw="trimming/{id}_1.clean.fastq",
         rv="trimming/{id}_2.clean.fastq",
         ur1="trimming/{id}_1.unpaired.fq",
         ur2="trimming/{id}_2.unpaired.fq",
       output:
         "alignmentBowtie/{id}.sam"
       params:
         str(config["reference_genome"])
       threads:
         int(config["nm_threads"])
       log:"logs/alignentBowtiePairedEnd/{id}.log"
       shell:"""

        bowtie2-build --threads {threads} genomes/{params} genomes/{params} 2> {log}

        bowtie2  --threads {threads}  -x genomes/{params} -1 {input.fw} -2 {input.rv} -U {input.ur1},{input.ur2} -S {output} 2>> {log}

          """

# Get bam from sam file

rule getBam:
       input:
         "alignmentBowtie/{id}.sam"
       output:
         "alignmentBowtie/{id}.bam"
       threads:
         int(config["nm_threads"])
       log:"logs/getBam/{id}.log"
       shell:"""

        samtools view --threads {threads}  -F 4  -S -b {input} > {output}  2> {log}

   """

# Sort bam file by coordinates

rule sortBowtie:
       input:
         "alignmentBowtie/{id}.bam",
       output:
         "alignmentBowtie/{id}.sorted.bam"
       threads:
         int(config["nm_threads"]) 
       log:"logs/sortBowtie/{id}.log"
       shell:"""

           samtools sort --threads {threads} {input} -o {output} 2> {log}

        """

# Remove duplicate sequences

rule markDuplicates:
       input:
         "alignmentBowtie/{id}.sorted.bam"
       output:
         bam="alignmentBowtie/{id}.WthDuplicates.bam",
         metrics="alignmentBowtie/{id}.metricsDuplicates.txt"
       log:"logs/markDuplicates/{id}.log"
       shell:"""

     picard  MarkDuplicates I={input} O={output.bam} M={output.metrics} REMOVE_DUPLICATES=true 2> {log}

        """

# Get index from the sorted bam file

rule indexBowtie:
       input:
        "alignmentBowtie/{id}.WthDuplicates.bam"
       output:
        "alignmentBowtie/{id}.WthDuplicates.bam.bai"
       log:"logs/indexBowtie/{id}.log"
       shell:"""

           samtools index {input} 2> {log}

        """

# Count the number of paired-end reads aligned to consensus sequences

rule rSeQCWth:
       input:
         bi="alignmentBowtie/{id}.WthDuplicates.bam",
         lk="alignmentBowtie/{id}.WthDuplicates.bam.bai"
       output:
         "alignmentBowtie/{id}.stat.WthDuplicates.txt"
       log:"logs/rSeQCWth/{id}.log"
       shell:"""

        bam_stat.py  -i {input.bi} -q 0  >  {output} 2> {log}

    """

# Generate a report of all samples of the number of aligned paired-end reads  

rule collate_outputsWthDuplicated:
    input:
       expand("alignmentBowtie/{id}.stat.WthDuplicates.txt", id=IDS)
    output:
       "count/count.WthDuplicated.txt"
    run:
       with open(output[0],'w') as out:
        head = [ "File", "Total reads", "Unmapped reads","Non spliced reads" , "Spliced reads", "Proper pairs" ]
        head =  '\t'.join( head )
        out.write( "%s\n" % head)
        for i in input:
          file = i.split('.')[0]
          nm = file.split('/')[1]
          for line in open(i):
           if re.match("(.*)Total records(.*)", line):
                 total = line.split(':')[1]
                 total = total.strip()
           if re.match("(.*)Unmapped reads(.*)", line):
                 unmapped = line.split(':')[1]
                 unmapped = unmapped.strip()
           if re.match("(.*)Non-splice reads(.*)", line):
                 nonspliced = line.split(':')[1]
                 nonspliced = nonspliced.strip()
           if re.match("(.*)Splice reads(.*)", line):
                 spliced = line.split(':')[1]
                 spliced = spliced.strip()
           if re.match("(.*)Reads mapped in proper pairs(.*)", line):
                 propes = line.split(':')[1]
                 propes = propes.strip()
                 pre = [ nm, total, unmapped, nonspliced, spliced , propes]
                 result = '\t'.join( pre )
                 out.write( "%s\n" % result)


# Step required to run VirVarSeq scripts  

rule copie:
       input:
         R1="data/{id}_1.fastq",
         R2="data/{id}_2.fastq",
         lk="count/count.WthDuplicated.txt"
       output:
         R1="fastq/Sample_{id}/{id}_1.fastq",
         R2="fastq/Sample_{id}/{id}_2.fastq"
       log:"logs/copie/{id}.log"
       shell:"""

        cp {input.R1} {output.R1} 2> {log}
        cp {input.R2} {output.R2} 2>> {log}

       """

# Step required to run VirVarSeq scripts

rule compress:
       input:
         R1="fastq/Sample_{id}/{id}_1.fastq",
         R2="fastq/Sample_{id}/{id}_2.fastq"
       output:
         R1="fastq/Sample_{id}/{id}_1.fastq.gz",
         R2="fastq/Sample_{id}/{id}_2.fastq.gz"
       log:"logs/compress/{id}.log"
       shell:"""

        gzip {input.R1}  2> {log}
        gzip {input.R2} 2>> {log}

       """


# Get the sam file that will be used to obtain the consensus sequence

rule backToSam:
       input:
         bi="alignmentBowtie/{id}.WthDuplicates.bam",
         lk="fastq/Sample_{id}/{id}_2.fastq.gz"
       output:
         "results/map_vs_ref/{id}.sam"
       threads:
         int(config["nm_threads"])
       log:"logs/backToSam/{id}.log"
       shell:"""

        samtools view --threads {threads} -h -o {output} {input.bi}  2> {log}

       """

# Calculate the consensus sequence

rule consensus:
       input:
         expand("results/map_vs_ref/{id}.sam", id=IDS)
       output:
         expand("results/consensus/{id}_consensus.fa", id=IDS)
       params:
         pos_start = str(config["start_position"]),
         pos_end = str(config["end_position"]),  
         reference=str(config["reference_genome"]),
         path=str(config["path_virvarseq"])
       log:"logs/consensus.log"
       shell:"""

       scripts/run.sh {params.pos_start} {params.pos_end} {params.reference} {params.path} {log}
      

       """

# Align clean reads to consensus sequence

rule alignmentConsensus:
       input:
         fw="trimming/{id}_1.clean.fastq",
         rv="trimming/{id}_2.clean.fastq",
         ur1="trimming/{id}_1.unpaired.fq",
         ur2="trimming/{id}_2.unpaired.fq",
         consensus="results/consensus/{id}_consensus.fa"
       output:
         "alignmentConsensus/{id}.sam"
       threads:
         int(config["nm_threads"])
       log:"logs/alignmentConsensus/{id}.log"
       shell:"""

bowtie2-build --threads {threads}   {input.consensus} results/consensus/{wildcards.id} 2> {log}
bowtie2 --threads {threads}  --local -x results/consensus/{wildcards.id} -1 {input.fw} -2 {input.rv} -U {input.ur1},{input.ur2} -S {output} 2>> {log}

          """

# Get bam from sam file

rule getBamConsensus:
       input:
         "alignmentConsensus/{id}.sam"
       output:
         "alignmentConsensus/{id}.bam"
       threads:
         int(config["nm_threads"])
       log:"logs/getBamConsensus/{id}.log"
       shell:"""

        samtools view --threads {threads} -F 4  -S -b {input} > {output}  2> {log}

   """

# Sort bam file

rule sortBAMConsensus:
       input:
         "alignmentConsensus/{id}.bam"
       output:
         "alignmentConsensus/{id}.sorted.bam"
       threads:
         int(config["nm_threads"])
       log:"logs/sortBAMConsensus/{id}.log"
       shell:"""

           samtools sort --threads {threads} {input} -o {output}  2> {log}

        """

# Remove duplicated sequences

rule markDuplicatesConsensus:
       input:
         "alignmentConsensus/{id}.sorted.bam"
       output:
         bam="alignmentConsensus/{id}.WthDuplicates.bam",
         metrics="alignmentConsensus/{id}.metricsDuplicates.txt"
       threads:
         int(config["nm_threads"])
       log:"logs/markDuplicatesConsensus/{id}.log"     
       shell:"""

     picard  MarkDuplicates I={input} O={output.bam} M={output.metrics} REMOVE_DUPLICATES=true 2> {log}


        """

# Index bam file

rule indexBAMConsensus:
       input:
        "alignmentConsensus/{id}.WthDuplicates.bam"
       output:
        "alignmentConsensus/{id}.WthDuplicates.bam.bai"
       log:"logs/indexBAMConsensus/{id}.log"
       shell:"""

           samtools index {input} 2> {log}

        """


rule rSeQCWthCons:
       input:
         bi="alignmentConsensus/{id}.WthDuplicates.bam",
         lk="alignmentConsensus/{id}.WthDuplicates.bam.bai"
       output:
         "alignmentConsensus/{id}.stat.WthDuplicates.txt"
       log:"logs/rSeQCWthCons/{id}.log"
       shell:"""

        bam_stat.py  -i {input.bi} -q 0  >  {output} 2> {log}

    """


# Generate a report of all samples of the number of aligned paired-end reads  

rule collate_outputsConsensus:
    input:
       expand("alignmentConsensus/{id}.stat.WthDuplicates.txt", id=IDS)
    output:
       "count/count.consensus.txt"
    run:
       with open(output[0],'w') as out:
        head = [ "File", "Total reads", "Unmapped reads","Non spliced reads" , "Spliced reads", "Proper pairs" ]
        head =  '\t'.join( head )
        out.write( "%s\n" % head)
        for i in input:
          file = i.split('.')[0]
          nm = file.split('/')[1]
          for line in open(i):
           if re.match("(.*)Total records(.*)", line):
                 total = line.split(':')[1]
                 total = total.strip()
           if re.match("(.*)Unmapped reads(.*)", line):
                 unmapped = line.split(':')[1]
                 unmapped = unmapped.strip()
           if re.match("(.*)Non-splice reads(.*)", line):
                 nonspliced = line.split(':')[1]
                 nonspliced = nonspliced.strip()
           if re.match("(.*)Splice reads(.*)", line):
                 spliced = line.split(':')[1]
                 spliced = spliced.strip()
           if re.match("(.*)Reads mapped in proper pairs(.*)", line):
                 propes = line.split(':')[1]
                 propes = propes.strip()
                 pre = [ nm, total, unmapped, nonspliced, spliced , propes]
                 result = '\t'.join( pre )
                 out.write( "%s\n" % result)


# Get the sam file of reads alignment against the consensus sequences

rule backToSamConsensus:
       input:
         bi="alignmentConsensus/{id}.WthDuplicates.bam",
         lk="count/count.consensus.txt"
       output:
         "results/map_vs_consensus/{id}.sam"
       threads:
         int(config["nm_threads"])       
       log:"logs/backToSamConsensus/{id}.log"
       shell:"""

       samtools view --threads {threads} -h -o {output} {input.bi}  2> {log}

       """

# Identification of iSNVs

rule codons:
       input:
         expand("results/map_vs_consensus/{id}.sam", id=IDS)
       output:
         expand("results/codon_table/{id}.codon", id=IDS)
       params:
         pos_start = str(config["start_position"]),
         length = str(config["length_protein"]),
         reference=str(config["reference_genome"]),
         path=str(config["path_virvarseq"])
       log:"logs/codons.log"
       shell:"""

      scripts/run.codon.sh {params.pos_start} {params.length} {params.reference} {params.path}  {log}

       """

# Create a directory with the main results

rule  saveResults:
       input:
        expand("results/codon_table/{id}.codon", id=IDS)
       output:
        expand("Gene_"+str(config["start_position"])+"_"+str(config["end_position"])+'/codon_table/{id}.codon', id=IDS)
       params:
        dir="Gene_"+str(config["start_position"])+"_"+str(config["end_position"])
       log:"logs/saveResults.log"
       shell:"""

         mv  results/codon_table  {params.dir}  2> {log}
         mv  results/consensus {params.dir} 2>> {log}
         mv  results/map_vs_consensus  {params.dir}  2>> {log}
         mv  alignmentConsensus {params.dir}  2>> {log}
         mv  trimming {params.dir}  2>> {log}
         mv  alignmentBowtie {params.dir}  2>> {log}
         rm -r results   2>> {log}
         mv QC {params.dir}  2>> {log}

       """

# Create output files of minor variants

rule  variants:
       input:
        expand("Gene_"+str(config["start_position"])+"_"+str(config["end_position"])+'/codon_table/{id}.codon', id=IDS),
       output:
        expand("Gene_"+str(config["start_position"])+"_"+str(config["end_position"])+'/Variants/{id}.coverage.csv', id=IDS),
         rp="report.minority.variants.txt"   
       params:
        pos_start = str(config["start_position"]),
        length = str(config["length_protein"]),
        cv = str(config["coverage_position"]),
        cp = str(config["coverage_protein"]),
        dir = "Gene_"+str(config["start_position"])+"_"+str(config["end_position"])+'/codon_table/'
       log:"logs/variants.log"
       shell:"""

        scripts/pipeline.variants.consensus1.sh {params.dir} {params.pos_start} {params.length} {params.cv} {params.cp} > {output.rp} 2> {log}

       """

# Report of the number of raw reads,trimmed reads and aligned reads

rule reportCount:
    input:
      rw="count/count.raw.txt",
      tr="count/count.trimming.txt",
      rf="count/count.WthDuplicated.txt",
      cs="count/count.consensus.txt",
      lk="report.minority.variants.txt"
    output:
      "report.reads.txt"
    log:"logs/reportCount.log"
    shell:"""

   python3 scripts/report.py {input.rw} {input.tr} {input.rf} {input.cs} > {output}  2> {log}
 

       """

rule clean:
    input:
      "report.reads.txt"
    output:
      "Gene_"+str(config["start_position"])+"_"+str(config["end_position"])+"/report.reads.txt"
    params:
      dir = "Gene_"+str(config["start_position"])+"_"+str(config["end_position"])
    shell:"""

    scripts/clean.sh {params.dir}

       """