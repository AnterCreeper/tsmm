static inline void matmul_worker_row(double* A, double* B, double* C, int i, int stripe) {
    __m256d Csum[4];
    for(int j = 0; j < 4; j++) Csum[j] = _mm256_setzero_pd();
    for(int j = 0; j < 4; j++) {
        int base = i*4+j*4*16000;
#pragma GCC unroll 4
        for(int k = 0; k < 4; k++) {
            __m256d B_4 = *(__m256d*)&B[base+k*16000];
            //_mm_prefetch(&B[base+k*16000+stripe*8], _MM_HINT_NTA);
            /* As _mm256_shuffle_pd/_mm256_unpackXX_pd/_mm256_permute_pd/_mm256_permute4x64_pd could only be issued
             * at Port 5 with 1 cycle latency, so would be slower than using vbroadcastsd(_mm256_broadcast_sd) which
             * don't need ALU.
             *
            __m256d A_4L = _mm256_broadcast_pd((__m128d*)&A[j*128+k*32]);
            __m256d A_4H = _mm256_broadcast_pd((__m128d*)&A[j*128+k*32+2]);
            __m256d A1 = _mm256_unpacklo_pd(A_4L, A_4L);
            __m256d A2 = _mm256_unpackhi_pd(A_4L, A_4L);
            __m256d A3 = _mm256_unpacklo_pd(A_4H, A_4H);
            __m256d A4 = _mm256_unpackhi_pd(A_4H, A_4H);
            */
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
    //stream show poor performance
    for(int j = 0; j < 4; j++) _mm256_store_pd(&C[i*4+j*16000], Csum[j]);
    return;
}

#define min(A, B) ((A) < (B) ? (A) : (B))

void matmul_row(double* C, double* A, double* B) {
#pragma omp parallel num_threads(W_OMP_THREADS)
{
    int start = omp_get_thread_num();
    int stripe = omp_get_num_threads();
    for(int j = start*2; j < 4000; j += stripe*2)
    for(int i = 0; i < 8; i += 1) { //reuse B
        matmul_worker_row(&A[i*4], B, &C[i*64000], j, stripe);
        matmul_worker_row(&A[i*4], B, &C[i*64000], j+1, stripe);
    }
}
    return;
}
