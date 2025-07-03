//Date: 01.07.2025
//Author: Johannes Pfau
//Description: PSoC IC IO Subsystem

module io_subsystem #(
        parameter [15:0] sysinfo = 16'h0
    )(
        // system clock
        output clk,
        output arstn,
        input rst,

        // WB to configure primary / secondary FN and GPIO OE
        input[31:0] wb_adr,
        output[31:0] wb_dat_i,
        input[31:0] wb_dat_o,
        input wb_we,
        input[3:0] wb_sel,
        input wb_stb,
        input wb_cyc,
        output wb_ack,

        // GPIO Signals
        input[21:0] gpio_o,
        output[21:0] gpio_i,

        // I2S signals
        input i2s_mclk,
        input i2s_sdata,
        input i2s_sclk,
        input i2s_lrclk,

        // Delta-Sigma Outputs
        input audio_l,
        input audio_r,

        // i2c signals
        input i2c_sda_o,
        output i2c_sda_i,
        input i2c_scl_o,
        output i2c_scl_i,

        // UART
        input uart0_txd,
        output uart0_rxd,

        // SPI
        input spi_sck,
        input spi_sdo,
        output spi_sdi,
        input[2:0] spi_csn,

        // PWN
        input[1:0] pwm,

        // JTAG
        output jtag_tck,
        output jtag_tdi,
        input jtag_tdo,
        output jtag_tms,

        // XIP
        input xip_csn,
        input xip_clk,
        output xip_sdi,
        input xip_sdo,

        // Final outputs, as connected to pads
        inout[31:0] pads
    );

    wire[21:0] pad_o, pad_oe, pad_i;
    wire[21:0] gpio_fn;
    wire[21:0] fn_i, fn_o, gpio_oe, fn_oe;


    // Assign the special IOs
    assign fn_o[0] = i2s_mclk;
    assign fn_o[1] = i2s_sdata;
    assign fn_o[2] = i2s_sclk;
    assign fn_o[3] = i2s_lrclk;
    assign fn_oe[3:0] = 4'b1111;

    assign fn_o[4] = audio_l;
    assign fn_o[5] = audio_r;
    assign fn_oe[5:4] = 4'b11;

    assign fn_o[6] = i2c_sda_o;
    assign fn_o[7] = i2c_scl_o;
    assign fn_oe[6] = (i2c_sda_o == 1'b0) ? 1'b1 : 1'b0;
    assign fn_oe[7] = (i2c_scl_o == 1'b0) ? 1'b1 : 1'b0;
    assign i2c_sda_i = fn_i[6];
    assign i2c_scl_i = fn_i[7];

    assign fn_o[8] = uart0_txd;
    assign fn_oe[8] = 1'b1;
    assign uart0_rxd = fn_i[9];
    assign fn_oe[9] = 1'b0;

    assign fn_o[10] = spi_sck;
    assign fn_oe[10] = 1'b1;
    assign fn_o[11] = spi_sdo;
    assign fn_oe[11] = 1'b1;
    assign spi_sdi = fn_i[12];
    assign fn_oe[12] = 1'b0;
    assign fn_o[13] = spi_csn[0];
    assign fn_oe[13] = 1'b1;
    assign fn_o[14] = spi_csn[1];
    assign fn_oe[14] = 1'b1;
    assign fn_o[15] = spi_csn[2];
    assign fn_oe[15] = 1'b1;
    // TODO: SD signals: clk, cmd, dat, cd
    assign fn_o[16] = 1'b0;
    assign fn_oe[16] = 1'b0;
    assign fn_o[17] = 1'b0;
    assign fn_oe[17] = 1'b0;
    assign fn_o[18] = 1'b0;
    assign fn_oe[18] = 1'b0;
    assign fn_o[19] = 1'b0;
    assign fn_oe[19] = 1'b0;

    assign fn_o[20] = pwm[0];
    assign fn_oe[20] = 1'b1;
    assign fn_o[21] = pwm[1];
    assign fn_oe[21] = 1'b1;

    // Wishbone regfile
    io_wb_regfile #(
        .sysinfo(sysinfo)
    ) wb (
        .clk(clk),
        .rst(rst),

        .wb_sel_i(wb_sel),
        .wb_dat_i(wb_dat_i),
        .wb_adr_i(wb_adr),
        .wb_stb_i(wb_stb),
        .wb_cyc_i(wb_cyc),
        .wb_we_i(wb_we),
        .wb_dat_o(wb_dat_o),
        .wb_ack_o(wb_ack),

        .gpio_oe(gpio_oe),
        .gpio_fn(gpio_fn)
    );

    // IO Mux
    iomux iom(
        .gpio_fn(gpio_fn),
    
        .gpio_i(gpio_i),
        .fn_i(fn_i),
        .pad_i(pad_i),

        .gpio_o(gpio_o),
        .fn_o(fn_o),
        .pad_o(pad_o),

        .gpio_oe(gpio_oe),
        .fn_oe(fn_oe),
        .pad_oe(pad_oe)
    );

    // Muxed IOB
    iobank0 iob0(
        .pad_i(pad_i),
        .pad_o(pad_o),
        .pad_oe(pad_oe),
        .pads(pads[21:0])
    );

    // Direct input / outputs IOB
    iobank1 iob1(
        // CLOCK
        .clk(clk),
        .arstn(arstn),

        // JTAG
        .jtag_tck(jtag_tck),
        .jtag_tdi(jtag_tdi),
        .jtag_tdo(jtag_tdo),
        .jtag_tms(jtag_tms),

        // XIP
        .xip_csn(xip_csn),
        .xip_clk(xip_clk),
        .xip_sdi(xip_sdi),
        .xip_sdo(xip_sdo),

        .pads(pads[31:22])
    );

endmodule
