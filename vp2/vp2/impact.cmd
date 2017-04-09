setMode -bscan
setCable -p auto
identify
assignFile -p 1 -file "./top_ld.bit"
program -p 1
quit
