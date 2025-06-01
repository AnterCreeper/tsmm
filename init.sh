#!/bin/bash
git submodule init
git submodule update
./install_perf.sh
./gen.sh
