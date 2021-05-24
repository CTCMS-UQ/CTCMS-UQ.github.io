#load "~/Work/colorblind.gp"
#set style increment user

set xlabel "Timestep"
set ylabel "E (LJ-units)"
set title "Kinetic vs potential energy for LJ fluid under shear"

set key center top

# Standard plot
plot "MD_energy.dat" using 1:3 with lines title "Kinetic energy" dashtype 3, \
"MD_energy.dat" using 1:4 with lines title "Potential energy" dashtype 3, \
"MD_energy.dat" using 1:($3 + $4) with lines title "Total energy", \
"MD_energy.dat" using 1:3 with lines title "Smoothed data" smooth bezier linecolor "#595959", \
"MD_energy.dat" using 1:4 with lines title "" smooth bezier linecolor "#595959" 

