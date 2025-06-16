module thermometer_encoder(
    input clk,
    input reset,
    input wire [7:0] in,
    output reg [255:0] out
);

    always @(posedge clk) begin
        if (in == 0) begin
            out <= 0;
        end else begin
            out <= (2**in) - 1;
        end
    end

endmodule