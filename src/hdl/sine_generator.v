`timescale 1ns/1ps

module sine_generator(
        input clk,
        input reset,
        input ready,
        output reg valid,
        output reg [23:0] out
    );

    reg [23:0] lut [0:89];
    initial $readmemh("../init/sin_lut_90x24.mem", lut);
    reg [6:0] lut_addr;

    reg startup;
    always @(posedge clk) begin
        if (reset) begin
            lut_addr <= 0;
            startup <= 1;
            valid <= 0;
            out <= 0;
        end else if (startup == 1) begin
            startup <= 0;
            out <= lut[lut_addr];
            valid <= 1;
            lut_addr <= lut_addr + 1;
        end else begin
            if (ready && valid) begin
                out <= lut[lut_addr];
                valid <= 1;

                if (lut_addr == 89)
                    lut_addr <= 0;
                else
                    lut_addr <= lut_addr + 1;
            end
        end
    end
endmodule