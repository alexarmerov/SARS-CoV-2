import sys
import re

# This script creates a report of the number of paired-reads in the main stages of the pipeline (raw reads, trimmed reads, reads aligned to reference genome and reads aligned to consensus sequence).

raw=sys.argv[1]
trimm=sys.argv[2]
refe=sys.argv[3]
cons=sys.argv[4]

# raw: file number of raw reads
# trimm: file number of trimmed reads
# refe: file number of reads aligned to reference sequence
# cons: file number of reads aligned to consensus sequence 


report_dic = {}
with open(raw, 'r') as f:
    for line in f:
        line=line.strip()
        [srr_file, nm_reads] = line.split(' ')
        report_dic[srr_file]=[]
        report_dic[srr_file].append(nm_reads)


with open(trimm, 'r') as f:
    for line in f:
        line=line.strip()
        [srr_file, nm_reads] = line.split(' ')
        if srr_file in report_dic:
            report_dic[srr_file].append(nm_reads)
        else:
            report_dic[srr_file]=[]
            report_dic[srr_file].append('NA')
            report_dic[srr_file].append(nm_reads)


with open(refe, 'r') as f:
    for line in f:
        line=line.strip()
        if re.match('^(?!.*File).+', line):
            srr_file = line.split('\t')[0]
            nm_reads = line.split('\t')[5]
            if srr_file in report_dic:
                report_dic[srr_file].append(nm_reads)
            else:
                report_dic[srr_file]=[]
                report_dic[srr_file].append(repeat('NA', 2))
                report_dic[srr_file].append(nm_reads) 

with open(cons, 'r') as f:
    for line in f:
        line=line.strip()
        if re.match('^(?!.*File).+', line):
            srr_file = line.split('\t')[0]
            nm_reads = line.split('\t')[5]
            if srr_file in report_dic:
                report_dic[srr_file].append(nm_reads)
            else:
                report_dic[srr_file]=[]
                report_dic[srr_file].append(repeat('NA', 3))
                report_dic[srr_file].append(nm_reads)

impt=['sample', 'number_raw_reads', 'number_trimmed_reads', 'reads_aligned_reference','reads_aligned_consensus']
print("\t".join(impt))
for key in report_dic:
    imp='\t'.join(map(str, report_dic[key] ))
    print('{}\t{}'.format(key, imp))

