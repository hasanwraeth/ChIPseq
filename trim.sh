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
done

