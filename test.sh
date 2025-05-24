#!/bin/bash
./build.sh
./openmp_example
perf record -F 999 ./openmp_example
perf stat ./openmp_example
perf stat -M GFLOPs -M ILP -M FP_Arith_Utilization ./openmp_example
perf stat -a -e cache-references,cache-misses -M L1MPKI -M L2MPKI -M L3MPKI ./openmp_example
./pmu-tools/toplev.py -v --drilldown -a ./openmp_example
