#BSUB -M 128000
#BSUB -W 1440
#BSUB -n 16
#BSUB -R "span[hosts=1]"
#BSUB -q normal
#BSUB -J K3
#BSUB -e /users/reziw3/%J.err
#BSUB -o /users/reziw3/%J.err
module load fastqc

fastqc -o fastqc_out *.fastq
fastqc -o fastqc_out_trim ./fastq.trimmed/*.fq


