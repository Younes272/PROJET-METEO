set xdata time
set datafile separator ";"
#set zrange[1:23]
#set yrange[-40:80]
set timefmt "%Y-%m-%dT%H:%M:%S+%z"
set xrange ["2010-01-01T01:00:00+01:00":"2022-09-30T20:00:00+02:00"]
set grid
set format x "%Y-%m-%d"

set key top left
set ticslevel 0
set key off
splot filename u 2:1:11:16 with lines palette
 



