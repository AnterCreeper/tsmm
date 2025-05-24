#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>

int main(int argc, char *argv[]) {
    if (argc < 3) {
        printf("Usage: %s <size> <output_file>\n", argv[0]);
        return 1;
    }

    const int length = atoi(argv[1]);
    const char *output_file = argv[2];

    double* data = malloc(sizeof(double)*length);

    int i = 0;
    FILE *rng = fopen("/dev/random", "rb");
    while(i < length) {
        uint64_t n;
        fread(&n, sizeof(uint64_t), 1, rng);
        uint64_t m = (n >> 12) | (1023ULL << 52);
        double sign = (n & 0x1) ? -1.0 : 1.0;
        double g = *(double*)&m;
        double k = sign * (g - 1.0);
        if(k == 0.0) continue;
        if(k > 1.0 || k < -1.0) printf("err number: %lf\n", k);
        data[i++] = k;
    }

    FILE *file = fopen(output_file, "wb");
    if (file != NULL) {
        fwrite(data, sizeof(double), length, file);
        fclose(file);
        printf("Matrix has been written to %s\n", output_file);
    } else {
        printf("error while opening file\n");
    }
    return 0;
}
