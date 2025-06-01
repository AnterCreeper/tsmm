export TEST_SIZE=512
export USING_MKL=1
./blas.sh $1
./build.sh $1
unset MKL_DEBUG_CPU_TYPE
export MKL_ENABLE_INSTRUCTIONS=AVX512
export OPENBLAS_NUM_THREADS=$1
srun --exclusive -N 1 -n 1 --cpus-per-task=$1 --cpu-bind=ldoms --mem-bind=local perf record -o perf.data ./blas
srun --exclusive -N 1 -n 1 --cpus-per-task=$1 --cpu-bind=ldoms --mem-bind=local ./openmp_example
