// Author: Marc Neu
// Date: 16.09.2022
// Description: I2S Master Peripheral

module i2s_master(
        input clk,
        input rst,
        input clk_en,
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
        lrclk = 1;
        sclk_counter = 63;
        buffer = 0;
        sclk = 0;
        request_fifo = 0;
        fifo_ready = 0;
    end

    /*
    Generate MCLK Signal
    */
    always @(posedge clk) begin
        if (rst == 1) begin
            mclk <= 0;
        end else if(clk_en == 1) begin
            if(mclk_en == 1)
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
        end else if(clk_en == 1) begin
            if(sclk_en == 1) begin            
                sclk <= ~sclk;
                if(sclk == 1)
                    sclk_counter <= sclk_counter + 1;
            end
        end
    end

    /*
    Main State Machine containing serial shift register for I2S Master. Clock counter is used for state definition.
        sclk_counter == 0:
            Read data from intermediate input register (fifo_reg). Reset request_fifo flag
        sclk_counter == 32:
            Change LRCLK from low to high to adjust output channel.
        sclk_counter == 64:
            Send last bit. Assert request_fifo flag indicating a data request.
        others:
            Shift buffer register, send MSB first. 
    */
    always @(posedge clk) begin
        if (rst == 1) begin
            lrclk <= 1;
            buffer <= 64'h0000000000000000;
            request_fifo <= 1;
        end else if(clk_en == 1) begin
            if(sclk_en == 1) begin
                if(sclk == 1) begin
                    if(sclk_counter == 0) begin
                        lrclk <= 0;
                        buffer <= {fifo_reg[47:24],8'h00,fifo_reg[23:0],8'h00};
                        request_fifo <= 0;
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
    end

    /* 
    FIFO Process. Read Data from FIFO when requested. For simplicity it is assumed that the FIFO is !never! empty.
    Module interface is not AXI-Stream compatible
    */
    always @(posedge clk)
        if (rst == 1) begin
            fifo_ready <= 0;
            fifo_reg <= 48'h000000000000;
        end else if (clk_en == 1) begin
            if (sclk == 1 && sclk_en == 1 && request_fifo == 1) begin
                if(fifo_valid == 1) begin
                    fifo_reg <= fifo_data;
                    fifo_ready <= 1;
                end else begin
                    fifo_reg <= 48'h000000000000;
                    fifo_ready <= 0;
                end
            end else
                fifo_ready <= 0;
        end
    
endmodule
