#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#include <time.h>
#include <math.h>
#include <cblas.h>
#include "common.h"

//#define W_RAND

#ifndef W_TEST_CYC
#define W_TEST_CYC      16384*4
#endif

void rowfirst(double* C, double* A, double* B){
    for(int i = 0; i < 32; i++)
    for(int j = 0; j < 16000; j++) {
        double sum = 0;
        for(int k = 0; k < 16; k++) sum += A[k*32+i] * B[k*16000+j];
        //for(int k = 0; k < 16; k++) sum = fma(A[k*32+i], B[k*16000+j], sum);
        C[i*16000+j] = sum;
    }
    return;
}

void columnfirst(double* C, double* A, double* B){
    for(int i = 0; i < 32; i++)
    for(int j = 0; j < 16000; j++) {
        double sum = 0;
        for(int k = 0; k < 16; k++) sum += A[i*16+k] * B[j*16+k];
        C[i+j*32] = sum;
    }
    return;
}

#define rowfirst_blas(C,A,B) cblas_dgemm(CblasRowMajor, CblasTrans, CblasNoTrans, 32, 16000, 16, 1.0, A, 32, B, 16000, 0.0, C, 16000);
#define columnfirst_blas(C,A,B) cblas_dgemm(CblasColMajor, CblasTrans, CblasNoTrans, 32, 16000, 16, 1.0, A, 32, B, 16000, 0.0, C, 16000);

int main(){
    double *A, *B, *C;
    posix_memalign((void**)&A, CACHE_LINE_SIZE, 16*32*sizeof(double));
    posix_memalign((void**)&B, CACHE_LINE_SIZE, 16*16000*sizeof(double)*W_TEST_MT);
    posix_memalign((void**)&C, CACHE_LINE_SIZE, 32*16000*sizeof(double));

    if(prepare(A, B)) {
        printf("failed to open file while reading data\n");
        return -1;
    }
    time_t t;
    srand((unsigned)time(&t));
    int rng[W_TEST_MT] = {0};
    for(int i = 0; i < W_TEST_MT; i++) {
        int x;
        while(rng[x=rand()%W_TEST_MT]);
        rng[x] = i;
    }

    printf("start benchmark %d rounds\n", W_TEST_CYC);
    start_perf();
    for(int i = 0; i < W_TEST_CYC; i++) {
#ifdef W_RAND
        int pos = rng[i%W_TEST_MT];
#else
        int pos = i%W_TEST_MT;
#endif
        rowfirst_blas(C, A, &B[pos*16*16000]);
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
