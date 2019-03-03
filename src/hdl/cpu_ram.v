`timescale 1ns/1ps

// Total size is 32KiB
module cpu_ram
   (input clk,
    input reset,

    input [14:0] i_addr,
    input i_req,
    output [31:0] i_rdata,
    output reg i_valid,

    input [14:0] d_addr,
    input d_req,
    input d_we,
    input [3:0] d_be,
    input [31:0] d_wdata,
    output [31:0] d_rdata,
    output reg d_valid
    );

   always @(posedge clk) begin
      if(reset) begin
         i_valid <= 0;
         d_valid <= 0;
      end else begin
         i_valid <= i_req;
         d_valid <= d_req;
      end
   end

   genvar i;
   generate
      for(i = 0; i < 32; i = i + 4)
        begin: ram
           wire [31:0] i_out;
           wire [31:0] d_out;
           assign i_rdata[i+3:i] = i_out[3:0];
           assign d_rdata[i+3:i] = d_out[3:0];
           RAMB36E1
              #(.READ_WIDTH_A(4),
                .READ_WIDTH_B(4),
                .WRITE_WIDTH_A(4),
                .WRITE_WIDTH_B(4))
           ramb_inst
              (.CLKARDCLK(clk),
               .CLKBWRCLK(clk),

               .RSTREGARSTREG(reset),
               .RSTREGB(reset),
               .RSTRAMARSTRAM(reset),
               .RSTRAMB(reset),

               .ENARDEN(i_req),
               .ADDRARDADDR({1'b1, i_addr}),
               .DIADI(32'b0),
               .DIPADIP(4'b0),
               .WEA(4'b0),
               .DOADO(i_out),
               .DOPADOP(),
               .REGCEAREGCE(1'b0),
               .CASCADEINA(),
               .CASCADEOUTA(),

               .ENBWREN(d_req),
               .ADDRBWRADDR({1'b1, d_addr}),
               .DIBDI({28'b0, d_wdata[i+3:i]}),
               .DIPBDIP(4'b0),
               .WEBWE({8{d_be[i/8] & d_we & d_req}}),
               .DOBDO(d_out),
               .DOPBDOP(),
               .REGCEB(1'b0),
               .CASCADEINB(),
               .CASCADEOUTB());
        end
   endgenerate
endmodule
