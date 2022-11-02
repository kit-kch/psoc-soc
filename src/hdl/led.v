module led(
    input clk,
    input rst,
    output reg[1:0] led
);

    reg[24:0] c;

    initial c <= 0;
    initial led <= 0;

    always @(posedge clk) begin    
        if (rst == 1) begin
            led <= 0;
            c <= 0;
        end else begin
            if(c == 0) begin
                led <= led + 1;
            end
            c <= c + 1;
        end
    end
    
endmodule