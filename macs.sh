#BSUB -M 128000
#BSUB -W 1440
#BSUB -n 16
#BSUB -R "span[hosts=1]"
#BSUB -q normal
#BSUB -J K3
#BSUB -e /users/reziw3/%J.err
#BSUB -o /users/reziw3/%J.err
module load samtools
module laod picard
module load MACS
module load deeptools

#activate right env
#conda activate msa

GEO=$(tail -n +2 SraRunTable2.txt | cut -d ',' -f 1)
species=hs38
prefix=bwa

for i in $GEO
do
	## convert sam file to bam and clean-up
	mkdir -p bam
	## -q: skip alignments with MAPQ smaller than 30.
	samtools view -bhS -q 30 sam/$i.sam > bam/$i.bam
	## sort and index the bam file for quick access.
	samtools sort bam/$i.bam -o bam/$i.srt.bam
	samtools index bam/$i.srt.bam
	## remove un-sorted bam file.
	#rm bam/$prefix.$species.$SRR.bam

	## we remove the duplicated by picard::MarkDuplicates. 
	mkdir -p bam/picard
	picard MarkDuplicates \
	       INPUT=bam/$i.srt.bam \
	       OUTPUT=bam/$i.srt.markDup.bam \
	       METRICS_FILE=bam/picard/$i.srt.fil.picard_info.txt \
	       REMOVE_DUPLICATES=true ASSUME_SORTED=true VALIDATION_STRINGENCY=LENIENT
	samtools index bam/$i.srt.markDup.bam

	## use deeptools::bamCoverage to generate bigwig files
	## the bw file can be viewed in IGV
	mkdir -p bw
	bamCoverage -b bam/$i.srt.markDup.bam -o bw/$i.bw --normalizeUsing CPM

	## call peaks by macs2
	mkdir -p macs2/$i
	## -g: mappable genome size
	## -q: use minimum FDR 0.05 cutoff to call significant regions.
	## -B: ask MACS2 to output bedGraph files for experiment.
	## --nomodel --extsize 150: the subset data is not big enough (<1000 peak) for
	## macs2 to generate a model. We manually feed one.
	## because we used toy genome, the genome size we set as 10M
	macs2 callpeak -t bam/$i.srt.markDup.bam \
		       -f BAM -g hs -n $i \
		       --outdir macs2/$i -q 0.05 \
		       -B
done

