#ifndef __TSMM_COMMON__
#define __TSMM_COMMON__

#ifndef W_TEST_MT
#define W_TEST_MT       16
#endif
#define CACHE_LINE_SIZE 64
#define MISMATCH_DELTA 1e-40

void prefetch(void* data, size_t size);
int prepare(double* A, double *B);
int writeback(double *C);
int check(double *C);

void start_perf();
double end_perf();

#endif
