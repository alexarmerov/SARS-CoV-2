# Troubleshooting 

<p align="justify">
If an error occurs during the execution of the pipeline, and you are sure that you have followed the installation and configuration steps correctly, you may still be able to obtain useful information by looking in the logs subdirectory. Log files are created in this subdirectory for each of the rules or tasks executed by the pipeline. The log file could give you signs of the causes that are behind the error in a specific task.
</p>

<p align="justify">
A common error occurs when the samples.txt file in the samples subdirectory does not completely match the names of the files in the data subdirectory.
</p>

<p align="justify">
The content of a samples.txt file looks something like:
</p>
  
```
cat samples/samples.txt
SRR11494491
SRR13178795
```
<p align="justify">
While the content of the data directory could have:
</p>

```
find data/*
data/SRR11494491.sra
data/SRR13178795.sra
```
<p align="justify">
If any of the files in the data subdirectory are not present in the samples.txt file or the opposite, you will encounter problems in the rule that obtains the consensus sequences.
</p>
