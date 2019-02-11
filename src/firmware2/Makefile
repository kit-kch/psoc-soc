RISCV ?= # put the toolchain path here

CC := $(RISCV)riscv32-unknown-elf-gcc
LD := $(RISCV)riscv32-unknown-elf-ld
OBJCOPY := $(RISCV)riscv32-unknown-elf-objcopy

CFLAGS := -Os -march=rv32im -mabi=ilp32
ASFLAGS := -march=rv32im -mabi=ilp32

firmware.mem: firmware.bin
	(echo -n '@00000000 ' && hexdump -ve '1 4 "%08x "' <$<) >$@

firmware.bin: firmware.elf
	$(OBJCOPY) $< -Obinary $@
	@stat -c 'firmware size is %5s / 32768 bytes' $@

firmware.elf: init.o firmware.o
	$(CC) -o $@ $^ -Wl,-Tlinkage.ld $(CFLAGS)

init.o: init.S
	$(CC) -c -o $@ $^ $(CFLAGS)

.PHONY: clean almostclean
clean:
	rm -f firmware.{mem,bin,elf,o}
	rm -f init.o

almostclean:
	rm -f firmware.{bin,elf,o}
