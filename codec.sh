#BSUB -M 128000
#BSUB -W 1440
#BSUB -n 16
#BSUB -R "span[hosts=1]"
#BSUB -q normal
#BSUB -J K3
#BSUB -e /users/reziw3/%J.err
#BSUB -o /users/reziw3/%J.err
module load trimgalore

GEO=$(tail -n +2 SraRunTable2.txt | cut -d ',' -f 1)
species=hs38
prefix=bwa

for i in $GEO
do
	## trim adapter, need trim_galore be installed, here we do not do this step
	mkdir -p fastq.trimmed
	trim_galore -q 15 --fastqc -o fastq.trimmed/ $i.fastq

	## mapping by bwa
	mkdir -p sam
	## -t: number of threads
	## -M: mark shorter split hits as secondary, this is optional for Picard compatibility.
	## >: save alignment to a SAM file
	## 2>: save standard error to log file
	bwa mem -M -t 4 GRCh38_Ensembl_106 \
		   fastq.trimmed/$SRR1 fastq.trimmed/$SRR2 \
		   > sam/$prefix.$species.$SRR.sam \
		   2> bwa.$prefix.$species.$SRR.log.txt

	## convert sam file to bam and clean-up
	mkdir -p bam
	## -q: skip alignments with MAPQ samller than 30.
	samtools view -bhS -q 30 sam/$prefix.$species.$SRR.sam > bam/$prefix.$species.$SRR.bam
	## sort and index the bam file for quick access.
	samtools sort bam/$prefix.$species.$SRR.bam -o bam/$prefix.$species.${tag[$i]}.srt.bam
	samtools index bam/$prefix.$species.$SRR.srt.bam
	## remove un-sorted bam file.
	rm bam/$prefix.$species.$SRR.bam

	## we remove the duplicated by picard::MarkDuplicates. 
	mkdir -p bam/picard
	picard MarkDuplicates \
	       INPUT=bam/$prefix.$species.$SRR.srt.bam \
	       OUTPUT=bam/$prefix.$species.$SRR.srt.markDup.bam \
	       METRICS_FILE=bam/picard/$prefix.$species.$SRR.srt.fil.picard_info.txt \
	       REMOVE_DUPLICATES=true ASSUME_SORTED=true VALIDATION_STRINGENCY=LENIENT
	samtools index bam/$prefix.$species.$SRR.srt.markDup.bam

	## use deeptools::bamCoverage to generate bigwig files
	## the bw file can be viewed in IGV
	mkdir -p bw
	bamCoverage -b bam/$prefix.$species.$SRR.srt.markDup.bam -o bw/$prefix.$species.$SRR.bw --normalizeUsing CPM

	## call peaks by macs2
	mkdir -p macs2/$SRR
	## -g: mappable genome size
	## -q: use minimum FDR 0.05 cutoff to call significant regions.
	## -B: ask MACS2 to output bedGraph files for experiment.
	## --nomodel --extsize 150: the subset data is not big enough (<1000 peak) for
	## macs2 to generate a model. We manually feed one.
	## because we used toy genome, the genome size we set as 10M
	macs2 callpeak -t 4 bam/${prefix}.$species.$SRR.srt.markDup.bam \
		       -f BAM -g 10e6 -n ${prefix}.$species.$SRR \
		       --outdir macs2/$SRR -q 0.05 \
		       -B --nomodel --extsize 150

done

