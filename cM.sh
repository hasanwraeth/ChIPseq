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

	computeMatrix reference-point --referencePoint TSS \
	-b 2500 -a 2500 \
	-R hg38.bed \
	-S $prefix.$species.${SRR}*.bw \
	--skipZeros \
	-p 4 \
	-o matrix.${SRR}_hg38.gz \
	--outFileSortedRegions regions.${SRR}_hg38.bed
done


computeMatrix scale-regions -S bwa.hs38.HARK7.rep2.bw \
                              -R hg38.bed \
                              --beforeRegionStartLength 3000 \
                              --regionBodyLength 5000 \
                              --afterRegionStartLength 3000 \
                              --skipZeros -o matrix.mat.gz
