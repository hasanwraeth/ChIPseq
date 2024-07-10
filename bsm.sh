#!/bin/bash

#activate right env
#conda activate msa

a1t=Smith/macs2/SRR1642055/SRR1642055_treat_pileup.bdg
a1c=Smith/macs2/SRR1642055/SRR1642055_control_lambda.bdg
a2t=Smith/macs2/SRR1642058/SRR1642058_treat_pileup.bdg
a2c=Smith/macs2/SRR1642058/SRR1642058_control_lambda.bdg
a3t=Smith/macs2/SRR1642059/SRR1642059_treat_pileup.bdg
a3c=Smith/macs2/SRR1642059/SRR1642059_control_lambda.bdg

python SparK.py -cf ${a1c} ${a2c} ${a3c} -tf ${a1t} ${a2t} ${a3t} -pr chr5:42518541-42739200 -tg 1 2 3 -cg 1 2 3 -sm 25 -o All40 -gtf gencode.v40.annotation.gtf
#chr14:74057219-74112433
#chr20:34812612-34928144
#chr16:72060091-72079122
#chr20:44324401-44497982
#chr20:44368514-44519095
#chr3:41178381-41241197
#chr4:1684534-1713917
#chr10:4962727-4986530
#chr5:42533541-42739200
#chr5:42518541-42739200