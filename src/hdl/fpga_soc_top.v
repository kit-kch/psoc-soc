`timescale 1ns / 1ps

module fpga_soc_top(
        // system clock
        input clk,
        input arst,

        // I2S signals
        output i2s_mclk,
        output i2s_sdata,
        output i2s_sclk,
        output i2s_lrclk,

        // Analog outputs (unused in FPGA)
        output phone_l,
        output phone_r,

        // i2c signals
        inout i2c_sda,
        inout i2c_scl,

        // UART
        output uart0_txd_o,
        input uart0_rxd_i,

        // GPIO
        output [1:0] gpio_o,
        input [1:0] gpio_i,

        // Buttons
        input btn_c,
        input btn_d,
        input btn_l,
        input btn_r,
        input btn_u,

        // SPI
        output spi_sck_o,
        output spi_sdo_o,
        input  spi_sdi_i,
        output spi_ss_sd,
        output spi_ss_2,
        output spi_ss_3,

        // PWM Pin
        output pwm_led,

        // JTAG
        input  jtag_trst_i,
        input  jtag_tck_i,
        input  jtag_tdi_i,
        output jtag_tdo_o,
        input  jtag_tms_i,

        // XIP
        output xip_csn_o,
        output xip_clk_o,
        input  xip_sdi_i,
        output xip_sdo_o,

        output xip_q2,
        output xip_q3
    );

    wire rst;
    reset_logic reset_logic(
        .clk(clk),
        .arst(arst),
        .rst(rst)
    );

    // Wishbone bus for I2S module
    wire[31:0] bus_adr, bus_dat_i, bus_dat_o;
    wire bus_we, bus_stb, bus_ack;
    wire[3:0] bus_sel;

    // The SPI chip select signals
    wire [7:0] spi_csn_o;
    assign spi_ss_sd = spi_csn_o[1];
    assign spi_ss_2 = spi_csn_o[2];
    assign spi_ss_3 = spi_csn_o[3];

    neorv32_wrap cpu(
        .clk_i(clk),
        .rstn_i(~rst),

        .jtag_trst_i(jtag_trst_i),
        .jtag_tck_i(jtag_tck_i),
        .jtag_tdi_i(jtag_tdi_i),
        .jtag_tdo_o(jtag_tdo_o),
        .jtag_tms_i(jtag_tms_i),

        .wb_adr_o(bus_adr),
        .wb_dat_i(bus_dat_i),
        .wb_dat_o(bus_dat_o),
        .wb_we_o(bus_we),
        .wb_sel_o(bus_sel),
        .wb_stb_o(bus_stb),
        .wb_ack_i(bus_ack),

        .xip_csn_o(xip_csn_o),
        .xip_clk_o(xip_clk_o),
        .xip_sdi_i(xip_sdi_i),
        .xip_sdo_o(xip_sdo_o),

        .gpio_o({phone_l, phone_r, gpio_o}),
        .gpio_i({btn_c, btn_d, btn_l, btn_u, btn_r, gpio_i[0], gpio_i[1]}),

        .uart0_txd_o(uart0_txd_o),
        .uart0_rxd_i(uart0_rxd_i),

        .spi_sck_o(spi_sck_o),
        .spi_sdo_o(spi_sdo_o),
        .spi_sdi_i(spi_sdi_i),
        .spi_csn_o(spi_csn_o),

        .twi_sda_io(i2c_sda),
        .twi_scl_io(i2c_scl),

        .pwm_o({pwm_led}),

        .xirq_i({btn_c, btn_d, btn_l, btn_u, btn_r})
    );

    // NeoRV32 does not support QSPI yet.
    // In normal SPI mode, xip_q2 is nWP and xip_q3 is nRESET
    assign xip_q2 = 1'b1;
    assign xip_q3 = 1'b1;

    neo_audio audio(
        .clk(clk),
        .rst(rst),

        .wb_adr_i(bus_adr),
        .wb_dat_i(bus_dat_o),
        .wb_dat_o(bus_dat_i),
        .wb_we_i(bus_we),
        .wb_sel_i(bus_sel),
        .wb_stb_i(bus_stb),
        .wb_ack_o(bus_ack),

        .i2s_mclk(i2s_mclk),
        .i2s_sdata(i2s_sdata),
        .i2s_sclk(i2s_sclk),
        .i2s_lrclk(i2s_lrclk),

        .phone_l(phone_l),
        .phone_r(phone_r)
    );

endmodule