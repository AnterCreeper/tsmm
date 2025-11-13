#pragma GCC target("avx2,fma")
#define W_OMP_THREADS   6
#define W_TEST_CYC      16384*4 //5.2s on 6x ADL@4.0GHz
//#define W_RAND

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <omp.h>
#include <time.h>
#include <unistd.h>
#include <immintrin.h>

#include "common.h"

void transpose(double* A, double* AA, int i) {
    for(int j = 0; j < 4; j++) {
        int base = i*4+j*4*32;
        __m256d row0 = *(__m256d*)&A[base];
        __m256d row1 = *(__m256d*)&A[base+32];
        __m256d row2 = *(__m256d*)&A[base+64];
        __m256d row3 = *(__m256d*)&A[base+96];
        __m256d t0 = _mm256_shuffle_pd(row0, row1, 0x0);
        __m256d t1 = _mm256_shuffle_pd(row0, row1, 0xf);
        __m256d t2 = _mm256_shuffle_pd(row2, row3, 0x0);
        __m256d t3 = _mm256_shuffle_pd(row2, row3, 0xf);
        *(__m256d*)&AA[j*4] = _mm256_permute2f128_pd(t0, t2, 0x20);
        *(__m256d*)&AA[j*4+16] = _mm256_permute2f128_pd(t1, t3, 0x20);
        *(__m256d*)&AA[j*4+32] = _mm256_permute2f128_pd(t0, t2, 0x31);
        *(__m256d*)&AA[j*4+48] = _mm256_permute2f128_pd(t1, t3, 0x31);
    }
    return;
}

static inline void matmul_worker_row(double* A, double* B, double* C, int i, int stripe) {
    __m256d Csum[4];
    for(int j = 0; j < 4; j++) Csum[j] = _mm256_setzero_pd();
    for(int j = 0; j < 4; j++) {
        int base = i*4+j*4*16000;
#pragma GCC unroll 4
        for(int k = 0; k < 4; k++) {
            __m256d B_4 = *(__m256d*)&B[base+k*16000];
            __m256d A1 = _mm256_broadcast_sd(&A[j*128+k*32]);
            __m256d A2 = _mm256_broadcast_sd(&A[j*128+k*32+1]);
            __m256d A3 = _mm256_broadcast_sd(&A[j*128+k*32+2]);
            __m256d A4 = _mm256_broadcast_sd(&A[j*128+k*32+3]);
            Csum[0] = _mm256_fmadd_pd(A1, B_4, Csum[0]);
            Csum[1] = _mm256_fmadd_pd(A2, B_4, Csum[1]);
            Csum[2] = _mm256_fmadd_pd(A3, B_4, Csum[2]);
            Csum[3] = _mm256_fmadd_pd(A4, B_4, Csum[3]);
        }
    }
    //stream store show poor performance
    for(int j = 0; j < 4; j++) _mm256_store_pd(&C[i*4+j*16000], Csum[j]);
    return;
}

/*
__m256d matmul_worker_column(double* A, double* B) { //A[4][16] B[16]
    __m256d R[4];
    __m256d B0 = _mm256_load_pd[0];
    __m256d B1 = _mm256_load_pd[4];
    __m256d B2 = _mm256_load_pd[8];
    __m256d B3 = _mm256_load_pd[12];
    for(int i = 0; i < 4; i++) {
        __m256d* vA = (__m256d*)&A[i*16];
        __m256d C0 = _mm256_mul_pd(vA[0], B0);
        __m256d C1 = _mm256_mul_pd(vA[1], B1);
        __m256d C2 = _mm256_mul_pd(vA[2], B2);
        __m256d C3 = _mm256_mul_pd(vA[3], B3);
        __m256d Csum0 = _mm256_add_pd(C0, C1);
        __m256d Csum1 = _mm256_add_pd(C2, C3);
        R[i] = _mm256_add_pd(Csum0, Csum1);
    }
    return;
}
*/

#define min(A, B) ((A) < (B) ? (A) : (B))

void matmul_row(double* C, double* A, double* B) {
#pragma omp parallel num_threads(W_OMP_THREADS)
{
    int start = omp_get_thread_num();
    int stripe = omp_get_num_threads();
    //int begin = (2000/stripe+1)*start*2;
    //int end = min((2000/stripe+1)*(start+1)*2, 4000);
    //for(int j = begin; j < end; j += 2)
    for(int j = start*2; j < 4000; j += stripe*2)
    for(int i = 0; i < 8; i += 1) { //reuse B
        matmul_worker_row(&A[i*4], B, &C[i*64000], j, stripe);
        matmul_worker_row(&A[i*4], B, &C[i*64000], j+1, stripe);
    }
}
    return;
}

/*
void matmul_column(double* C, double* A, double* B) {
#pragma omp parallel num_threads(W_OMP_THREADS)
{
    int start = omp_get_thread_num();
    int stripe = omp_get_num_threads();
    for(int j = start; j < 16000; j += stripe)
    for(int i = 0; i < 32; i += 4) {
        __m256d result = matmul_worker_column(&A[i*16], &B[j*16]);
        _mm256_store_pd(&C[j*32+i], result);
    }
}
    return;
}
*/

int main() {
    double *A, *B, *C;
    posix_memalign((void**)&A, CACHE_LINE_SIZE, 16*32*sizeof(double));
    posix_memalign((void**)&B, CACHE_LINE_SIZE, 16*16000*sizeof(double)*W_TEST_MT);
    posix_memalign((void**)&C, CACHE_LINE_SIZE, 32*16000*sizeof(double));

    if(prepare(A, B)) {
        printf("failed to open file while reading data\n");
        return -1;
    }

    //generate non-repetitive random numbers
    time_t t;
    srand((unsigned)time(&t));
    int rnd[W_TEST_MT] = {0};
    for(int i = 0; i < W_TEST_MT; i++) {
        int x;
        while(rnd[x=rand()%W_TEST_MT]);
        rnd[x] = i;
    }

    printf("start benchmark %d rounds\n", W_TEST_CYC);
    start_perf();
    for(int i = 0; i < W_TEST_CYC; i++) {
#ifdef W_RAND
	int pos = rnd[i%W_TEST_MT];
#else
	int pos = i%W_TEST_MT;
#endif
        matmul_row(C, A, &B[pos*16*16000]);
    }
    end_perf();

    if(writeback(C)) {
        printf("failed to write result to file\n");
        return -1;
    }
#ifndef W_RAND
    if(check(C)) {
        printf("result test failed\n");
        return -1;
    }
#endif

    free(A);
    free(B);
    free(C);
    return 0;
}
