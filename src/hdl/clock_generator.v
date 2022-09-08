// Date:   08.9.2022
// Author: Marc Neu
// Description: 
//  Generates Clock Emabel Signals for for the I2S.
//  Clock Signals are Sychronous to the input clock
//  Phase relation from input to clock enables is not deterministic

module clock_generator(
        input clk,
        input rst,

        output  reg clk_en_2,
        output  reg clk_en_4,
        output  reg clk_en_8,
        output  reg clk_en_16
);

    reg [3:0] c;

    wire c_2;
    wire [1:0] c_4;
    wire [2:0] c_8;
    wire [3:0] c_16;

    assign c_2 = c[0];
    assign c_4 = c[1:0];
    assign c_8 = c[2:0];
    assign c_16 = c;


    initial begin
        clk_en_2 <= 0;
        clk_en_4 <= 0;
        clk_en_8 <= 0;
        clk_en_16 <= 0;
        c <= 0;
    end

    always @(posedge clk) begin
        if(rst) begin
            clk_en_2 <= 0;
            clk_en_4 <= 0;
            clk_en_8 <= 0;
            clk_en_16 <= 0;
            c <= 0;
        end else begin
            if(c_2 == 0)
                clk_en_2 <= 1;
            else
                clk_en_2 <= 0;

            if(c_4 == 0)
                clk_en_4 <= 1;
            else
                clk_en_4 <= 0;

            if(c_8 == 0)
                clk_en_8 <= 1;
            else
                clk_en_8 <= 0;

            if(c_16 == 0)
                clk_en_16 <= 1;
            else
                clk_en_16 <= 0;

            c <= c + 1;
        end
    end

endmodule