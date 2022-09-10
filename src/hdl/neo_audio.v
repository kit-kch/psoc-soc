`timescale 1ns / 1ps

module neo_audio(
        // system clock
        input clk,
        input rst,

        input[31:0] wb_adr_i,
        input[31:0] wb_dat_i,
        output[31:0] wb_dat_o,
        input wb_we_i,
        input[3:0] wb_sel_i,
        input wb_stb_i,
        output wb_ack_o,

        // I2S signals
        output i2s_mclk,
        output i2s_sdata,
        output i2s_sclk,
        output i2s_lrclk,

        // Analog outputs (unused in FPGA)
        output phone_l,
        output phone_r
    );

    // Clock strobe signals
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

    // FIFO
    wire [23:0] adau_audio_in_l, adau_audio_in_r;
    wire [47:0] fifo_data_in;
    wire fifo_write;
    wire fifo_full;
    wire [47:0] fifo_data_out;
    wire fifo_empty;
    wire fifo_read;

    // TODO: Move into bus logic
    assign fifo_data_in = {adau_audio_in_l, adau_audio_in_r};

    sfifo #(.BW(48), .LGFLEN(4)) fifo(
        .i_clk(clk),
        .i_wr(fifo_write),
        .i_data(fifo_data_in),
        .o_full(fifo_full),
        .o_fill(),
        .i_rd(fifo_read),
        .o_data(fifo_data_out),
        .o_empty(fifo_empty)
    );

    i2s_master i2s(
        .clk(clk),
        .mclk_en(clk_en_4),
        .sclk_en(clk_en_16),
        .rst(rst),

        .fifo_data(fifo_data_out),
        .fifo_valid(!fifo_empty),
        .fifo_ready(fifo_read),

        .mclk(i2s_mclk),
        .sclk(i2s_sclk),
        .lrclk(i2s_lrclk),
        .sdata(i2s_sdata)
    );

    // TODO: rename to reg file
    wishbone_bus_logic bus(
        .clk(clk),
        .rst(rst),

        .wb_adr_i(wb_adr_i),
        .wb_dat_i(wb_dat_i),
        .wb_sel_i(wb_sel_i),
        .wb_dat_o(wb_dat_o),
        .wb_stb_i(wb_stb_i),
        .wb_we_i(wb_we_i),
        .wb_ack_o(wb_ack_o),

        .adau_audio_l(adau_audio_in_l),
        .adau_audio_r(adau_audio_in_r),
        .adau_audio_valid(fifo_write),
        .adau_audio_full(fifo_full),

        // TODO: Remove
        .adau_init_done(1'b1)
    );

    // FIXME
    assign phone_l = 1'b0;
    assign phone_r = 1'b0;

endmodule