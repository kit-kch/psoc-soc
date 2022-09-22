module binary_counter(
    input clk,
    input reset,
    output reg [7:0] count
);

    reg direction;
    parameter low = 0;
    parameter high = 255;

    always @(posedge clk) begin
        if (reset) begin
            direction <= 1;
            count <= 0;
        end else begin
            if (count == (low + 1) && direction == 0) begin
                direction <= 1;
            end else if (count == (high - 1) && direction == 1) begin
                direction <= 0;
            end

            if (direction)
                count <= count + 8'b1;
            else
                count <= count - 8'b1;
        end
    end
endmodule
