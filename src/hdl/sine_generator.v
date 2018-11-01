`timescale 1ns/1ps

module sine_generator(input clk,
                      input reset,
                      input enable,
                      output reg [23:0] out
                      );
   localparam PHASE_PRECISION = 16;
   localparam LUT_SIZE = 8;
   localparam LUT_HEIGHT = 1 << LUT_SIZE;
   // phase_increment = (2^PHASE_PRECISION - 1) * frequency / sample_rate
   // 601 results in 440Hz, assuming a 48kHz sample rate and PHASE_PRECISION=16
   wire [PHASE_PRECISION-1:0] phase_increment = 601;

   reg [23:0] lut [0:LUT_HEIGHT - 1];
   initial $readmemh("sin_lut_256x24.mem", lut);

   reg [PHASE_PRECISION-1:0] phase;
   wire [LUT_SIZE-1:0] lut_addr = phase[PHASE_PRECISION-1:PHASE_PRECISION-LUT_SIZE];

   always @(posedge clk) begin
      if(reset) begin
         phase <= 0;
      end else if(enable) begin
         phase <= phase + phase_increment;
      end
      out <= lut[lut_addr];
   end
endmodule
