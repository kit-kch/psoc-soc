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
        for (i = 0; i < 22; i = i + 1) begin : mux_loop
            assign pads[i] = (pad_oe[i] == 1'b1) ? pad_o[i] : 1'bz;
            assign pad_i[i] = pads[i];
        end
    endgenerate

endmodule