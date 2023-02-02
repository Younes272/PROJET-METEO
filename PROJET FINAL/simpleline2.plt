set xdata time
set datafile separator ";"
set timefmt "%Y-%m-%dT%H:%M:%S%z"
#set xrange ["2010-01-01T01:00:00+01:00":"2022-09-30T20:00:00+02:00"]
set grid
unset key
set title " moyenne par date"
set format x "%Y"
set terminal wxt
set output 'mmm.png'
set label 'Date' at 15, 105
plot filename u 1:2 w lines


