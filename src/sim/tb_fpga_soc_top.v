`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/30/2018 05:20:57 PM
// Design Name: 
// Module Name: fpga_riscv_top_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module fpga_soc_top_tb();
   reg clk = 0;
   reg reset = 0;
   
   always #10 clk <= ~clk;

   fpga_riscv_top uut(
        .sys_clk(clk),
        //output [7:0] led,
        .dip(0),
        //output [7:0] debug,
        .btn_c(reset),
        .btn_d(0),
        .btn_l(0),
        .btn_r(0),
        .btn_u(0)

        // ADAU signals
        /*
        output ac_mclk,

        output ac_addr0_clatch,
        output ac_addr1_cdata,
        output ac_scl_cclk,

        output ac_dac_sdata,
        output ac_bclk,
        output ac_lrclk
        */
    );

   initial begin
      $timeformat(-9, 5, " ns", 10);
      
      reset <= 1;
      #100 ;
      reset <= 0;
   end

endmodule
