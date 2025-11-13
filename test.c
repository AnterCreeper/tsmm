/*
	Example of compiler builtin vector support.
	Below codes will generate almost same instructions.
	
	https://gcc.gnu.org/onlinedocs/gcc/Vector-Extensions.html
*/


typedef double v4f64 __attribute__((__vector_size__(32))); //256

#ifdef X86
#pragma GCC target("avx2,fma,avx512f")

#include <immintrin.h>

void matmul_worker_avx2(double* A, double* B, double* C, int i, int stripe) {
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
    for(int j = 0; j < 4; j++) _mm256_store_pd(&C[i*4+j*16000], Csum[j]);
    return;
}

#endif

static const v4f64 zerov4f64 = {.0, .0, .0, .0};
void matmul_worker(double* A, double* B, double* C, int i, int stripe) {
    v4f64 Csum[4];
    for(int j = 0; j < 4; j++) Csum[j] = zerov4f64;
    for(int j = 0; j < 4; j++) {
        int base = i*4+j*4*16000;
#pragma GCC unroll 4
        for(int k = 0; k < 4; k++) {
            v4f64 B_4 = *(v4f64*)&B[base+k*16000];
            Csum[0] = A[j*128+k*32]   * B_4 + Csum[0];
            Csum[1] = A[j*128+k*32+1] * B_4 + Csum[1];
            Csum[2] = A[j*128+k*32+2] * B_4 + Csum[2];
            Csum[3] = A[j*128+k*32+3] * B_4 + Csum[3];
        }
    }
    for(int j = 0; j < 4; j++) *(v4f64*)&C[i*4+j*16000] = Csum[j];
    return;
}
