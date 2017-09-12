#!/bin/bash

echo "Running VelvetOptimiser on short test data."

VelvetOptimiser.pl -s 55 -e 59 -f "-shortPaired -fastq.gz -separate data/test_short_R1.fq.gz data/test_short_R2.fq.gz" -d test_out

#echo "Number of contigs in final assembly:"

result1=`grep -c ">" test_out/contigs.fa` 


echo "Running VelvetOptimiser on short and long test data."

VelvetOptimiser.pl -s 73 -e 89 -x 4 -f "-shortPaired -fastq.gz -separate data/test_short_R1.fq.gz data/test_short_R2.fq.gz -longPaired -fastq.gz -separate data/test_long_R1.fq.gz data/test_long_R2.fq.gz" -d test_out_2 -o "-long_mult_cutoff 3"

echo "Number of contigs in final assembly:"

result2=`grep -c ">" test_out_2/contigs.fa`

echo "Estimation of memory test:"

VelvetOptimiser.pl -s 55 -e 59 -f "-shortPaired -fastq.gz -separate data/test_short_R1.fq.gz data/test_short_R2.fq.gz -longPaired -fastq.gz -separate data/test_long_R1.fq.gz data/test_long_R2.fq.gz" -g 0.2 2> mem_est.out

result3=`grep "Memory use estimated to be: -0.2GB for 2 threads." mem_est.out | wc -l`


echo "****************"
echo "Test results"

if [ $result1 -eq 36 ]; then
    echo "Short test data: Passed"
else
    echo "Short test data: Failed"
fi

if [ $result2 -eq 2 ]; then
    echo "Short + long: Passed"
else
    echo "Short + long: Failed"
fi

if [ $result3 -eq 1 ]; then
    echo "Mem est: Passed"
else
    echo "Mem est: Failed"
fi
