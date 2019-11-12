`timescale 1ns/1ps

module sine_generator(
        input clk,
        input reset,
        input ready,
        output reg valid,
        output reg [23:0] out
    );

    reg [23:0] lut [0:89];
    initial $readmemh("sin_lut_90x24.mem", lut);
    reg [6:0] lut_addr;

    always @(posedge clk) begin
        if (reset) begin
            lut_addr = 0;
            valid <= 0;
            out <= 0;
            out <= lut[0];
        end else begin
            valid <= 1;
            if (ready && valid) begin
                lut_addr = lut_addr + 1;
                if (lut_addr == 90)
                    lut_addr = 0;
                out <= lut[lut_addr];
            end
        end
    end
endmodule
