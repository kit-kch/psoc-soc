//Date: 11.09.2022
//Author: Johannes Pfau
//Description: Top-Level Verilog integrating the PSoC audio IP with neorv32 CPU

// FIXME: clk, arstn also need to go through pads
module soc_top(
        inout[29:0] pads
    );

    // system clock
    wire clk, arstn, rst;
    reset_logic reset_logic(
        .clk(clk),
        .arstn(arstn),
        .rst(rst)
    );

    // Wishbone bus for I2S module
    wire[31:0] bus_adr, bus_dat_i, bus_dat_o;
    wire bus_we, bus_stb, bus_cyc, bus_ack;
    wire[3:0] bus_sel;
    // Audio module interrupt line
    wire audio_fifo_low;
    // Wishbone bus for IO module
    wire[31:0] wbio_adr, wbio_dat_i, wbio_dat_o;
    wire wbio_we, wbio_stb, wbio_cyc, wbio_ack;
    wire[3:0] wbio_sel;
    // GPIO Signals
    wire[31:0] gpio_i, gpio_o;
    // I2S signals
    wire i2s_mclk, i2s_sdata, i2s_sclk, i2s_lrclk;
    // Delta-Sigma Outputs
    wire audio_l, audio_r;
    // i2c signals
    wire i2c_sda_i, i2c_sda_o, i2c_scl_i, i2c_scl_o;
    // UART
    wire uart0_txd_o, uart0_rxd_i;
    // SPI
    wire spi_sck_o, spi_sdo_o, spi_sdi_i;
    wire[7:0] spi_csn_o;
    // JTAG
    wire jtag_tck_i, jtag_tdi_i, jtag_tdo_o, jtag_tms_i;
    // XIP
    wire xip_csn_o, xip_clk_o, xip_sdi_i, xip_sdo_o;

    neorv32_wrap cpu(
        .clk_i(clk),
        .rstn_i(~rst),

        .jtag_tck_i(jtag_tck_i),
        .jtag_tdi_i(jtag_tdi_i),
        .jtag_tdo_o(jtag_tdo_o),
        .jtag_tms_i(jtag_tms_i),

        .wb_adr_o(wbio_adr),
        .wb_dat_i(wbio_dat_i),
        .wb_dat_o(wbio_dat_o),
        .wb_we_o(wbio_we),
        .wb_sel_o(wbio_sel),
        .wb_stb_o(wbio_stb),
        .wb_cyc_o(wbio_cyc),
        .wb_ack_i(wbio_ack),

        .xip_csn_o(xip_csn_o),
        .xip_clk_o(xip_clk_o),
        .xip_sdi_i(xip_sdi_i),
        .xip_sdo_o(xip_sdo_o),

        .gpio_o(gpio_o),
        .gpio_i(gpio_i),

        .uart0_txd_o(uart0_txd_o),
        .uart0_rxd_i(uart0_rxd_i),

        .spi_sck_o(spi_sck_o),
        .spi_sdo_o(spi_sdo_o),
        .spi_sdi_i(spi_sdi_i),
        .spi_csn_o(spi_csn_o),

        .twi_sda_i(i2c_sda_i),
        .twi_sda_o(i2c_sda_o),
        .twi_scl_i(i2c_scl_i),
        .twi_scl_o(i2c_scl_o)
    );

    psoc_audio audio(
        .clk(clk),
        .rst(rst),

        .wb_adr_i(bus_adr),
        .wb_dat_i(bus_dat_i),
        .wb_dat_o(bus_dat_o),
        .wb_we_i(bus_we),
        .wb_sel_i(bus_sel),
        .wb_stb_i(bus_stb),
        .wb_cyc_i(bus_cyc),
        .wb_ack_o(bus_ack),

        .fifo_low(audio_fifo_low),

        .i2s_mclk(i2s_mclk),
        .i2s_sdata(i2s_sdata),
        .i2s_sclk(i2s_sclk),
        .i2s_lrclk(i2s_lrclk),

        .phone_l(audio_l),
        .phone_r(audio_r)
    );

    // Hardcode this to GPIO port 20 for interrupt
    assign gpio_i[20] = audio_fifo_low;

    io_subsystem io(
        .clk(clk),
        .arstn(arstn),
        .rst(rst),

        .wb_adr(wbio_adr),
        .wb_dat_i(wbio_dat_i),
        .wb_dat_o(wbio_dat_o),
        .wb_we(wbio_we),
        .wb_sel(wbio_sel),
        .wb_stb(wbio_stb),
        .wb_cyc(wbio_cyc),
        .wb_ack(wbio_ack),

        .gpio_i(gpio_i[19:0]),
        .gpio_o(gpio_o[19:0]),

        .i2s_mclk(i2s_mclk),
        .i2s_sdata(i2s_sdata),
        .i2s_sclk(i2s_sclk),
        .i2s_lrclk(i2s_lrclk),

        .audio_l(audio_l),
        .audio_r(audio_r),

        .i2c_sda_i(i2c_sda_i),
        .i2c_sda_o(i2c_sda_o),
        .i2c_scl_i(i2c_scl_i),
        .i2c_scl_o(i2c_scl_o),

        .uart0_txd(uart0_txd_o),
        .uart0_rxd(uart0_rxd_i),

        .spi_sck(spi_sck_o),
        .spi_sdo(spi_sdo_o),
        .spi_sdi(spi_sdi_i),
        .spi_csn(spi_csn_o[2:0]),

        .jtag_tck(jtag_tck_i),
        .jtag_tdi(jtag_tdi_i),
        .jtag_tdo(jtag_tdo_o),
        .jtag_tms(jtag_tms_i),

        .xip_csn(xip_csn_o),
        .xip_clk(xip_clk_o),
        .xip_sdi(xip_sdi_i),
        .xip_sdo(xip_sdo_o),

        .pads(pads)
    );

endmodule