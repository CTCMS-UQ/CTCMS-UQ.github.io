#!/usr/bin/gnuplot
load "~/Work/colorblind.gp"
set style increment user
set key bottom right
plot "data1.dat" using 1:2 title "\"data1.dat\""
