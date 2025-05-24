#pragma GCC target("avx2,fma")
//#define W_MPI
#define W_MPI_MAXSIZE   1024

#ifndef SLICE_SIZE
#ifdef W_MPI
#define SLICE_SIZE      500
#define WORKER_SIZE     4*SLICE_SIZE
#else
#define SLICE_SIZE      1
#define WORKER_SIZE     16000
#endif
#endif

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
#ifdef W_MPI
#include <mpi.h>
#endif
#include <unistd.h>
#include <immintrin.h>

#include "common.h"

void transpose(double* A, double* B0, double* B1, double* B2, double* B3, int i) {
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

__m256d matmul_worker(double* A, double* B, int i) {
        __m256d Csum = _mm256_setzero_pd();
        for(int j = 0; j < 4; j++) {
            __m256d A_4 = *(__m256d*)&A[j*4];
            __m256d M1 = _mm256_permute4x64_pd(A_4, 0x00); //boardcase A[j*4] to full vector.
            __m256d M2 = _mm256_permute4x64_pd(A_4, 0x55);
            __m256d M3 = _mm256_permute4x64_pd(A_4, 0xaa);
            __m256d M4 = _mm256_permute4x64_pd(A_4, 0xff);
            int base = i*4+j*4*WORKER_SIZE;
            __m256d N1 = *(__m256d*)&B[base];
            __m256d N2 = *(__m256d*)&B[base+WORKER_SIZE];
            __m256d N3 = *(__m256d*)&B[base+2*WORKER_SIZE];
            __m256d N4 = *(__m256d*)&B[base+3*WORKER_SIZE];
            Csum = _mm256_fmadd_pd(M1, N1, Csum);
            Csum = _mm256_fmadd_pd(M2, N2, Csum);
            Csum = _mm256_fmadd_pd(M3, N3, Csum);
            Csum = _mm256_fmadd_pd(M4, N4, Csum);
        }
        return Csum;
}

void matmul(double* C, double* A, double* B) {
    for(int i = 0; i < 8; i++) {
        double At[4][16];
        transpose(A, At[0], At[1], At[2], At[3], i);
        printf("A[0]: %lf\n", At[0][0]);
        for(int j = 0; j < 4000; j++) {
            int base = i*64000+j*4;
            *(__m256d*)&C[base] = matmul_worker(At[0], B, j);
            *(__m256d*)&C[base+16000] = matmul_worker(At[1], B, j);
            *(__m256d*)&C[base+32000] = matmul_worker(At[2], B, j);
            *(__m256d*)&C[base+48000] = matmul_worker(At[3], B, j);
        }
    }
	return;
}

#ifdef W_MPI
void mpi_r0_issue(int size, int* child, double** dst, MPI_Request* req0, MPI_Request* req1, double* At, double* Bt[16], double* C) {
    if(*dst) {
        MPI_Wait(req0, MPI_STATUS_IGNORE);
        MPI_Wait(req1, MPI_STATUS_IGNORE);
        MPI_Recv(*dst, 4*SLICE_SIZE, MPI_DOUBLE, *child, 2, MPI_COMM_WORLD, MPI_STATUS_IGNORE);
    }
    MPI_Isend(At, 16, MPI_DOUBLE, *child, 0, MPI_COMM_WORLD, req0);
    for(int i = 0; i < 16; i++) {
        MPI_Isend(Bt[i], 4*SLICE_SIZE, MPI_DOUBLE, *child, 1, MPI_COMM_WORLD, req1);
    }
    *dst = C;
    *child = *child == size - 1 ? 1 : *child + 1;
    return;
}

void mpi_data_filler(double** Bt, double* B, int j) {
    for(int i = 0; i < 16; i++) {
        Bt[i] = &B[i*16000+j*4*SLICE_SIZE];
    }
    return;
}

void mpi_r0_worker(int rank, int size, double* C, double* A, double* B) {
    MPI_Request mpi_req0[W_MPI_MAXSIZE];
    MPI_Request mpi_req1[W_MPI_MAXSIZE];
    double* result[W_MPI_MAXSIZE];
    memset(result, 0, sizeof(result));

    int child = 1;
    double* Bt[16*(4*SLICE_SIZE)] __attribute__ ((aligned(32)));
    for(int i = 0; i < 8; i++) {
        double At[4][16] __attribute__ ((aligned(32)));
        transpose(A, At[0], At[1], At[2], At[3], i);
        for(int j = 0; j < 4000/SLICE_SIZE; j++) {
            int base = i*64000+j*4*SLICE_SIZE;
            mpi_data_filler(Bt, B, j);
            mpi_r0_issue(size, &child, &result[child], &mpi_req0[child], &mpi_req1[child], At[0], Bt, &C[base]);
            mpi_r0_issue(size, &child, &result[child], &mpi_req0[child], &mpi_req1[child], At[1], Bt, &C[base+16000]);
            mpi_r0_issue(size, &child, &result[child], &mpi_req0[child], &mpi_req1[child], At[2], Bt, &C[base+32000]);
            mpi_r0_issue(size, &child, &result[child], &mpi_req0[child], &mpi_req1[child], At[3], Bt, &C[base+48000]);
        }
    }
    for(int child = 1; child < size; child++) {
        if(result[child]) {
            MPI_Wait(&mpi_req0[child], MPI_STATUS_IGNORE);
            MPI_Wait(&mpi_req1[child], MPI_STATUS_IGNORE);
            MPI_Recv(result[child], 4*SLICE_SIZE, MPI_DOUBLE, child, 2, MPI_COMM_WORLD, MPI_STATUS_IGNORE);
        }
    }
    return;
}

#define WORKLOAD    32*16000/SLICE_SIZE/4

void mpi_rn_worker(int rank, int size) {
    MPI_Request req;
    int start = rank - 1;
    int stripe = size - 1;
    for(int i = start; i < WORKLOAD; i = i + stripe) {
        double A[16] __attribute__ ((aligned(32)));
        double B[16*4*SLICE_SIZE] __attribute__ ((aligned(32)));
        __m256d C[SLICE_SIZE];
        MPI_Recv(A, 16, MPI_DOUBLE, 0, 0, MPI_COMM_WORLD, MPI_STATUS_IGNORE);
        for(int j = 0; j < 16; j++) {
            MPI_Recv(&B[j*4*SLICE_SIZE], 4*SLICE_SIZE, MPI_DOUBLE, 0, 1, MPI_COMM_WORLD, MPI_STATUS_IGNORE);
        }
        for(int j = 0; j < SLICE_SIZE; j++) {
            C[j] = matmul_worker(A, B, j);
        }
        MPI_Isend(&C, 4*SLICE_SIZE, MPI_DOUBLE, 0, 2, MPI_COMM_WORLD, &req);
    }
    return;
}
#endif

int main(int argc, char *argv[]) {
    double *A, *B, *C;
    posix_memalign((void**)&A, CACHE_LINE_SIZE, 16*32*sizeof(double));
    posix_memalign((void**)&B, CACHE_LINE_SIZE, 16*16000*sizeof(double));
    posix_memalign((void**)&C, CACHE_LINE_SIZE, 32*16000*sizeof(double));
#ifdef W_MPI
    int rank, size;
    double start_time, end_time;
    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);

    if (size > W_MPI_MAXSIZE) {
        printf("too many cores, need increase W_MPI_MAXSIZE macro");
        exit(-1);
    }
    if (rank == 0) {
        if(prepare(A, B)) {
            printf("failed to open file while reading data\n");
            return -1;
        }
    }

    MPI_Barrier(MPI_COMM_WORLD);
    start_time = MPI_Wtime();

    if (rank == 0) {
        mpi_r0_worker(rank, size, C, A, B);
    } else {
        mpi_rn_worker(rank, size);
    }

    MPI_Barrier(MPI_COMM_WORLD);
    end_time = MPI_Wtime();

    if (rank == 0) {
        printf("times: %.6lfs\n", end_time - start_time);
        if(writeback(C)) {
            printf("failed to write result to file\n");
            return -1;
        }
        if(check(C)) {
            printf("result test failed\n");
            return -1;
        }
    }
    MPI_Finalize();

#else
    if(prepare(A, B)) {
        printf("failed to open file while reading data\n");
        return -1;
    }
    start_perf();
    matmul(C, A, B);
    end_perf();
    if(writeback(C)) {
        printf("failed to write result to file\n");
        return -1;
    }
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
