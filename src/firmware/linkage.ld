OUTPUT_ARCH(riscv)
ENTRY(_start)
SECTIONS
{
        . = 0x00010000;
        _ramend = 0x00014000;
        .text : ALIGN(4)
        {
               *(.isr_vector)
               KEEP(*(.isr_vector))
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
