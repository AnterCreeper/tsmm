#!/bin/bash
#mpicc -Wall -Werror -std=c99 -Ofast -DW_MPI -o ./mpi_example ./mpi.c ./common.c
#O2 is better than O3 & Ofast
if [ -z "$TEST_SIZE" ]; then
  export TEST_SIZE=128
fi
gcc -Wall -Werror -std=c99 -march=skylake -DW_TEST_MT=$TEST_SIZE -O2 -fopenmp -o ./openmp_example ./omp.c ./common.c
gcc -Wall -Werror -std=c99 -march=skylake -DW_TEST_MT=$TEST_SIZE -O2 -fopenmp -S ./omp.c ./common.c
