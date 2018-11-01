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

    wire clk_soc;
    wire locked;
    wire reset;

    assign reset = btn_c;

    // Generate all required clocks
    clk_wiz_0 pll (
        .clk_in1(sys_clk),
        .reset(reset),
        .clk_soc(clk_soc),
        .clk_adau_mclk(ac_mclk),
        .locked(locked));

    // Interface to the ADAU
    wire [23:0] sine_generator_out;
    wire audio_full;

    adau_interface adau
      (.clk_120mhz(clk_soc),
       .reset(reset),

       .audio_in({2{sine_generator_out}}),
       .audio_in_valid(1),
       .audio_full(audio_full),
       .enable_audio(1),
       .init_complete(),

       .cclk(ac_scl_cclk),
       .clatch_n(ac_addr0_clatch),
       .cdata(ac_addr1_cdata)
      );

    // The audio generator
    sine_generator sine
      (.clk(clk_soc),
       .reset(reset),
       .enable(!audio_full),
       .out(sine_generator_out)
       );

    // Default LED outputs for debugging signals
    assign led[4:0] = dip[4:0] & {btn_c, btn_d, btn_l, btn_r, btn_u};
    
 endmodule
