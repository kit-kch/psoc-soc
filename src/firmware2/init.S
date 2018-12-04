#=========================================================================
# init.S : Real entry point for RISC-V user programs
#=========================================================================

  .section .real_start
  .global _real_start
  .type   _real_start, @function
_real_start:
  # Set the stack pointer
  li      sp, 0x00017FF0
  j       _start

  .size  _real_start, .-_real_start
