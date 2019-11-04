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

    // global fast clock
    wire clk_soc;
    wire locked;

    // Generate all required clocks
    clk_wiz_0 pll(
        .clk_in1(sys_clk),
        .reset(0),
        .clk_soc(clk_soc),
        .clk_adau_mclk(ac_mclk),
        .locked(locked)
    );

    // stretch the reset pulse
    reg [5:0] reset_counter = 6'b111111;
    wire reset = reset_counter[5];
    always @(posedge clk_soc) begin
       if(!locked)
           reset_counter <= 6'b111111;
       else if(|reset_counter)
           reset_counter <= reset_counter - 1;
    end


    // ctrl <=> spi interface
    wire [31:0] adau_command;
    wire adau_command_valid, spi_ready, adau_init_done;

    adau_command_list ctrl(
        .clk(clk_soc),
        .reset(reset),

        .command(adau_command),
        .command_valid(adau_command_valid),
        .spi_ready(spi_ready),
        .adau_init_done(adau_init_done)
    );

    adau_spi_master spi(
        .clk(clk_soc),
        .reset(reset),

        .data_in(adau_command),
        .valid(adau_command_valid),
        .ready(spi_ready),

        .cdata(ac_addr1_cdata),
        .cclk(ac_scl_cclk),
        .clatch_n(ac_addr0_clatch)
    );


    // sin <=> i2s
    wire [23:0] sine_generator_out;
    wire audio_full;
    wire audio_valid;

    i2s_master i2s(
        .clk_soc(clk_soc),
        .ac_mclk(ac_mclk),
        .reset(reset),

        .frame_in_l(sine_generator_out),
        .frame_in_r(sine_generator_out),
        .write_frame(audio_valid),
        .full(audio_full),

        .bclk(ac_bclk),
        .lrclk(ac_lrclk),
        .sdata(ac_dac_sdata)
    );

    sine_generator sin(
        .clk(clk_soc),
        .reset(reset),
        .valid(audio_valid),
        .ready(!audio_full),
        .out(sine_generator_out)
    );


    // Default LED outputs for debugging signals
    assign led = dip & {3'b111, btn_c, btn_d, btn_l, btn_r, btn_u};
    assign debug[7:0] = {reset, ac_mclk, ac_addr0_clatch, ac_addr1_cdata,  ac_scl_cclk, ac_dac_sdata, ac_bclk, ac_lrclk};

 endmodule
