#!/bin/bash

# Count the number of reads in fastq files

if (( $# < 2 )); then
    echo not enough arguments
    exit 1
fi

n=$#
output=${!n}
((n--))
set -- "${@:1:n}"


for file in  "$@"
do
 if [ -s $file ]
   then
      count=$(awk '{s++}END{print s/4}' $file)   
      match_data="^data.+"
      match_trimming="^trimming.+"   

    if [[ $file =~ $match_data ]];
	 then

          name=$(echo "${file/_1.fastq/}") 
          out=$(echo "${name/data\//}")
          echo $out $count >> $output        
 
    elif [[ $file =~ $match_trimming ]];	 
         then

          name=$(echo "${file/_1.clean.fastq/}")         
          out=$(echo "${name/trimming\//}") 
          echo $out $count >> $output

     fi
  fi
done
