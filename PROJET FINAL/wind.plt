set origin 0,0
set angles degrees
set xrange [-180:180]
set yrange [-90:90]
set colorbox vertical origin screen 0.9, 0.2 size screen 0.05, 0.6 front  noinvert bdefault
set datafile separator ";"
unset key
set title "Carte des vents"
##plot "gnuwind.csv" u 5:4:("---------→"):2:3 with labels rotate variable 
##plot "gnuwind.csv" u 5:4:(-10*$3*sin($2)*cos($3)):(10*$3*cos($2)*sin($3)) w vec
##plot filename u 5:4:(-$3*5*cos($2+90)):($3*5*sin($2+90)) w vec
plot filename u 5:4:($3*5*sin($2)):($3*5*cos($2)) w vec
##plot "gnuwind.csv" u 5:4:(-15*cos($2)):(15*sin($3))
##plot "gnuwind.csv" u 5:4:(sqrt($5**2+$4**2)):($5*cos(x,y)+$4*cos(x,y)) w vec
##plot "gnuwind.csv" u 5:4:(tan($2)*$3):(sin(0)*$3) w vec
##plot "gnuwind.csv" u 5:4:(coef*dx1($2,$3)):(coef*dy1($2,$3)) w vec
