#pragma GCC target("sse2")
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include "common.h"
#ifdef _WIN32
#include <windows.h>
#else
#include <sys/time.h>
#endif
#include <time.h>
#include <immintrin.h>
#include <string.h>

int get_cache_size() {
    int size = 0; //in KiB
    FILE *file = fopen("/sys/devices/system/cpu/cpu0/cache/index3/size", "r");
    if(file != NULL) {
        fscanf(file, "%d", &size);
        fclose(file);
        printf("l3_cache_size: %d\n", size);
    } else {
        printf("failed to get L3 cache size\n");
    }
    return size;
}

void prefetch(void* data, size_t size) {
    for(int i = 0; i < size; i+= CACHE_LINE_SIZE) {
        _mm_prefetch(data+i, _MM_HINT_T0);
    }
    return;
}

void flush(void* data, int size) {
    for(int i = 0; i < size; i+= CACHE_LINE_SIZE) {
        _mm_clflushopt(data+i);
    }
    _mm_sfence();
    return;
}

int prepare(double* A, double* B) {
    FILE *fileA = fopen("input_A.bin", "rb");
    if(fileA != NULL && A != NULL) {
        fread(A, sizeof(double), 16*32, fileA);
        fclose(fileA);
        printf("matrix A has been read from input_A.bin\n");
    } else {
        return -1;
    }
    FILE *fileB = fopen("input_B.bin", "rb");
    if(fileB != NULL && B != NULL) {
        fread(B, sizeof(double), 16*16000*W_TEST_MT, fileB);
        fclose(fileB);
        printf("matrix B has been read from input_B.bin\n");
    } else {
        return -1;
    }
    return 0;
}

int writeback(double *C){
    FILE *file = fopen("result_C.bin", "wb");
    if (file != NULL && C != NULL) {
        fwrite(C, sizeof(double), 32*16000, file);
        fclose(file);
        printf("result has been write to result_C.bin\n");
    } else {
        return -1;
    }
    return 0;
}

int check(double *C){
    int code = 0;
    FILE *file = fopen("result_C_std.bin", "rb");
    if (file != NULL && C != NULL) {
        for(int i = 0; i < 32*16000; i++) {
            double C_std;
            fread(&C_std, sizeof(double), 1, file);
            double diff = abs(C[i] - C_std);
            if(diff > MISMATCH_DELTA) {
                printf("mismatch at %d\n", i);
                code = -1;
                break;
            }
        }
        fclose(file);
        printf("result has been fully tested\n");
    } else {
        printf("failed to read std result file\n");
        code = -1;
    }
    return code;
}

static double timestamp;

#ifdef _WIN32
int gettimeofday(struct timeval *tp, void *tzp) {
    time_t clock;
    struct tm tm;
    SYSTEMTIME wtm;
    GetLocalTime(&wtm);
    tm.tm_year  = wtm.wYear - 1900;
    tm.tm_mon   = wtm.wMonth - 1;
    tm.tm_mday  = wtm.wDay;
    tm.tm_hour  = wtm.wHour;
    tm.tm_min   = wtm.wMinute;
    tm.tm_sec   = wtm.wSecond;
    tm.tm_isdst = -1;
    clock = mktime(&tm);
    tp->tv_sec = clock;
    tp->tv_usec = wtm.wMilliseconds * 1000;
    return (0);
}
#endif

double get_time() {
    struct timeval tp;
    gettimeofday(&tp,NULL);
    return ((double)tp.tv_sec+(double)tp.tv_usec*1e-6);
}

void start_perf() {
    timestamp = get_time();
}

double end_perf() {
    timestamp = get_time() - timestamp;
    printf("times: %.6lfs\n", timestamp);
    return timestamp;
}
