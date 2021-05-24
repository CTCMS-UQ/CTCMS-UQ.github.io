#!/usr/bin/gnuplot
load "~/Work/colorblind.gp"
set style increment user
plot "errorbars2.dat" using 1:2:3:4 with errorbars title "\"data.dat\""
