These tools can be used to convert audio data for use in the RISCV as a
data buffer or for use in Verilog by reading in a .mem file.

Usage:
* convert_to_s16.sh: Convert input audio to raw audio, 1 channel @ 48khZ, signed 16 bit values in little endian.
* convert_s16_to_mem.py: Convert the s16le binary file to a .mem file to read into vivado (48kHz, 24bit).
* convert_s16_to_c.py: Convert the 16le binary file to a .c file to include in the RISCV firmware (48kHz, 24bit).
* gen_sine.py: Generate a perfect sine wave .mem file. It adjusts the requested frequency to get
  a sin where sin(0) and sin(2pi) align exactly to the 48kHZ fs sample frequency. In addition,
  the sin is constructed from sin(0..pi/2) so that the following equations hold bit-exactly:
  sin(pi/2..pi) = sin(-(0..pi/2)) 
  sin(pi..3pi/2) = -sin(0..pi/2) 
  sin(3pi/2..2pi) = -sin(-(0..pi/2))
