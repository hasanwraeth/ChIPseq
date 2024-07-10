#BSUB -M 128000
#BSUB -W 1440
#BSUB -n 16
#BSUB -R "span[hosts=1]"
#BSUB -q normal
#BSUB -J K3
#BSUB -e /users/reziw3/%J.err
#BSUB -o /users/reziw3/%J.err
module load bwa

GEO=$(tail -n +2 SraRunTable2.txt | cut -d ',' -f 1)
species=hs38
prefix=bwa

for i in $GEO
do
	bwa mem -M -t 8 GRCh38_Ensembl_106 \
		   $i.fastq \
		   > sam/$i.sam \
		   2> bwa.$i.log.txt
done

