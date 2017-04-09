setMode -bscan
setCable -p auto
setCableSpeed -speed 15000000
identify
assignFile -p 1 -file "./top_ld.bit"
program -p 1
quit
