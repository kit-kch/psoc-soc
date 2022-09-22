module encoder_top(
    input clk,
    input reset,
    output [255:0] thermometer_code
);

    wire [7:0] count;

    binary_counter #(.low(0), .high(255)) counter(
        .clk(clk),
        .reset(reset),
        .count(count)
    );

    thermometer_encoder t_encoder(
        .clk(clk),
        .in(count),
        .out(thermometer_code),
        .reset(reset)
    );

endmodule 
