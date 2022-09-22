

module tb_binary_counter();
    reg clk;
    reg reset;
    wire [7:0] counter;

    binary_counter B1(
        .clk(clk),
        .reset(reset),
        .counter(counter)
    );

    always #2 clk <= ~clk;
    initial begin
        #0 clk = 0;
        #0 reset = 1;
        #5 reset = 0;
    end
endmodule
