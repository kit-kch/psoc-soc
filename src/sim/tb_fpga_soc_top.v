module tb_fpga_soc_top();
    reg clk;
    initial clk <= 0;
    always #5.087 clk <= ~clk;

    reg arstn;
    initial arstn <= 0;

    wire i2c_sda, i2c_scl;

    fpga_soc_top uut(
        .clk(clk),
        .arstn(arstn),

        // I2S signals
        .i2s_mclk(),
        .i2s_sdata(),
        .i2s_sclk(),
        .i2s_lrclk(),

        // Analog outputs (unused in FPGA)
        .phone_l(),
        .phone_r(),

        // i2c signals
        .i2c_sda(i2c_sda),
        .i2c_scl(i2c_scl),

        // UART
        .uart0_txd_o(),
        .uart0_rxd_i(1'b1),

        // GPIO
        .gpio_o(),
        .gpio_i(1'b0),

        // Buttons
        .btn_c(1'b0),
        .btn_d(1'b0),
        .btn_l(1'b0),
        .btn_r(1'b0),
        .btn_u(1'b0),

        // SPI
        .spi_sck_o(),
        .spi_sdo_o(),
        .spi_sdi_i(1'b0),
        .spi_ss_sd(),
        .spi_ss_2(),
        .spi_ss_3(),

        // PWM Pin
        .pwm_led(),

        // JTAG
        .jtag_trst_i(1'b0),
        .jtag_tck_i(1'b0),
        .jtag_tdi_i(1'b0),
        .jtag_tdo_o(),
        .jtag_tms_i(1'b0),

        // XIP
        .xip_csn_o(),
        .xip_clk_o(),
        .xip_sdi_i(1'b0),
        .xip_sdo_o(),

        .xip_q2(),
        .xip_q3()
    );

    task do_reset;
        begin
            repeat(10)
                @(posedge clk);
            arstn <= 1;
        end
    endtask

    initial begin
        do_reset;
        repeat(100)
            @(posedge clk);
        $display("Test OK");
        $finish;
    end

endmodule
