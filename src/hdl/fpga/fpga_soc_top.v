//Date: 11.09.2022
//Author: Johannes Pfau
//Description: Top-Level Verilog integrating the PSoC audio IP with neorv32 CPU

module fpga_soc_top(
        inout[31:0] pads,
 
        output xip_q2,
        output xip_q3,

        // Not really needed, but needed by the Xilinx ZYNQ stuff when programming FPGA from SD or SPI flash
        inout [14:0] DDR_addr,
        inout [2:0] DDR_ba,
        inout DDR_cas_n,
        inout DDR_ck_n,
        inout DDR_ck_p,
        inout DDR_cke,
        inout DDR_cs_n,
        inout [3:0] DDR_dm,
        inout [31:0] DDR_dq,
        inout [3:0] DDR_dqs_n,
        inout [3:0] DDR_dqs_p,
        inout DDR_odt,
        inout DDR_ras_n,
        inout DDR_reset_n,
        inout DDR_we_n,
        inout FIXED_IO_ddr_vrn,
        inout FIXED_IO_ddr_vrp,
        inout[53:0] FIXED_IO_mio,
        inout FIXED_IO_ps_srstb,
        inout FIXED_IO_ps_clk,
        inout FIXED_IO_ps_porb
    );

    soc_top #(
        .sysinfo(16'h0000)
    ) soc (
        .pads(pads)
    );

    // NeoRV32 does not support QSPI yet.
    // In normal SPI mode, xip_q2 is nWP and xip_q3 is nRESET
    assign xip_q2 = 1'b1;
    assign xip_q3 = 1'b1;

    // We don't really want this, but the Zynq architecture forces us to include it
    zynq_bd_wrapper ps7 (
        .DDR_addr(DDR_addr),
        .DDR_ba(DDR_ba),
        .DDR_cas_n(DDR_cas_n),
        .DDR_ck_n(DDR_ck_n),
        .DDR_ck_p(DDR_ck_p),
        .DDR_cke(DDR_cke),
        .DDR_cs_n(DDR_cs_n),
        .DDR_dm(DDR_dm),
        .DDR_dq(DDR_dq),
        .DDR_dqs_n(DDR_dqs_n),
        .DDR_dqs_p(DDR_dqs_p),
        .DDR_odt(DDR_odt),
        .DDR_ras_n(DDR_ras_n),
        .DDR_reset_n(DDR_reset_n),
        .DDR_we_n(DDR_we_n),
        .FIXED_IO_ddr_vrn(FIXED_IO_ddr_vrn),
        .FIXED_IO_ddr_vrp(FIXED_IO_ddr_vrp),
        .FIXED_IO_mio(FIXED_IO_mio),
        .FIXED_IO_ps_srstb(FIXED_IO_ps_srstb),
        .FIXED_IO_ps_clk(FIXED_IO_ps_clk),
        .FIXED_IO_ps_porb(FIXED_IO_ps_porb)
    );

endmodule
