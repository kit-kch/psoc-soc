`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//
// Description:
// Standalone top module which does not include the neorv32 processor.
//
//////////////////////////////////////////////////////////////////////////////////

module fpga_standalone_top(
        // system clock
        input clk,

        // for debugging
        output [7:0] led,
        input [7:0] dip,
        output [7:0] debug,
        input btn_c,
        input btn_d,
        input btn_l,
        input btn_r,
        input btn_u,

        // I2S signals
        output i2s_mclk,
        output i2s_sdata,
        output i2s_bclk,
        output i2s_lrclk
    );

    // global fast clock
    wire clk;

    // stretch the reset pulse
    reg [5:0] reset_counter = 6'b111111;
    wire reset = reset_counter[5];
    always @(posedge clk_soc) begin
        if (btn_c == 1)
            reset_counter <= 6'b111111;
        else if(!locked)
            reset_counter <= 6'b111111;
        else if(|reset_counter)
            reset_counter <= reset_counter - 1;
    end

    wire clk_en_4;
    wire clk_en_16;

    clock_generator clk_gen(
        .clk(clk),
        .rst(rst),
        .clk_en_2(),
        .clk_en_4(clk_en_4),
        .clk_en_8(),
        .clk_en_16(clk_en_16)
    );

    // sin <=> FIFO
    wire [23:0] sin_data;
    wire [63:0] fifo_data;
    wire sin_valid;
    wire fifo_full;
    wire [63:0] i2s_data;
    wire fifo_empty;
    wire i2s_ready;

    assign fifo_wr_data = {8'h00, sin_data,8'h00, sin_data};

    sfifo fifo(
        .i_clk(clk),
        .i_wr(sin_valid),
        .i_data(fifo_data),
        .o_full(fifo_full),
        .o_fill(),
        .i_rd(i2s_ready),
        .o_data(i2s_data),
        .o_empty(fifo_empty)
    );

    i2s_master i2s(
        .clk(clk),
        .mclk_en(clk_en_4),
        .sclk_en(clk_en_16),
        .reset(reset),

        .fifo_data(i2s_data),
        .fifo_valid(!fifo_empty),
        .fifo_ready(i2s_ready),

        .mclk(i2s_mclk),
        .sclk(i2s_sclk),
        .lrclk(i2s_lrclk),
        .sdata(i2s_data)
    );

    sine_generator sin(
        .clk(clk),
        .reset(reset),
        .valid(sin_valid),
        .ready(!fifo_full),
        .out(sin_data)
    );

    // Default LED outputs for debugging signals
    assign led = dip & {3'b111, btn_c, btn_d, btn_l, btn_r, btn_u};
    assign debug[7:0] = {reset, ac_mclk, 1'b0, 1'b0, 1'b0, ac_dac_sdata, ac_bclk, ac_lrclk};

 endmodule
