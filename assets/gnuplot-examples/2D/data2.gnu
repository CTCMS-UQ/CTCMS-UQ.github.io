#!/usr/bin/gnuplot
load "~/Work/colorblind.gp"
set style increment user
set xlabel "t"
plot "data2.dat" using 1:2 title "\"data1.dat\"", "errorbars1.dat" using 1:2:3 with errorbars title \
"\"data2\""

