# Modify this variable to fit your NEORV32 setup (neorv32 home folder)
NEORV32_HOME ?= ../../../../../ext/neorv32

APP_SRC = ../../../../../ext/psoc_demo_sw/common/sin_buf.c $(wildcard ./*.c) $(wildcard ./*.s) $(wildcard ./*.cpp) $(wildcard ./*.S)
USER_FLAGS = -Wl,--defsym=__neorv32_rom_base=0xE0000000
include $(NEORV32_HOME)/sw/common/common.mk