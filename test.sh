#!/bin/bash
./build.sh 6
./openmp_example
perf record -F 999 ./openmp_example
perf stat ./openmp_example
perf stat -a -M DRAM_BW_Use -M L1D_Cache_Fill_BW -M L2_Cache_Fill_BW -M L3_Cache_Access_BW -M L3_Cache_Fill_BW ./openmp_example
perf stat -M GFLOPs -M ILP -M FP_Arith_Utilization ./openmp_example
perf stat -a -e cache-references,cache-misses -M L1MPKI -M L2MPKI -M L3MPKI -M DRAM_BW_Use ./openmp_example
./pmu-tools/toplev.py -v --drilldown --cputype core ./openmp_example
./pmu-tools/toplev.py -v -l4 --cputype core ./openmp_example
