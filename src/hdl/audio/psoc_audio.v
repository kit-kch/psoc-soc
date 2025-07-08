//Date: 11.09.2022
//Author: Johannes Pfau
//Description: PSoC audio IP top module

module psoc_audio(
        // system clock
        input clk,
        input rst,

        input[31:0] wb_adr_i,
        output[31:0] wb_dat_i,
        input[31:0] wb_dat_o,
        input wb_we_i,
        input[3:0] wb_sel_i,
        input wb_stb_i,
        input wb_cyc_i,
        output wb_ack_o,

        // status bit if fifo is low. use for interrupts
        output fifo_low,

        // I2S signals
        output i2s_mclk,
        output i2s_sdata,
        output i2s_sclk,
        output i2s_lrclk,

        // Analog outputs (unused in FPGA)
        output phone_l,
        output phone_r
    );

    wire software_rst;
    // Clock strobe signals
    wire clk_en_4;
    wire clk_en_16;
    clock_generator clk_gen(
        .clk(clk),
        .rst(software_rst),
        .clk_en_2(),
        .clk_en_4(clk_en_4),
        .clk_en_8(),
        .clk_en_16(clk_en_16)
    );

    // FIFO
    localparam FIFO_LEN_BITS = 8;
    wire[47:0] fifo_data_in, fifo_data_out;
    wire fifo_write, fifo_write_ready;
    reg fifo_read;
    wire fifo_ready_i2s, fifo_ready_dac;
    wire fifo_full, fifo_empty;

    // Local control signals
    wire device_reset, dac_mode, dac_enable, i2s_enable;
    wire[FIFO_LEN_BITS:0] fifo_level, fifo_threshold;

    assign device_reset = rst | software_rst;

    // For I2S output mode
    i2s_master i2s(
        .clk(clk),
        .clk_en(i2s_enable),
        .mclk_en(clk_en_4),
        .sclk_en(clk_en_16),
        .rst(device_reset),

        .fifo_data(fifo_data_out),
        .fifo_valid(!fifo_empty),
        .fifo_ready(fifo_ready_i2s),

        .mclk(i2s_mclk),
        .sclk(i2s_sclk),
        .lrclk(i2s_lrclk),
        .sdata(i2s_sdata)
    );

    // For using our own DAC
    psoc_dac dac(
        .clk(clk),
        .rst(device_reset),
        .enable(dac_enable),

        .fifo_data(fifo_data_out),
        .fifo_empty(fifo_empty),
        .fifo_ready(fifo_ready_dac),

        .phone_l(phone_l),
        .phone_r(phone_r)
    );

    // FIFO is controlled by i2s master or psoc_dac, depending on dac mode bit
    always @(dac_mode, fifo_ready_i2s, fifo_ready_dac) begin
        if (dac_mode == 1'b0)
            fifo_read <= fifo_ready_i2s;
        else
            fifo_read <= fifo_ready_dac;
    end

    sfifo #(.BW(48), .LGFLEN(FIFO_LEN_BITS)) fifo(
        .i_clk(clk),
        .i_rst(rst),
        .i_wr(fifo_write),
        .i_data(fifo_data_in),
        .o_ready(fifo_write_ready),
        .o_full(fifo_full),
        .o_fill(fifo_level),
        .i_rd(fifo_read),
        .o_data(fifo_data_out),
        .o_empty(fifo_empty)
    );

    // Control logic for fifo low signal
    assign fifo_low = fifo_level < fifo_threshold;

    i2s_wb_regfile #(.FIFO_LEN_BITS(FIFO_LEN_BITS)) regs(
        .clk(clk),
        .rst(rst),

        .wb_sel_i(wb_sel_i),
        .wb_dat_i(wb_dat_i),
        .wb_adr_i(wb_adr_i),
        .wb_stb_i(wb_stb_i),
        .wb_cyc_i(wb_cyc_i),
        .wb_we_i(wb_we_i),
        .wb_dat_o(wb_dat_o),
        .wb_ack_o(wb_ack_o),

        .audio_data(fifo_data_in),
        .audio_valid(fifo_write),

        .fifo_full(fifo_full),
        .fifo_empty(fifo_empty),
        .fifo_low(fifo_low),
        .fifo_level(fifo_level),
        .fifo_threshold(fifo_threshold),
        .fifo_ready(fifo_write_ready),
        .dac_mode(dac_mode),
        .dac_enable(dac_enable),
        .i2s_enable(i2s_enable),
        .software_rst(software_rst)
    );

endmodule
