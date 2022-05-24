#!/bin/bash

# In this script the VirVarSeq output file is processed to identify minority nucleotide variants that lead to synonymous and non-synonymous amino acid substitutions.

      dir=$1

 dir_var=$(echo "${dir/codon_table/Variants}")

   if [ ! -d $dir_var ]
    then
       mkdir $dir_var
   fi

  echo "Start position in genomes $2"
  echo "Protein length $3"
  echo "Threshold coverage per position $4"
  echo "% coverage protein $5"

for file in "$dir"*.codon
do

# The Variants1.pl script removes codons with a depth less than a user-specified threshold. The script then determines the proportion of protein positions with sufficient coverage. The output of this script is a file with the extension ".coverage.csv" which contains only the codons with sufficient coverage.

  prot_lgth=$3
  nr_pos=$4
  porc_pro=$5


  # Parameters
  # prot_lgth: protein length in amino acids
  # nr_pos: minimum number of reads covering a position
  # porc_pro: minimum percentage of protein length covered by reads


    #echo $file
    out=$(echo "${file/.codon/.coverage.csv}")
    out=$(echo "${out/codon_table/Variants}")


        scripts/Variants1.pl $file $prot_lgth  $nr_pos $porc_pro  >  $out

   
done


# Split the output of the last step in three files representing the codons of the consensus sequence, the synonymous minority codons and the nonsynonymous minority codons.

for fl_ft in "$dir_var"*.coverage.csv
  do
    out_mj=$(echo "${fl_ft/coverage.csv/majority.csv}")
    out_sn=$(echo "${fl_ft/coverage.csv/variants.synonym.csv}")
    out_ns=$(echo "${fl_ft/coverage.csv/non.synonym.csv}")
    nr_pos=$4

# Parameters:
# out_mj: file consensus codons 
# out_sn: file synonymous minority codons
# out_ns: file nonsynonymous minority codons 
# nr_pos: minimum number of reads covering a position

    if [ -s "$fl_ft" ]
    then
      scripts/MajorityConsensus.pl $fl_ft $out_mj $out_sn $out_ns $nr_pos
    fi

done

# Identify the genomic positions of minor variants that lead to synonymous amino acid substitutions.

for fl_sy in "$dir_var"*.variants.synonym.csv
  do
 out_sy=$(echo "${fl_sy/variants.synonym.csv/synonym.genome.csv}")

  if [ -s "$fl_sy" ]
     then
     scripts/Synonym.pl $fl_sy $2  > $out_sy
  fi
  if [ -s "$out_sy" ]
     then
     pre_id=$(echo "${out_sy/\.synonym.genome.csv/}")
     id=$(echo $pre_id | cut -d"/"  -f3)
     pre_ct=$(awk 'END{print NR}'  $out_sy)
     ct=$(($pre_ct-1))
     echo "$id number synonymous minority variants $ct, file:$out_sy"
  fi
done

# Identify the genomic positions of minor variants that lead to nonsynonymous amino acid substitutions. 

for fl_nsy in "$dir_var"*.non.synonym.csv
  do
 out_nsy=$(echo "${fl_nsy/csv/genome.csv}")

  if [ -s "$fl_nsy" ]
     then
     scripts/Synonym.pl $fl_nsy $2  > $out_nsy
  fi
  if [ -s "$out_nsy" ]
     then
     pre_id=$(echo "${out_nsy/\.non.synonym.genome.csv/}")
     id=$(echo $pre_id | cut -d"/"  -f3)
     pre_ct=$(awk 'END{print NR}'  $out_nsy)
     ct=$(($pre_ct-1))
     echo "$id number nonsynonymous minority variants $ct, file: $out_nsy"
  fi
done
