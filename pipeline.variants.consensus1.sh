#!/bin/bash

      dir=$1"/"

  echo "Directory input $dir"
  echo "Start position in genomes $2"
  echo "Length to the protein $3"
  echo "Threshold coverage per position $4"
  echo "% coverage protein $5"

    dir_var=$(echo "${dir/codon_table/Variants}")
    mkdir $dir_var

for file in "$dir"*.codon
do

   # Determined if each position is covered at least by X% The number of lines before and after remove positions with reads below this threshold is compared.

    echo $file
    out=$(echo "${file/.codon/.coverage.csv}")
    out=$(echo "${out/codon_table/Variants}")

# 1274  100 1
    
        scripts/Variants1.pl $file $3 $4 $5  >  $out
   
    if [ -s $out ]
      then
       wc -l $out                                          
    else
       rm $out
    fi 
done

for fl_ft in "$dir_var"*.coverage.csv
  do
    out_mj=$(echo "${fl_ft/coverage.csv/majority.csv}")
    out_sn=$(echo "${fl_ft/coverage.csv/variants.synonym.csv}")
    out_ns=$(echo "${fl_ft/coverage.csv/non.synonym.csv}")

    if [ -s "$fl_ft" ]
    then
      scripts/MajorityConsensus.pl $fl_ft $out_mj $out_sn $out_ns $4  
    fi
    if [ -s "$out_mj" ] 
     then
     wc -l  $out_mj
    fi
    if [ -s "$out_sn" ]
     then
     wc -l  $out_sn
    fi
    if [ -s "$out_ns" ]
     then
     wc -l $out_ns
    fi
done


for fl_sy in "$dir_var"*.variants.synonym.csv
  do
 out_sy=$(echo "${fl_sy/variants.synonym.csv/synonym.genome.csv}")

  if [ -s "$fl_sy" ]
     then
     scripts/Synonym.pl $fl_sy $2  > $out_sy
  fi
  if [ -s "$out_sy" ]
     then
     wc -l $out_sy
  fi
done

###


for fl_nsy in "$dir_var"*.non.synonym.csv
  do
 out_nsy=$(echo "${fl_nsy/csv/genome.csv}")

  if [ -s "$fl_nsy" ]
     then
     scripts/Synonym.pl $fl_nsy $2  > $out_nsy
  fi
  if [ -s "$out_nsy" ]
     then
     wc -l $out_nsy
  fi
done
