#pragma GCC target("avx2,fma")
#define W_OMP_THREADS   6
#define W_TEST_CYC      16384*4

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <omp.h>
#include <unistd.h>
#include <immintrin.h>

#include "common.h"

static inline void transpose(double* A, double* B0, double* B1, double* B2, double* B3, int i) {
    for(int j = 0; j < 4; j++) {
        int base = i*4+j*128;
        __m256d row0 = *(__m256d*)&A[base];
        __m256d row1 = *(__m256d*)&A[base+32];
        __m256d row2 = *(__m256d*)&A[base+64];
        __m256d row3 = *(__m256d*)&A[base+96];
        __m256d t0 = _mm256_unpacklo_pd(row0, row1);
        __m256d t1 = _mm256_unpackhi_pd(row0, row1);
        __m256d t2 = _mm256_unpacklo_pd(row2, row3);
        __m256d t3 = _mm256_unpackhi_pd(row2, row3);
        *(__m256d*)&B0[j*4] = _mm256_permute2f128_pd(t0, t2, 0x20);
        *(__m256d*)&B1[j*4] = _mm256_permute2f128_pd(t1, t3, 0x20);
        *(__m256d*)&B2[j*4] = _mm256_permute2f128_pd(t0, t2, 0x31);
        *(__m256d*)&B3[j*4] = _mm256_permute2f128_pd(t1, t3, 0x31);
    }
}

static inline __m256d matmul_worker(double* A, double* B, int i) {
    __m256d Csum = _mm256_setzero_pd();
    for(int j = 0; j < 4; j++) {
        __m256d A_4 = *(__m256d*)&A[j*4];
        __m256d M1 = _mm256_permute4x64_pd(A_4, 0x00); //boardcase A[j*4] to full vector.
        __m256d M2 = _mm256_permute4x64_pd(A_4, 0x55);
        __m256d M3 = _mm256_permute4x64_pd(A_4, 0xaa);
        __m256d M4 = _mm256_permute4x64_pd(A_4, 0xff);
        int base = i*4+j*4*16000;
        __m256d N1 = *(__m256d*)&B[base];
        __m256d N2 = *(__m256d*)&B[base+16000];
        __m256d N3 = *(__m256d*)&B[base+2*16000];
        __m256d N4 = *(__m256d*)&B[base+3*16000];
        Csum = _mm256_fmadd_pd(M1, N1, Csum);
        Csum = _mm256_fmadd_pd(M2, N2, Csum);
        Csum = _mm256_fmadd_pd(M3, N3, Csum);
        Csum = _mm256_fmadd_pd(M4, N4, Csum);
    }
    return Csum;
}

void matmul(double* C, double* A, double* B) {
    for(int i = 0; i < 8; i++) {
        double At[4][16] __attribute__ ((aligned(CACHE_LINE_SIZE)));
        transpose(A, At[0], At[1], At[2], At[3], i);
#pragma omp parallel num_threads(W_OMP_THREADS)
{
        int start = omp_get_thread_num();
        int stripe = omp_get_num_threads();
        for(int j = start*2; j < 4000; j += stripe*2)
        for(int k = 0; k < 4; k++) {
            int base = i*64000+j*4+k*16000;
            _mm256_stream_pd(&C[base], matmul_worker(At[k], B, j));
            _mm256_stream_pd(&C[base+4], matmul_worker(At[k], B, j+1));
        }
}
    }
	return;
}

int main() {
    double *A, *B, *C;
    posix_memalign((void**)&A, CACHE_LINE_SIZE, 16*32*sizeof(double));
    posix_memalign((void**)&B, CACHE_LINE_SIZE, 16*16000*sizeof(double));
    posix_memalign((void**)&C, CACHE_LINE_SIZE, 32*16000*sizeof(double));
    if(prepare(A, B)) {
        printf("failed to open file while reading data\n");
        return -1;
    }

    start_perf();
    for(int i = 0; i < W_TEST_CYC; i++) matmul(C, A, B);
    end_perf();

    if(writeback(C)) {
        printf("failed to write result to file\n");
        return -1;
    }
    if(check(C)) {
        printf("result test failed\n");
        return -1;
    }
    free(A);
    free(B);
    free(C);
    return 0;
}
