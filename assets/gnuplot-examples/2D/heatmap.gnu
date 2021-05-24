#!/usr/bin/gnuplot

set view map
set pm3d interpolate 0,0
splot "heatmap.dat" matrix with image title ""
