        .section isr_vector
        .global _start
_start:
        # Set up the stack.
        la sp, _ramend - 4

        # Clear BSS.
        la t0, _bss_start
        la t1, _bss_end
1:      beq t0, t1, 2f
        sw zero, (t0)
        addi t0, t0, 4
        j 1b
2:

	# Run C main()
        jal main

	# If main() returns, hang the CPU.
3:      j 3b
