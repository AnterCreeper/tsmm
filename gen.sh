#!/bin/bash
#count=16*16000*64/8/512
rm matgen
gcc -Ofast ./gen.c -o ./matgen
./matgen 512 input_A.bin
./matgen 256000 input_B.bin
./blas.sh
mv result_C.bin result_C_std.bin
