#!/bin/bash
#mpicc -Wall -Werror -std=c99 -Ofast -DW_MPI -o ./mpi_example ./mpi.c ./common.c
#O2 is better than O3 & Ofast
gcc -Wall -Werror -std=c99 -O2 -fopenmp -o ./openmp_example ./omp.c ./common.c
gcc -Wall -Werror -std=c99 -O2 -fopenmp -S ./omp.c ./common.c
