#!/bin/bash

echo "Running VelvetOptimiser on short test data."

VelvetOptimiser.pl -s 55 -e 59 -f "-shortPaired -fastq.gz -separate data/test_short_R1.fq.gz data/test_short_R2.fq.gz" -d test_out

echo "Number of contigs in final assembly:"

grep -c ">" test_out/contigs.fa

echo "Running VelvetOptimiser on short and long test data."

VelvetOptimiser.pl -s 43 -e 91 -x 4 -f "-shortPaired -fastq.gz -separate data/test_short_R1.fq.gz data/test_short_R2.fq.gz -longPaired -fastq.gz -separate data/test_long_R1.fq.gz data/test_long_R2.fq.gz" -d test_out_2 -o "-long_mult_cutoff 3"

echo "Number of contigs in final assembly:"

grep -c ">" test_out_2/contigs.fa

echo "Estimation of memory test:"

VelvetOptimiser.pl -s 55 -e 59 -f "-shortPaired -fastq.gz -separate mutant_R1.fq.gz mutant_R2.fq.gz -longPaired -fastq.gz -separate data/test_long_R1.fq.gz data/test_long_R2.fq.gz" -g 0.2
