# Rolf Niepraschk, 2025-05-09

all : CoconutCoaster.pdf  # CoconutCoaster.png 

CoconutCoaster.pdf : CoconutCoaster.hcl img/DoubleThreadScrew.png
	drawj2d --verbose --width 297 --height 210 \
	  --type pdf --outfile $@ $<

