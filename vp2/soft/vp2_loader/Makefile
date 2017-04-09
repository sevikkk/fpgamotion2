all:	loader.hex loader.v

VER != date '+%Y/%m/%d %H:%M:%S'

PROG = loader
OBJS = loader.o

.include "../xilinx_rom/Makefile.inc"

CFLAGS += -DLOADER_VERSION='"${VER}"'
