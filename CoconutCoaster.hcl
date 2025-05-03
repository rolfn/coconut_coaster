# Rolf Niepraschk, 2025-05-03

# Drawj2d Program Reference: https://drawj2d.sourceforge.io/drawj2d_en.pdf

set debug true

unitlength 0.85; 
#unitlength 1; # 1mm
font SansSerif plain 4;
#hatch -45 1.2;

set thinline 0.15;
set thickline 0.4;

font Sans_Serif 4;

# Konstanten
set shThickness 5;
set coaHt 10;
set coaWd 100;
set Rk1 [expr 150 / 2]; # Schalenradius außen
set Rk2 [expr $Rk1 - $shThickness]; # Schalenradius innen
set Rk3 [expr 84 / 2];
set sphereR 10;
set sphereOffs 9;
set drillDiameter 4;
set Ru [expr $coaWd / 2]; # Untersetzerradius
set sphereAngle 120;
set Ma 8;   # Abstand erste Maßlinie
set Mb 5;   # Abstand weiterer Maßlinien

# Markante Punkte
set O1 "91  [expr 210 / 2 - 50]";             # Bezug links
set ShL "[expr [X $O1] - $Rk1 + $shThickness / 2] [ Y $O1 ]";
set ShR "[expr [X $O1] + $Rk1 - $shThickness / 2] [ Y $O1 ]";

puts $O1
puts $Rk1
puts $Rk2

# Untersetzer und Kugeln # TODO: Schraffuren weg?
moveto [X $O1] [expr [Y $O1] + $Rk1 + $coaHt / 2 + $sphereOffs];
set coaCenter [here]
rectmid $coaCenter $coaWd $coaHt;
hatch -45 1.2;
set coaOrig [here]
set O2 "[expr [X $coaOrig] + 165] [Y $coaOrig]"; # Bezug rechts
pen black $thinline solid;
hatchrectmid $coaOrig $coaWd $coaHt;
#puts [here]
pen black $thickline solid;
circle [expr [X [here]] - $Rk3] [expr [Y [here]] - $coaHt - $sphereR / 2] $sphereR;
set sphereLeft [here]
hatch 45 1.2;
pen black $thinline solid;
hatchcircle [here] $sphereR;
circle [X [here]] [expr [Y [here]] + $coaHt + 2 * $sphereR] $sphereR;
pen black $thinline solid;
hatchcircle [here] $sphereR;
pen black $thickline solid;
circle [expr [X $O1] - [expr cot($sphereAngle) * $Rk3]] [Y [here]] $sphereR;
circle [X [here]] [expr [Y [here]] - $coaHt - 2 * $sphereR] $sphereR;

pen white;
fillcircle $O1 $Rk1;
arc $O1 $Rk1 0 180; 
arc $O1 $Rk2 0 180;
arc $ShL [expr $shThickness / 2] 180 0;
arc $ShR [expr $shThickness / 2] 180 0;
pen black $thickline solid;
arc $O1 $Rk1 0 180; 
arc $O1 $Rk2 0 180;
arc $ShL [expr $shThickness / 2] 180 0;
arc $ShR [expr $shThickness / 2] 180 0;
line [X $ShL] [expr [Y $ShL] - $shThickness / 2] [X $ShR] [expr [Y $ShR] - $shThickness / 2];

# Sicht von unten
pen $thickline solid;
circle $O2 $Rk1;
circle $O2 $Ru ;
moveto $O2;
for {set i 0} {< $i 3} {incr $i} {
  set phi [expr $i * $sphereAngle];
  puts "phi=$phi"
  moveto $O2; movepolar -$Rk3 $phi;
  pen white;
  fillcircle $sphereR;
  pen black $thickline solid;
  circle $sphereR;
  if { > $phi 0 } { 
    pen black $thinline dashdotted;
    linemid [expr 4 * $sphereR] $phi;
  }
}

set coaLeft "[expr [X $sphereLeft]] [Y $coaOrig]";

# Bohrungen
pen white
fillrectmid $coaLeft $drillDiameter [expr 2 * $sphereR + $coaHt];
pen black $thickline solid;
rectmid [here] $drillDiameter [expr 2 * $sphereR + $coaHt];
rectmid [here] $drillDiameter $coaHt;
moveto [expr [X [here]] - $drillDiameter /2] [expr [Y [here]] - $sphereR - $coaHt /2];
#fillcircle [here] 1;
set tmp [here];
#linepolar [expr $drillDiameter /2] -45;
set a "[expr [X $tmp] + $drillDiameter /2] [expr [Y $tmp] - $drillDiameter /2]";
set b "[expr [X $tmp] + $drillDiameter] [Y $tmp]";
pen white;
fillpolygon $tmp $a $b;
pen black $thickline solid;
polygon $tmp $a $b;
set tmp "[X $tmp] [expr [Y $tmp] + 2 * $sphereR + $coaHt]";
set a "[expr [X $tmp] + $drillDiameter /2] [expr [Y $tmp] + $drillDiameter /2]";
set b "[expr [X $tmp] + $drillDiameter] [Y $tmp]";
pen white;
fillpolygon $tmp $a $b;
pen black $thickline solid;
polygon $tmp $a $b;

pen black $thinline dashdotted;
circle $O2 $Rk3

# Mittellinien
pen black $thinline dashdotted;
moveto $coaOrig; 
linemid [expr 2.1 * $Ru] 0;
moveto [X $O1] [expr [Y $O1] + 0.75 * $Rk1];
linemid [expr 2 * $Rk1] 90;
#moveto [expr [X $sphereLeft]] [Y $coaOrig];
moveto $coaLeft;
###fillcircle [here] 1;
linemid [expr 1.1 * (4 * $sphereR + $coaHt)] 90;
moveto $O2;
linemid [expr 2.1 * $Rk1]  0;
linemid [expr 2.1 * $Rk1] 90;

# Maßlinien
pen black $thinline solid;
set dx [expr $Rk3 * cos(30)];
set dy [expr $Rk3 * sin(30)];
moveto [expr [X $O2] - $dx] [expr [Y $O2] + $dy];
dimlinerel [expr 2 * $dx] [expr -2 * $dy] "ø%.0f";
#
moveto [X $O2] [expr [Y $O2] - $Ru];
#fillcircle [here] 1;
linerel [expr -$Rk1 - $Mb] 0;
dimlinerel 0 [expr 2 * $Ru] "≈ ø%.0f";
linerel $Rk1 0;
#
moveto [expr [X $coaLeft] + $sphereR + $Ma] [expr [Y $coaLeft] + $coaHt /2];
#fillcircle [here] 1;
dimline ticks;
dimlinerel 0 $sphereR "≈%.0f";
dimline arrows;
linerel [expr [X $coaLeft] - [X [here]]] 0;
#
moveto [expr [X $coaLeft] + $sphereR + 2 * $Ma] [expr [Y $coaLeft] + $coaHt /2];
dimlinerel 0 [expr 2 * $sphereR] "ø%.0f";
linerel [expr [X $coaLeft] - [X [here]]] 0;
#
moveto [expr [X $coaCenter] + $Ru] [expr [Y $coaCenter] - $coaHt /2];
linerel  $Ma 0;
dimline ticks;
dimlinerel 0 $coaHt "≈%.0f";
dimline arrows;
linerel -$Ma 0;

# Überschrift
font SansSerif plain 8
moveto 95 20;
text {Untersetzer für Kokosnuss-Schalen} 297;
font SansSerif italic 8;
text {Coaster for coconut shells} 297; 

# Hinweis zu Schrauben
moveto 18 225;
font SansSerif plain 4;
text {Doppelgewinde-Schraube (ø4; 30mm):}
font SansSerif italic 4;
text {Double ended thread screw:} 
moveto 103 222; 
image "DoubleThreadScrew.png" 1200 0 0 1
