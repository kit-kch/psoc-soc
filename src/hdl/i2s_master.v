`timescale 1ns/1ps

module i2s_master(
        input clk,        
        input rst,
        input mclk_en,
        input sclk_en,

        output reg mclk,
        output reg sclk,
        output reg lrclk,
        output sdata,

        input [47:0] fifo_data,
        input fifo_valid,
        output reg fifo_ready
    );

    reg [47:0] fifo_reg;
    reg [5:0] sclk_counter;
    reg [63:0] buffer;
    assign sdata = buffer[63];

    reg request_fifo;

    initial begin
        lrclk <= 1;
        sclk_counter <= 63;
        buffer <= 0;
        sclk <= 0;
        request_fifo <= 0;
        fifo_ready <= 0;
    end

    /*
    Generate MCLK Signal
    */
    always @(posedge clk) begin
        if (rst == 1) begin
            mclk <= 0;
        end else if(mclk_en == 1) begin
            mclk <= ~mclk;
        end
    end

    /*
    Generate SCLK Signal and Counter Number of SCLK Periods.
    */
    always @(posedge clk) begin
        if (rst == 1) begin
            sclk <= 0;
            sclk_counter <= 63;
        end else if(sclk_en == 1) begin
            sclk <= ~sclk;
            if(sclk == 1)
                sclk_counter <= sclk_counter + 1;
        end
    end

    always @(posedge clk) begin
        if (rst == 1) begin
            lrclk <= 1;
            buffer <= 64'h0000000000000000;
            request_fifo <= 0;
        end else if(sclk_en == 1) begin
            if(sclk == 1) begin
                if(sclk_counter == 0) begin
                    lrclk <= 0;
                    buffer[63:40] = fifo_reg[47:24];
                    buffer[39:32] = 8'b00000000;
                    buffer[31:8] = fifo_reg[23:0];
                    buffer[7:0] = 8'b00000000;
                end else if (sclk_counter < 31) begin
                    lrclk <= 0;
                    buffer <= buffer << 1; 
                end else if (sclk_counter < 63) begin
                    lrclk <= 1;
                    buffer <= buffer << 1;
                end else begin
                    lrclk <= 0;
                    buffer <= buffer << 1;
                    request_fifo <= 1;
                end
            end
        end
    end

    always @(posedge clk) begin
        if(rst == 1)
            fifo_reg <= 48'h000000000000;
        else if(fifo_valid == 1) begin
            if(request_fifo == 1) begin
                fifo_reg <= fifo_data;
                fifo_ready <= 1;
                request_fifo <= 0;
            end else
                fifo_ready <= 0;
        end else begin
            if(request_fifo == 1)
                fifo_ready <= 1;
            else
                fifo_ready <= 0;
        end
    end
    
endmodule
