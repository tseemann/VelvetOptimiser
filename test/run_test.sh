#!/bin/bash

echo "Running VelvetOptimiser on test data."

VelvetOptimiser.pl -s 55 -e 59 -f "-shortPaired -fastq.gz -separate mutant_R1.fastq.gz mutant_R2.fastq.gz" -d test_out

echo "Number of contigs in final assembly:"

grep -c ">" test_out/contigs.fa

echo "Estimation of memory test:"

VelvetOptimiser.pl -s 55 -e 59 -f "-shortPaired -fastq.gz -separate mutant_R1.fastq.gz mutant_R2.fastq.gz" -g 0.2