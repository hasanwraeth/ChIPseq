#!/bin/bash

#activate right env
#conda activate msa

a1t=macs2/HARK1.rep1/bwa.hs38.HARK1_treat_pileup.bdg
a1c=macs2/HARK1.rep1/bwa.hs38.HARK1_control_lambda.bdg
a2t=macs2/HARK1.rep2/bwa.hs38.HARK2_treat_pileup.bdg
a2c=macs2/HARK1.rep2/bwa.hs38.HARK2_control_lambda.bdg
a3t=macs2/HARK3.rep1/bwa.hs38.HARK3_treat_pileup.bdg
a3c=macs2/HARK3.rep1/bwa.hs38.HARK3_control_lambda.bdg
a4t=macs2/HARK3.rep2/bwa.hs38.HARK4_treat_pileup.bdg
a4c=macs2/HARK3.rep2/bwa.hs38.HARK4_control_lambda.bdg
a5t=macs2/HARK5.rep1/bwa.hs38.HARK5_treat_pileup.bdg
a5c=macs2/HARK5.rep1/bwa.hs38.HARK5_control_lambda.bdg
a6t=macs2/HARK5.rep2/bwa.hs38.HARK6_treat_pileup.bdg
a6c=macs2/HARK5.rep2/bwa.hs38.HARK6_control_lambda.bdg
a7t=macs2/HARK7.rep1/bwa.hs38.HARK7_treat_pileup.bdg
a7c=macs2/HARK7.rep1/bwa.hs38.HARK7_control_lambda.bdg
a8t=macs2/HARK7.rep2/bwa.hs38.HARK8_treat_pileup.bdg
a8c=macs2/HARK7.rep2/bwa.hs38.HARK8_control_lambda.bdg

python SparK.py -cf ${a1c} ${a2c} ${a3c} ${a4c} ${a5c} ${a6c} ${a7c} ${a8c} -tf ${a1t} ${a2t} ${a3t} ${a4t} ${a5t} ${a6t} ${a7t} ${a8t} -pr chr1:155308573-155313782 -tg 1 2 3 4 5 6 7 8 -cg 1 2 3 4 5 6 7 8 -sm 25 -o All30 -gtf gencode.v40.annotation.gtf