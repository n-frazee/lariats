reset
scaleAll=1.5
set terminal svg enhanced size 800*scaleAll,800*scaleAll
set output 'fake.svg'

#-Sets the graphs to be well spaced along with the margins line in multiplot
if (!exists("MP_LEFT"))   MP_LEFT = .2
if (!exists("MP_RIGHT"))  MP_RIGHT = .9
if (!exists("MP_BOTTOM")) MP_BOTTOM = .2
if (!exists("MP_TOP"))    MP_TOP = .9
if (!exists("MP_GAP"))    MP_GAP = 0.025

set size 1,1
set multiplot layout 1,1 rowsfirst  margins screen MP_LEFT, MP_RIGHT, MP_BOTTOM, MP_TOP spacing screen MP_GAP


set encoding iso_8859_1
set lmargin screen .2
set bmargin screen .2
KEYFONT = "',80'"
XTICFONT = "',80' scale 1.5*scaleAll offset 0,-3"
YTICFONT = "',80' scale 1.5*scaleAll offset -2,0"
CBTICFONT = "',80' scale 1.5*scaleAll offset 0,0"
LABELFONT = "',80'"
XOFFSET = "0,-7"
YOFFSET = "-15,0"
dotSize = 1.5*scaleAll
widthLines = 3*scaleAll
set errorbars 2*scaleAll
set border lw 2.5*3
#-Position of label-#
POS = "at 250,2.25 center front font ',80' tc rgb 'black'"
#-Tics and labels-#
XTICS = "set xtics () font @XTICFONT"
YTICS = "set ytics () font @YTICFONT"
NOXTICS = "set xtics ('' 0, '' 100, '' 200, '' 300, '' 400, '' 500) scale 1.5*scaleAll; unset xlabel"
NOYTICS = "set ytics ('' 1, '' 1.5, '' 2) scale 1.5*scaleAll; unset ylabel"


#set border 3
#set tics nomirror
set xrange [0:25]
set yrange [0:25]
unset key
set style line 1 lc rgb 'black' pt 7 ps dotSize



@YTICS; @XTICS
set xlabel 'P_{app}  from literature' font ',80' offset @XOFFSET
set ylabel 'calculated permeability' font ',80' offset @YOFFSET
plot 'Papp_fake.txt' using 1:2 ls 1



unset multiplot
