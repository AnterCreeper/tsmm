#!/bin/bash
#export USING_MKL=1
if [ -z "$TEST_SIZE" ]; then
  export TEST_SIZE=128
fi
export BLASROOT=/public1/soft/openblas/0.3.17
if [ -z "$USING_MKL" ]; then
gcc -O3 -I${BLASROOT}/include -L${BLASROOT}/lib -march=skylake -DW_OMP_THREADS=$1 -DW_TEST_MT=$TEST_SIZE -o ./blas ./blas.c ./common.c -lopenblas
else
gcc -O3 -march=skylake -DW_MKL -DW_OMP_THREADS=$1 -DW_TEST_MT=$TEST_SIZE -I${MKLROOT}/include -L${MKLROOT}/lib/intel64 -lmkl_intel_lp64 -lmkl_intel_thread -lpthread -lmkl_core -lm -liomp5 -o ./blas ./blas.c ./common.c
fi
