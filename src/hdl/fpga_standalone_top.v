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
        output [7:0] debug,
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

    // Generate all required clocks
    clk_wiz_0 pll (
        .clk_in1(sys_clk),
        .reset(btn_c),
        .clk_soc(clk_soc),
        .clk_adau_mclk(ac_mclk),
        .locked(locked));

    // stretch the reset pulse
    reg [5:0] reset_counter = 6'b111111;
    wire reset = reset_counter[5];
    always @(posedge clk_soc) begin
       if(!locked)
           reset_counter <= 6'b111111;
       else if(|reset_counter)
	       reset_counter <= reset_counter - 1;
    end

    // Interface to the ADAU
    wire [23:0] sine_generator_out;
    wire audio_full;
    wire audio_valid;

    adau_interface adau
      (.clk_120mhz(clk_soc),
       .ac_mclk(ac_mclk),
       .reset(reset),

       .audio_in({2{sine_generator_out}}),
       .audio_full(audio_full),
       .audio_in_valid(audio_valid),
       .adau_init_done(),

       .cclk(ac_scl_cclk),
       .clatch_n(ac_addr0_clatch),
       .cdata(ac_addr1_cdata),

       .sdata(ac_dac_sdata),
       .bclk(ac_bclk),
       .lrclk(ac_lrclk)
      );

    // The audio generator
    sine_generator sine
      (.clk(clk_soc),
       .reset(reset),
       .valid(audio_valid),
       .ready(!audio_full),
       .out(sine_generator_out)
       );

    // Default LED outputs for debugging signals
    assign led = dip & {3'b111, btn_c, btn_d, btn_l, btn_r, btn_u};

    assign debug[7:0] = {reset, ac_mclk, ac_addr0_clatch, ac_addr1_cdata,  ac_scl_cclk, ac_dac_sdata, ac_bclk, ac_lrclk};

 endmodule
