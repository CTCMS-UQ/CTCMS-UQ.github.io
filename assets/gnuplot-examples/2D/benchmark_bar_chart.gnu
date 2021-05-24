#!/usr/bin/gnuplot

set xlabel "Benchmark name"
set ylabel "Walltime(s)"
set title "Compiler benchmark for NPB Fortran benchmark suite"
set key top left

set style data histogram
set style histogram cluster gap 1
set style fill solid
set boxwidth 0.9

plot "benchmarks.dat" using 2:xtic(1) title "gfortran", \
"benchmarks.dat" using 3 title "gfortran + SIMD" , \
"benchmarks.dat" using 4:xtic(1) title "Intel fortran" , \
"benchmarks.dat" using 5:xtic(1) title "Intel fortran + SIMD" 
