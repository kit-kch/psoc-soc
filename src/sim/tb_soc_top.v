`timescale 1ns / 1ps


module tb_soc_top();

    reg sys_clk;
    reg reset;

    wire i2c_sda;
    wire i2c_scl;

    fpga_riscv_top uut(
        .sys_clk(sys_clk),
        
        .led(),
        .dip(0),
        .debug(),
        .btn_rst(reset),
                
        // ADAU signals
        .ac_mclk(),
        .ac_dac_sdata(),
        .ac_bclk(),
        .ac_lrclk(),
        .ac_addr0_clatch(),
        .ac_addr1_cdata(),
        .ac_scl_cclk(),

        
        // i2c signals
        .i2c_sda(i2c_sda),
        .i2c_scl(i2c_scl),
        
        // UART0 
        .uart0_txd_o(),
        .uart0_rxd_i(0),

        // parallel output
        .gpio_o(),
        .gpio_i(0),
        .btn_c(0),
        .btn_d(0),
        .btn_l(0),
        .btn_r(0),
        .btn_u(0),
        
        //SPI SD
        .spi_clk(),
        .spi_miso(0),
        .spi_mosi(),
        .spi_sd_ss(),
        .spi_ss_2(),
        .spi_ss_3(),
        
        //PWM 
        .pwm_led(),

        //JTAG
        .jtag_trst_i(0),
        .jtag_tck_i(0),
        .jtag_tdi_i(0),
        .jtag_tdo_o(),
        .jtag_tms_i(0),

        //XIP
        .xip_csn_o(),
        .xip_clk_o(),
        .xip_sdi_i(0),
        .xip_sdo_o(),
        .xip_q2(),
        .xip_q3()
    );

    // Generate clk @100 MHz
    initial sys_clk <= 0;
    always #5 sys_clk <= ~sys_clk;



    // Pull reset high for 50 cycles
    initial
        begin
            // High for 50 cycles
            reset <= 1;
            repeat(1) begin
                @(negedge sys_clk);
            end
            reset <= 0;
        end

endmodule
