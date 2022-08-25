#!/bin/bash

#activate right env
#conda activate msa

GEO=$(cat S.txt)
species=hs38
prefix=bwa

for i in $GEO
do
	SRR=$(grep -w "$i"  Book1.csv| cut -d ',' -f 1)
	SRR1=$(grep -w "$i"  Book1.csv| cut -d ',' -f 2)
	SRR2=$(grep -w "$i"  Book1.csv| cut -d ',' -f 3)

	## trim adapter, need trim_galore be installed, here we do not do this step
	mkdir -p fastq.trimmed
	trim_galore --paired -q 15 --fastqc -o fastq.trimmed/ fastq/$SRR1 fastq/$SRR2
done

