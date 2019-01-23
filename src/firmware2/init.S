#=========================================================================
# init.S : Real entry point for RISC-V user programs
#=========================================================================
#include "irq_ops.S"

	# This function has to take up less than 16 bytes (4 instructions).
	# Otherwise the linker won't place .irq_entry correctly (at 0x00010010).
	.section .real_start
	.global _real_start
	.type   _real_start, @function
_real_start:
	# Set the stack pointer.
	li      sp, 0x00017FF0
	j       _start

	.size  _real_start, .-_real_start

	.section .irq_entry
	.global _irq_entry
	.type _irq_entry, @function
_irq_entry:
	# Save all registers the irq_handler might use.
	# The RISC-V ABI considers all data below the stack
	# pointer volatile (no red zone), so we can store
	# them in a normal stack frame.
	addi sp, sp, -60
	sw ra, 0(sp)
	sw t0, 4(sp)
	sw t1, 8(sp)
	sw t2, 12(sp)
	sw t3, 16(sp)
	sw t4, 20(sp)
	sw t5, 24(sp)
	sw t6, 28(sp)
	sw a0, 32(sp)
	sw a1, 36(sp)
	sw a2, 40(sp)
	sw a3, 44(sp)
	sw a4, 48(sp)
	sw a5, 52(sp)
	sw a6, 56(sp)
	sw a7, 60(sp)

	# irq_handler(void *irq_return_address, int irq_mask)
	picorv32_getq_insn(a0, q0)
	picorv32_getq_insn(a1, q1)
	jal irq_handler

	# Restore registers
	lw ra, 0(sp)
	lw t0, 4(sp)
	lw t1, 8(sp)
	lw t2, 12(sp)
	lw t3, 16(sp)
	lw t4, 20(sp)
	lw t5, 24(sp)
	lw t6, 28(sp)
	lw a0, 32(sp)
	lw a1, 36(sp)
	lw a2, 40(sp)
	lw a3, 44(sp)
	lw a4, 48(sp)
	lw a5, 52(sp)
	lw a6, 56(sp)
	lw a7, 60(sp)
	addi sp, sp, 60

	picorv32_retirq_insn()
	.size  _irq_entry, .-_irq_entry

	.text

	# A default irq handler that gets linked when the C code does not define one.
	.global irq_handler
	.weak irq_handler
	.type irq_handler, @function
irq_handler:
	ret
	.size irq_handler, .-irq_handler

	# int maskirq(int mask);
	# Sets which IRQs are enabled and returns the old mask.
	# A set bit disables the corresponding IRQ.
	.global maskirq
	.type maskirq, @function
maskirq:
	picorv32_maskirq_insn(a0, a0)
	ret
	.size maskirq, .-maskirq

	# int waitirq(void);
	# Waits for an IRQ to become pending. The bitmask of pending IRQs is returned.
	.global waitirq
	.type waitirq, @function
waitirq:
	picorv32_waitirq_insn(a0)
	ret
	.size waitirq, .-waitirq

	# unsigned int timer(unsigned int);
	# Reset the timer counter to a new value. The counter counts down clock cycles
	# and triggers the timer interrupt when transitioning from 1 to 0. Setting the
	# counter to zero disables the timer. The old value of the counter is returned.
	.global timer
	.type timer, @function
timer:	picorv32_timer_insn(a0, a0)
	ret
	.size timer, .-timer
