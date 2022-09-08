`timescale 1ns/1ps
//Date: 08.09.2022
//Author: Marc Neu
//Description: Sycrhonizes reset to main clock


module reset_logic(
        input clk,        
        input arst,
        output reg rst
);

    always @(posedge clk)
        if (arst == 1) 
            rst <= 0;
        else
            rst <= 1;

endmodule