dump:
	netgen -ofmt verilog -dir ngout -mhf top.ngd

SRCS:=$(shell echo ../*.v ../*.vf ../*.vhd)

top.ngc: ${SRCS} ../top.xst
	echo ${SRCS}
	xst -ifn ../top.xst -ofn top.syr

top.ngd: top.ngc
	ngdbuild -uc ../top.ucf -nt timestamp -p 2vp50ff1152-6 -bm ../top.bmm top.ngc top.ngd

top_map.ncd: top.ngd
	map -p 2vp50ff1152-6 -cm area -pr b -k 4 -c 100 -o top_map.ncd top.ngd top.pcf

top.ncd: top_map.ncd
	par -w -ol std -t 1 top_map.ncd top.ncd top.pcf

top.twr: top.ncd
	trce -e 3 -l 3 -xml top.twx top.ncd -o top.twr top.pcf -ucf ../top.ucf

top.bit: top.twr
	bitgen -n -f ../top.ut top.ncd

get_loader:
	data2mem -bm ../top_bd.bmm -bt top.bit -d>top_orig.dump
	data2mem -bm ../top_bd.bmm -bt top_ld.bit -d>top_ld.dump

loader.mem: ../../../soft/vp2_loader/loader.bin
	#hexdump -v -e '"@" "%08_ax\n" 16/1 "%02X " "\n"' ../../../soft/vp2_loader/loader.bin >loader.mem
	(echo "@0000E000"; hexdump -v -e '1/1 "%02X " "\n"' ../../../soft/vp2_loader/loader.bin) >loader.mem

top_ld.bit: top.bit loader.mem
	data2mem -bm ../top_bd.bmm -bd loader.mem -bt top.bit -o b top_ld.bit

load: top_ld.bit
	impact -batch ../impact.cmd
