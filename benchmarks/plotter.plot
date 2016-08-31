set title "Heroku benchmark (wrk) task1" font ",16" tc rgb "#000000"
set output "heroku_wrk_task1.png"

set terminal pngcairo size 1024,768 enhanced font 'Verdana,10'

set xlabel "Concurrency" font ",14" tc rgb "#606060"
set ylabel "Requests / Sec" font ",14" tc rgb "#606060"
set style data linespoints
set grid
set key outside top nobox font ",14" tc rgb "#000000"

set xtics 2

# task1
set yrange[0:70]
set ytics 5

# task2
#set yrange[0:130]
#set ytics 10


set xrange[1:30]

plot 'master.dat' t 'webbrick' lw 2,  \
    'passenger.dat' t 'passenger' lw 2,  \
    'puma.dat' t 'puma 1w' lw 2,  \
    'puma-w2.dat' t 'puma 2w' lw 2,  \
    'puma-w3.dat' t 'puma 3w' lw 2,  \
    'puma-w4.dat' t 'puma 4w' lw 2,  \
    'thin.dat' t 'thin' lw 2,  \
    'unicorn.dat' t 'unicorn 1w' lw 2,  \
    'unicorn-w2.dat' t 'unicorn 2w' lw 2,  \
    'unicorn-w3.dat' t 'unicorn 3w' lw 2,  \
    'unicorn-w4.dat' t 'unicorn 4w' lw 2

