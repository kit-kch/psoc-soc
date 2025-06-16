// Date: 16.06.2025
// Author: Johannes Pfau
// Description: Simple Delta-Sigma DAC module
//
// Based on: https://www.fpga4fun.com/PWM_DAC_2.html
//           https://www.fpga4fun.com/PWM_DAC_3.html 
// See also: https://dsp.stackexchange.com/questions/69004/how-does-the-worlds-simplest-sigma-delta-dac-work
//           https://www.edaboard.com/threads/resolution-of-a-sigma-delta-modulator.280812/
//           https://www.beis.de/Elektronik/DeltaSigma/DeltaSigma_D.html

module psoc_dac(
        // system clock
        input clk,
        input rst,
        input enable,

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
                clk_en_2048 <= 1;
            else if (c == 1)
                clk_en_2048 <= 0;

            c <= c + 1;
        end
    end

    // This is our FIFO read signal
    assign fifo_ready = clk_en_2048 & enable;


    // Add 2^(24-1). The most negative value is -2^(24-1) so this ensures
    // we only see positive values. The output will be centered around
    // 2^(24-1), i.e. half of the value range.
    localparam [23:0] OFFSET = 24'h800000;
    wire signed [23:0] fifo_r = fifo_data[47:24];
    wire signed [23:0] fifo_l = fifo_data[23:0];
    reg [23:0] shifted_r, shifted_l;

    always @(posedge clk) begin
        if (rst) begin
            shifted_r <= 0;
            shifted_l <= 0;
        end else begin
            if (fifo_ready) begin
                shifted_r <= fifo_r + OFFSET;
                shifted_l <= fifo_l + OFFSET;
            end
        end
    end

    // Now implement the delta-sigma modulator
    reg[24:0] accum_r, accum_l;
    always @(posedge clk) begin
        if (rst || !enable) begin
            accum_r <= 0;
            accum_l <= 0;
        end else begin
            accum_r <= accum_r[23:0] + shifted_r;
            accum_l <= accum_l[23:0] + shifted_l;
        end
    end
    assign phone_l = accum_r[24];
    assign phone_r = accum_l[24];

endmodule