# Rolf Niepraschk, 2025-05-03

# Drawj2d Program Reference: https://drawj2d.sourceforge.io/drawj2d_en.pdf

set debug true

unitlength 0.85; 
#unitlength 1; # 1mm
font Sans_Serif 4;
hatch -45 1.2;

set thinline 0.15;
set thickline 0.4;

# Wichtige Konstanten
set shThickness 5;
set coaHd 10;
set coaWd 100;
set Rk1 [expr 150 / 2]; # Schalenradius außen
set Rk2 [expr $Rk1 - $shThickness]; # Schalenradius innen
set Rk3 [expr 84 / 2];
set sphereR 10;
set sphereOffs 9;
set drillDiameter 4;
set Ru [expr $coaWd / 2]; # Untersetzerradius
set sphereAngle 120;

# Markante Punkte
set O1 "91  [expr 210 / 2 - 60]";             # Bezug links
set ShL "[expr [X $O1] - $Rk1 + $shThickness / 2] [ Y $O1 ]";
set ShR "[expr [X $O1] + $Rk1 - $shThickness / 2] [ Y $O1 ]";

puts $O1
puts $Rk1
puts $Rk2



# Untersetzer und Kugeln # TODO: Schraffuren weg?
rectmid [X $O1] [expr [Y $O1] + $Rk1 + $coaHd / 2 + $sphereOffs] $coaWd $coaHd;
hatch 45 1.2;
set coaOrig [here]
set O2 "[expr [X $coaOrig] + 165] [Y $coaOrig]"; # Bezug rechts
pen black $thinline solid;
hatchrectmid $coaOrig $coaWd $coaHd;
#puts [here]
pen black $thickline solid;
circle [expr [X [here]] - $Rk3] [expr [Y [here]] - $coaHd - $sphereR / 2] $sphereR;
set sphereLeft [here]
hatch -45 1.2;
pen black $thinline solid;
hatchcircle [here] $sphereR;
circle [X [here]] [expr [Y [here]] + $coaHd + 2 * $sphereR] $sphereR;
pen black $thinline solid;
hatchcircle [here] $sphereR;
pen black $thickline solid;
circle [expr [X $O1] - [expr cot($sphereAngle) * $Rk3]] [Y [here]] $sphereR;
circle [X [here]] [expr [Y [here]] - $coaHd - 2 * $sphereR] $sphereR;

# Schale # TODO: circle statt arc, dann obere Hälfte weiß abdecknen
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
    linemid [expr 2.5 * $sphereR] $phi;
  }
}

set coaLeft "[expr [X $sphereLeft]] [Y $coaOrig]";

# Bohrungen
pen white
fillrectmid $coaLeft $drillDiameter [expr 2 * $sphereR + $coaHd];
pen black $thickline solid;
rectmid [here] $drillDiameter [expr 2 * $sphereR + $coaHd];
rectmid [here] $drillDiameter $coaHd;
moveto [expr [X [here]] - $drillDiameter /2] [expr [Y [here]] - $sphereR - $coaHd /2];
#fillcircle [here] 1;
set tmp [here];
#linepolar [expr $drillDiameter /2] -45;
set a "[expr [X $tmp] + $drillDiameter /2] [expr [Y $tmp] - $drillDiameter /2]";
set b "[expr [X $tmp] + $drillDiameter] [Y $tmp]";
pen white;
fillpolygon $tmp $a $b;
pen black $thickline solid;
polygon $tmp $a $b;
set tmp "[X $tmp] [expr [Y $tmp] + 2 * $sphereR + $coaHd]";
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
linemid [expr 2.2 * $Ru] 0;
moveto [X $O1] [expr [Y $O1] + 0.75 * $Rk1];
#linemid [expr 2.2 * $Rk1]  0;
linemid [expr 2.2 * $Rk1] 90;
#moveto [expr [X $sphereLeft]] [Y $coaOrig];
moveto $coaLeft;
###fillcircle [here] 2;
linemid [expr 1.5 * (4 * $sphereR + $coaHd)] 90;
moveto $O2;
linemid [expr 2.2 * $Rk1]  0;
linemid [expr 2.2 * $Rk1] 90;

