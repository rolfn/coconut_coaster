# Rolf Niepraschk, 2025-05-03

# Drawj2d Program Reference: https://drawj2d.sourceforge.io/drawj2d_en.pdf

set debug true

unitlength 0.85; 
font SansSerif plain 4;

set thinline 0.15;
set thickline 0.4;

# Konstanten
set bowlThickness 5;
set diskHt 10;
set diskWd 100;
set Rk1 [expr 150 / 2]; # Schalenradius außen
set Rk2 [expr $Rk1 - $bowlThickness]; # Schalenradius innen
set Rk3 [expr 84 / 2]; # Teilkreisdurchmesser für die Kugeln
set diskR [expr $diskWd / 2]; # Radius der Holzscheibe
set ballR 10;
set ballOffs 9;
set diskDrill 4;
set drillSphere 3.5;
set ballAngle 120;
set Ma 8;   # Abstand erste Maßlinie
set Mb 5;   # Abstand weiterer Maßlinien

# Markante Punkte
set O1 "91  [expr 210 / 2 - 50]";             # Bezug links
set ShL "[expr [X $O1] - $Rk1 + $bowlThickness / 2] [ Y $O1 ]";
set ShR "[expr [X $O1] + $Rk1 - $bowlThickness / 2] [ Y $O1 ]";

puts $O1
puts $Rk1
puts $Rk2

# Untersetzer und Kugeln # TODO: Schraffuren weg?
moveto [X $O1] [expr [Y $O1] + $Rk1 + $diskHt / 2 + $ballOffs];
set diskCenter [here]
rectmid $diskCenter $diskWd $diskHt;
hatch 45 1.2;
set diskOrig [here]
set O2 "[expr [X $diskOrig] + 165] [Y $diskOrig]"; # Bezug rechts
pen black $thinline solid;
hatchrectmid $diskOrig $diskWd $diskHt;
#puts [here]
pen black $thickline solid;
circle [expr [X [here]] - $Rk3] [expr [Y [here]] - $diskHt - $ballR / 2] $ballR;
set leftBallCenter [here]
hatch -45 1.2;
pen black $thinline solid;
hatchcircle [here] $ballR;
circle [X [here]] [expr [Y [here]] + $diskHt + 2 * $ballR] $ballR;
pen black $thinline solid;
hatchcircle [here] $ballR;
pen black $thickline solid;
circle [expr [X $O1] - [expr cot($ballAngle) * $Rk3]] [Y [here]] $ballR;
circle [X [here]] [expr [Y [here]] - $diskHt - 2 * $ballR] $ballR;

pen white;
fillcircle $O1 $Rk1;
arc $O1 $Rk1 0 180; 
arc $O1 $Rk2 0 180;
arc $ShL [expr $bowlThickness / 2] 180 0;
arc $ShR [expr $bowlThickness / 2] 180 0;
pen black $thickline solid;
arc $O1 $Rk1 0 180; 
arc $O1 $Rk2 0 180;
arc $ShL [expr $bowlThickness / 2] 180 0;
arc $ShR [expr $bowlThickness / 2] 180 0;
line [X $ShL] [expr [Y $ShL] - $bowlThickness / 2] [X $ShR] [expr [Y $ShR] - $bowlThickness / 2];

# Sicht von unten
pen $thickline solid;
circle $O2 $Rk1;
circle $O2 $diskR ;
moveto $O2;
for {set i 0} {< $i 3} {incr $i} {
  set phi [expr $i * $ballAngle];
  puts "phi=$phi"
  moveto $O2; movepolar -$Rk3 $phi;
  pen white;
  fillcircle $ballR;
  pen black $thickline solid;
  circle $ballR;
  if { > $phi 0 } { 
    pen black $thinline dashdotted;
    linemid [expr 4 * $ballR] $phi;
  }
}

set diskLeft "[expr [X $leftBallCenter]] [Y $diskOrig]";

# Bohrungen
pen white
fillrectmid $diskLeft $diskDrill [expr 2 * $ballR + $diskHt];
pen black $thickline solid;
rectmid [here] $diskDrill [expr 2 * $ballR + $diskHt];
rectmid [here] $diskDrill $diskHt;
moveto [expr [X [here]] - $diskDrill /2] [expr [Y [here]] - $ballR - $diskHt /2];
#fillcircle [here] 1;
set tmp [here];
#linepolar [expr $diskDrill /2] -45;
set a "[expr [X $tmp] + $diskDrill /2] [expr [Y $tmp] - $diskDrill /2]";
set b "[expr [X $tmp] + $diskDrill] [Y $tmp]";
pen white;
fillpolygon $tmp $a $b;
pen black $thickline solid;
polygon $tmp $a $b;
set tmp "[X $tmp] [expr [Y $tmp] + 2 * $ballR + $diskHt]";
set a "[expr [X $tmp] + $diskDrill /2] [expr [Y $tmp] + $diskDrill /2]";
set b "[expr [X $tmp] + $diskDrill] [Y $tmp]";
pen white;
fillpolygon $tmp $a $b;
pen black $thickline solid;
polygon $tmp $a $b;

pen black $thinline dashdotted;
circle $O2 $Rk3

# Mittellinien
pen black $thinline dashdotted;
moveto $diskOrig; 
linemid [expr 2.1 * $diskR] 0;
moveto [X $O1] [expr [Y $O1] + 0.75 * $Rk1];
linemid [expr 1.6 * $Rk1] 90;
#moveto [expr [X $leftBallCenter]] [Y $diskOrig];
moveto $diskLeft;
###fillcircle [here] 1;
linemid [expr 1.1 * (4 * $ballR + $diskHt)] 90;
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
moveto [X $O2] [expr [Y $O2] - $diskR];
#fillcircle [here] 1;
linerel [expr -$Rk1 - $Mb] 0;
dimlinerel 0 [expr 2 * $diskR] "≈ ø%.0f";
linerel $Rk1 0;
#
moveto [expr [X $diskLeft] + $ballR + $Ma] [expr [Y $diskLeft] + $diskHt /2];
#fillcircle [here] 1;
dimline ticks;
dimlinerel 0 $ballR "≈%.0f";
dimline arrows;
linerel [expr [X $diskLeft] - [X [here]]] 0;
#
moveto [expr [X $diskLeft] + $ballR + 2 * $Ma] [expr [Y $diskLeft] + $diskHt /2];
dimlinerel 0 [expr 2 * $ballR] "ø%.0f";
linerel [expr [X $diskLeft] - [X [here]]] 0;
#
moveto [expr [X $diskCenter] + $diskR] [expr [Y $diskCenter] - $diskHt /2];
linerel  $Ma 0;
dimline ticks;
dimlinerel 0 $diskHt "≈%.0f";
dimline arrows;
linerel -$Ma 0;

# Benennungen
## Bohrung in Holzscheibe
set b "[X $leftBallCenter] [expr [Y $leftBallCenter] + $ballR + $diskHt /2]";
set a "[expr [X $b] + 14] [expr [Y $b] - 10]"
arrow $a $b;
moveto $a; label "ø$diskDrill" E;
## Holzscheibe
set d "[expr [X $b] + 1.9 * $Rk3] [Y $b]"
set c "[expr [X $a] + 1.9 * $Rk3] [Y $a]"
arrow $c $d;
font SansSerif italic 4;
moveto $c; label "Wooden disc" N;
font SansSerif plain 4;
moverel 0 -6; label "Holzscheibe" N;
## Schale
set a "[expr [X $O1] + 20] [expr [Y $O1] + 10]"
font SansSerif italic 4;
moveto $a; label "Coconut bowl" E;
font SansSerif plain 4;
moverel 0 -6; label "Kokosnuss-Schale" E;

## Bohrung in Kugel
set b "[X $b] [expr [Y $b] - $diskHt /2 - $ballR /2]";
set a "[expr [X $b] - 14] [expr [Y $b] - 10]"
arrow $a $b;
moveto $a; label "ø$drillSphere" W;
## Kugel
set b "[X $b] [expr [Y $b] + 1.5 * $diskHt + 1.5 * $ballR]";
set a "[expr [X $b] + 14] [expr [Y $b] + 10]"
arrow $a $b;
moveto $a;
font SansSerif plain 4;
label "Holzkugel  /" SW;
font SansSerif italic 4;
label "Wooden ball" SE;

# Überschrift
font SansSerif plain 8
moveto 95 25;
text {Untersetzer für Kokosnuss-Schalen} 297;
font SansSerif italic 8;
text {Coaster for coconut bowls} 297; 

# Hinweis zu Schrauben
moveto 18 225;
font SansSerif plain 4;
text {Doppelgewinde-Schraube:}
moveto 18 231;
font SansSerif italic 4;
text {Double ended thread screw:};
moveto 85 231;
text {(ø4; 30)};
moveto 79 222; 
image "DoubleThreadScrew.png" 1200 0 0 1

# Copyright
moveto 278 231;
font SansSerif plain 3;
text {© Rolf Niepraschk, 2025/05/04}



