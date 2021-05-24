#!/usr/bin/gnuplot
load "~/Work/colorblind.gp"
set style increment user
plot "errorbars1.dat" using 1:2:3 with errorbars title "\"data.dat\""
