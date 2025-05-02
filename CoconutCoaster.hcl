# Rolf Niepraschk, 2025-05-02

# Drawj2d Program Reference: https://drawj2d.sourceforge.io/drawj2d_en.pdf

set debug true

unitlength 0.85; 
#unitlength 1; # 1mm
font Sans_Serif 4;
hatch 135 [mm 1.75]

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
set Ru [expr $coaWd / 2]; # Untersetzerradius
set sphereAngle 120;

# Markante Punkte
set O1 "91  [expr 210 / 2 - 60]";          # Ursprung links
###set O2 "260 [expr 210 / 2 + $sphereOffs]"; # Ursprung RECHTS
#set ShL "[ [ expr [ X $O1 ] - $Rk1 ] [ Y $Rk1 ] ] ";
#set ShL "[ X $O1 ] [ Y $O1 ]";
set ShL "[expr [X $O1] - $Rk1 + $shThickness / 2] [ Y $O1 ]";
set ShR "[expr [X $O1] + $Rk1 - $shThickness / 2] [ Y $O1 ]";

puts $O1
puts $Rk1
puts $Rk2



# Untersetzer und Kugeln
rectmid [X $O1] [expr [Y $O1] + $Rk1 + $coaHd / 2 + $sphereOffs] $coaWd $coaHd;
hatch 45 [mm 1.75]
set coaOrig [here]
hatchrectmid $coaOrig $coaWd $coaHd;
#puts [here]
circle [expr [X [here]] - $Rk3] [expr [Y [here]] - $coaHd - $sphereR / 2] $sphereR;
hatch 135 [mm 1.75]
hatchcircle [here] $sphereR;
circle [X [here]] [expr [Y [here]] + $coaHd + 2 * $sphereR] $sphereR;
hatchcircle [here] $sphereR;
circle [expr [X $O1] - [expr cot($sphereAngle) * $Rk3]] [Y [here]] $sphereR;
circle [X [here]] [expr [Y [here]] - $coaHd - 2 * $sphereR] $sphereR;

# Schale # TODO: circle statt arc, dann obere Hälfte weiß abdecknen
pen white;
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

puts "tan=[expr tan(30)]"
puts "cot=[expr cot (120)]"
puts "sin=[sin 90]"

set O2 "[expr [X $coaOrig] + 165] [Y $coaOrig]"

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

pen black $thinline dashdotted;
circle $O2 $Rk3


# Mittellinien
pen black $thinline dashdotted;
moveto $O2;
linemid [expr 2.2 * $Rk1]  0;
linemid [expr 2.2 * $Rk1] 90;
# line 0 [expr $Ht + $Ol] 0 [expr [Y $K] - $Rk - $Ol]
# moveto [expr [X $K] + $Rk + $Ol] [Y $K]
# linerel [expr - 2 * $Rk - 2 * $Ol] 0

