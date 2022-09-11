//Date: 11.09.2022
//Author: Johannes Pfau
//Description: Dummy DAC module for FPGA target

module psoc_dac(
        // system clock
        input clk,
        input rst,

        // FIFO signals
        input [47:0] fifo_data,
        output fifo_ready,

        // Analog outputs (unused in FPGA)
        output phone_l,
        output phone_r
    );

    // Generate a single clock cycle every 2048 clks (= 48 kHz frequency)
    reg clk_en_2048;
    reg [10:0] c;

    always @(posedge clk) begin
        if(rst) begin
            clk_en_2048 <= 0;
            c <= 0;
        end else begin
            if (c == 0)
                clk_en_2048 <= 0;
            else if (c == 1)
                clk_en_2048 <= 1;

            c <= c + 1;
        end
    end

    // This is our FIFO read signal
    assign fifo_ready = clk_en_2048;

    // dummy: On FPGA, just return the lowest bit in each channel.
    assign phone_l = fifo_data[0];
    assign phone_r = fifo_data[24];

endmodule