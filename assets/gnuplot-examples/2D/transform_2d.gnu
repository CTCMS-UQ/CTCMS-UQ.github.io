#!/usr/bin/gnuplot
load "~/Work/colorblind.gp"
set style increment user
set xlabel "t"
set ylabel "x*y"
plot "data2.dat" using 1:($2 * $3) title ""
