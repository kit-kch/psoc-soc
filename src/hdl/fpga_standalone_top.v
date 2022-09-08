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
        input arst,

        // I2S signals
        output i2s_mclk,
        output i2s_sdata,
        output i2s_bclk,
        output i2s_lrclk
    );

    wire rst;

    wire clk_en_4;
    wire clk_en_16;

    // sin <=> FIFO
    wire [23:0] sin_data;
    wire [48:0] fifo_data;
    wire sin_valid;
    wire fifo_full;
    wire [48:0] i2s_data;
    wire fifo_empty;
    wire i2s_ready;

    assign fifo_data = {sin_data, sin_data};

    reset_logic reset_logic(
        .clk(clk),
        .arst(arst),
        .rst(rst)
    );

    clock_generator clk_gen(
        .clk(clk),
        .rst(rst),
        .clk_en_2(),
        .clk_en_4(clk_en_4),
        .clk_en_8(),
        .clk_en_16(clk_en_16)
    );

    sfifo #(.BW(48), .LGFLEN(4)) fifo(
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
        .rst(rst),

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
        .reset(rst),
        .valid(sin_valid),
        .ready(!fifo_full),
        .out(sin_data)
    );
 endmodule
