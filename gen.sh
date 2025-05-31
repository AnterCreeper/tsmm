#!/bin/bash
#count=16*16000*64/8/512
export TEST_SIZE=128
rm matgen
gcc -Ofast ./gen.c -o ./matgen
./matgen 512 input_A.bin
./matgen $((256000*TEST_SIZE)) input_B.bin
gcc -O2 -march=skylake -DW_TEST_MT=$TEST_SIZE -DW_TEST_CYC=$TEST_SIZE -o ./blas ./blas.c ./common.c -lblas
./blas
mv result_C.bin result_C_std.bin
