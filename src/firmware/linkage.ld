OUTPUT_ARCH(riscv)
ENTRY(_start)
SECTIONS
{
        . = 0x00010000;
        _ramend = 0x00018000;
        .text :
        {
	       *(.startup)
	       KEEP(*(.startup))
               *(.text)
               *(.text*)
               *(.rodata)
               *(.data)
               . = ALIGN(4);
               _bss_start = .;
               *(.bss)
               . = ALIGN(4);
               _bss_end = .;
        }
}
