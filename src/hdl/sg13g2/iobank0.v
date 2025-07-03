//Date: 01.07.2025
//Author: Johannes Pfau
//Description: PSoC IC IOBank 1, Tristate drivers

module iobank0(
        output[21:0] pad_i,
        input[21:0] pad_o,
        input[21:0] pad_oe,

        // Final outputs, as connected to pads
        inout[21:0] pads
    );

    genvar i;
    generate
        for (i = 0; i < 22; i = i + 1) begin : pad
            (* keep *) sg13g2_IOPadInOut4mA inst (.pad(pads[i]), .c2p(pad_o[i]), .c2p_en(pad_oe[i]), .p2c(pad_i[i]));
        end
    endgenerate

endmodule