//Date: 01.07.2025
//Author: Johannes Pfau
//Description: PSoC IC IOBank 0

module iobank1(
        // CLOCK
        output clk,
        output arstn,

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

        // Final IOs, as connected to pads
        inout[9:0] pads
    );

    assign jtag_tck = pads[0];
    assign jtag_tdi = pads[1];
    assign pads[2] = jtag_tdo;
    assign jtag_tms = pads[3];
    assign pads[4] = xip_csn;
    assign pads[5] = xip_clk;
    assign xip_sdi = pads[6];
    assign pads[7] = xip_sdo;
    assign clk = pads[8];
    assign arstn = pads[9];

endmodule
