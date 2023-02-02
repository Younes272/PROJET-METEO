set grid
set title 'Barre d''erreur'
set xlabel 'Station/Date'
set ylabel 'Meteo'
set style histogram errorbars
set datafile separator ";"
set cbrange [0:33]
unset key
set style fill transparent solid 0.35 noborder
set terminal wxt
set output 'mmm.png' 
set label 'Date' at 15, 105
plot filename using 1:4:3:2 w errorbar linetype 0 lc 7,'' using 1:4 with linespoint lt 18 lc 18,'' using 1:2:3 with filledcurves  

 
