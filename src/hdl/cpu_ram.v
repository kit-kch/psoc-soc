`timescale 1ns/1ps

module cpu_ram
  // Total memory size is 2^SIZE words (= 4*2^SIZE bytes)
  // SIZE=13 gives us 32KiB
  #(parameter SIZE=13, parameter HEIGHT = (1 << SIZE) - 1)
   (input clk,
    input reset,
    input [SIZE+1:0] addr,
    input [31:0] wdata,
    input valid,
    input [3:0] wstrb,
    output reg [31:0] rdata,
    output reg ready
    );

   reg [31:0] words [0:HEIGHT];

   wire [SIZE-1:0] a = addr[SIZE+1:2];

   always @(posedge clk) begin
      if(reset) begin
         ready <= 0;
      end else if(valid) begin
         rdata <= words[a];
         if(wstrb[3]) words[a][31:24] <= wdata[31:24];
         if(wstrb[2]) words[a][23:16] <= wdata[23:16];
         if(wstrb[1]) words[a][15: 8] <= wdata[15: 8];
         if(wstrb[0]) words[a][ 7: 0] <= wdata[ 7: 0];
         ready <= 1;
      end else begin
         ready <= 0;
      end
   end

   initial $readmemh("firmware.mem", words);
endmodule
