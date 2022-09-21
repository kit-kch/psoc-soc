

`timescale 1ns/1ps

module counter_tb();


reg clk ;
reg reset;
wire [7:0] counter;

binary_counter B1 (
.clk(clk), 
.reset(reset),
.counter(counter)
);

initial begin

#0 clk = 0;
#0 reset = 1;
#5 reset = 0;

end

always #2 clk <=~clk;

endmodule
