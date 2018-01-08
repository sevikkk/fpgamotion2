.SUFFIXES: .out .o .c .s .S .hex .v .bin

.c.S:
	cc65 ${CFLAGS} -o ${.TARGET} ${.IMPSRC}

.s.o:
	ca65 ${CAFLAGS} -o ${.TARGET} ${.IMPSRC}

.S.o:
	ca65 ${CAFLAGS} -o ${.TARGET} ${.IMPSRC}

.c.o:
	cc65 ${CFLAGS} -O -o ${.TARGET:C/.o$/.S/} ${.IMPSRC}
	ca65 ${CAFLAGS} -o ${.TARGET} ${.TARGET:C/.o$/.S/}
	
.bin.hex:
	objcopy -I binary -O ihex ${.IMPSRC} ${.TARGET}

.bin.v:
	../tools/make_rom.py ${.IMPSRC} > ${.TARGET}

clean:
	rm -f *.bin *.S *.o *.hex *.v *.lib *.map
