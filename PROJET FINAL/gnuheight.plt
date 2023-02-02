set pm3d interpolate 2,2
set title "Carte interpolée"
set xlabel "Longitude"
set ylabel "Latitude"
set cblabel "Valeur"
set grid
set view map
set size ratio -1
set isosamples 50,50
set sample 50,50
set hidden3d
set datafile separator ";"
set xrange [-180:180]
set zrange [0:1000]
set yrange [-90:90]
set cbrange [0:100]
set palette defined (0 "blue", 1 "cyan", 2 "green", 4 "red")
unset key
splot filename using 4:3:2 with point lc palette  
