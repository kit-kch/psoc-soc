`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//
// Description:
// Standalone top module which does not include the picorv32 processor.
// This is used for simple debugging to get the ADAU driver working first.           
// 
//////////////////////////////////////////////////////////////////////////////////


module fpga_standalone_top(
        // system clock
        input sys_clk,

        // for debugging
        output [7:0] led,
        input [7:0] dip,
        input btn_c,
        input btn_d,
        input btn_l,
        input btn_r,
        input btn_u,

        // ADAU signals
        output ac_mclk,

        output ac_addr0_clatch,
        output ac_addr1_cdata,
        output ac_scl_cclk,

        output ac_dac_sdata,
        output ac_bclk,
        output ac_lrclk
    );

    // Generate all required clocks
    wire clk_soc;
    wire locked;
    clk_wiz_0 pll (
        .clk_in1(sys_clk),
        .reset(btn_c),
        .clk_soc(clk_soc),
        //.clk_adau_mclk(ac_mclk),
        .locked(locked));



    // Default LED outputs for debugging signals
    assign led = dip & {3'b000, btn_c, btn_d, btn_l, btn_r, btn_u};
    
    //Default outputs for ADAU signals
    assign ac_mclk = 'b0;
    assign ac_addr0_clatch = 'b0;
    assign ac_addr1_cdata = 'b0;
    assign ac_scl_cclk = 'b0;
    assign ac_dac_sdata = 'b0;
    assign ac_bclk = 'b0;
    assign ac_lrclk = 'b0;

 endmodule