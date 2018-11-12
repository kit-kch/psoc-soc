RISCV ?= # put the toolchain path here

CC := $(RISCV)riscv32-unknown-elf-gcc
LD := $(RISCV)riscv32-unknown-elf-ld
OBJCOPY := $(RISCV)riscv32-unknown-elf-objcopy

CFLAGS := -Os -march=rv32im -mabi=ilp32 -ffreestanding -nostdlib -nostartfiles
ASFLAGS := -march=rv32im -mabi=ilp32

firmware.mem: firmware.bin
	(echo -n '@00000000 ' && hexdump -ve '1 4 "%08x "' <$<) >$@

firmware.bin: firmware.elf
	$(OBJCOPY) $< -Obinary $@

firmware.elf: firmware.o crt0.o synth.o
	$(CC) -o $@ $^ -Wl,-Tlinkage.ld $(CFLAGS)

synth.o: mario.h

.PHONY: clean almostclean
clean:
	rm -f firmware.{mem,bin,elf,o} crt0.o synth.o

almostclean:
	rm -f firmware.{bin,elf,o} crt0.o synth.o
