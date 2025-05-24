#ifndef __TSMM_COMMON__
#define __TSMM_COMMON__

#define CACHE_LINE_SIZE 64
#define MISMATCH_DELTA 1e-40

int prepare(double* A, double *B);
int writeback(double *C);
int check(double *C);

void start_perf();
void end_perf();

#endif
