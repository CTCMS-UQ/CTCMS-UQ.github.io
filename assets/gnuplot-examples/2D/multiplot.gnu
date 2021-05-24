#!/usr/bin/gnuplot

set xlabel "Theta"
set sample 1000
set key right top outside
set grid ytics

set multiplot layout 2,1 
plot sin(x), sin(2*x)
plot cos(x), cos(2*x)
