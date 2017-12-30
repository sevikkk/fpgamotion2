dump: build
	cd build && netgen -ofmt verilog -dir ngout -mhf top.ngd

SRCS:=$(shell echo *.v *.vf *.vhd)

build/top.ngc: ${SRCS} top.xst
	[ -d build ] || mkdir build
	cd build && \
		xst -ifn ../top.xst -ofn top.syr

build/top.ngd: build/top.ngc
	cd build && \
		cp ../top.bmm . && \
		ngdbuild -uc ../top.ucf -nt timestamp -p 2vp50ff1152-6 -bm top.bmm top.ngc top.ngd

build/top_map.ncd: build/top.ngd
	cd build && \
		map -p 2vp50ff1152-6 -cm area -pr b -k 4 -c 100 -o top_map.ncd top.ngd top.pcf

build/top.ncd: build/top_map.ncd
	cd build && \
		par -w -ol std -t 1 top_map.ncd top.ncd top.pcf

build/top.twr: build/top.ncd
	cd build && \
		trce -e 3 -l 3 -xml top.twx top.ncd -o top.twr top.pcf -ucf ../top.ucf

build/top.bit: build/top.twr
	cd build && \
		bitgen -n -f ../top.ut top.ncd

get_loader:
	cd build && \
		data2mem -bm top_bd.bmm -bt top.bit -d>top_orig.dump && \
		data2mem -bm top_bd.bmm -bt top_ld.bit -d>top_ld.dump

build/loader.mem: ../soft/vp2_loader/loader.bin ../soft/vp2_cli/main.bin
	cd build && \
		( \
			echo "@0000E000"; hexdump -v -e '1/1 "%02X " "\n"' ../../soft/vp2_loader/loader.bin; \
			echo "@00001000"; hexdump -v -e '1/1 "%02X " "\n"' ../../soft/vp2_cli/main.bin; \
		) >loader.mem

build/top_ld.bit: build/top.bit build/loader.mem
	cd build && \
		data2mem -bm top_bd.bmm -bd loader.mem -bt top.bit -o b top_ld.bit

load: build/top_ld.bit
	cd build && \
		impact -batch ../impact.cmd

clean:
	rm -rf build
