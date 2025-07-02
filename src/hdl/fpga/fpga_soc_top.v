//Date: 11.09.2022
//Author: Johannes Pfau
//Description: Top-Level Verilog integrating the PSoC audio IP with neorv32 CPU

module fpga_soc_top(
        inout[29:0] pads,

        output xip_q2,
        output xip_q3
    );

    soc_top soc(
        .pads(pads)
    );

    // NeoRV32 does not support QSPI yet.
    // In normal SPI mode, xip_q2 is nWP and xip_q3 is nRESET
    assign xip_q2 = 1'b1;
    assign xip_q3 = 1'b1;

endmodule