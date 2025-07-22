NEORV32_HOME ?= ../../../../../ext/neorv32

APP_SRC = $(wildcard ./*.c) $(wildcard ./*.s) $(wildcard ./*.cpp) $(wildcard ./*.S)
USER_FLAGS = -Wl,--defsym=__neorv32_rom_base=0xE0000000
include $(NEORV32_HOME)/sw/common/common.mk