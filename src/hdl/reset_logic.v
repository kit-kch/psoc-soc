//Date: 08.09.2022
//Author: Marc Neu
//Description: Synchronizes reset to main clock


module reset_logic(
        input clk,
        input arst,
        output reg rst
);

    initial rst <= 0;

    always @(posedge clk)
        if (arst == 1) 
            rst <= 1;
        else
            rst <= 0;

endmodule
