#!/bin/bash
gcc -O2 -o ./blas ./blas.c ./common.c -lblas
export OPENBLAS_NUM_THREADS=6
./blas
