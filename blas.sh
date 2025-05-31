#!/bin/bash
if [ -z "$TEST_SIZE" ]; then
  export TEST_SIZE=128
fi
gcc -O3 -march=skylake -DW_TEST_MT=$TEST_SIZE -o ./blas ./blas.c ./common.c -lblas
export OPENBLAS_NUM_THREADS=6
./blas
