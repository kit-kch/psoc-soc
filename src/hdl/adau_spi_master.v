`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//
// Description:
// SPI master interface to send commands to the ADAU chip.           
// 
//////////////////////////////////////////////////////////////////////////////////


module adau_spi_master(
    input clk,
    input reset,

    input [31:0] data_in,
    input valid,
    output ready,

    output cdata,
    output cclk,
    output reg clatch_n,
    
    // some example debug signals
    output [2:0] led
    );


    // Placeholder example debug code. Replace with your SPI implementation
    assign ac_addr0_clatch = 'b0;
    assign ac_addr1_cdata = 'b0;
    assign ac_scl_cclk = 'b0;
    assign ready = 'b0;
    assign cdata = 'b0;
    assign cclk = 'b0;
    
    reg [2:0] ledreg = 0;
    reg [24:0] counter = 0;

    assign led = ledreg;
    always @(posedge clk) begin
        clatch_n = 'b0;
        if(reset) begin
            ledreg <= 0;
        end
        else begin
            if (counter == 0) begin
                if(ledreg == 0)
                    ledreg <= 1;
            else
                ledreg <= {ledreg[1:0], 1'b0}; 
            end
            counter <= counter +1;   
        end
    end

endmodule