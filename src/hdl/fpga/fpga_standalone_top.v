//////////////////////////////////////////////////////////////////////////////////
//
// Description:
// Standalone top module which does not include the neorv32 processor.
//
//////////////////////////////////////////////////////////////////////////////////

module fpga_standalone_top(
        // System signals
        input clk,
        input arstn,

        // I2S signals
        output i2s_mclk,
        output i2s_sdata,
        output i2s_sclk,
        output i2s_lrclk,

        // General purpose signals
        output [1:0] gpio_o
    );

    //Wire definitions go here
    wire rst;
    wire clk_en_4;
    wire clk_en_16;

    wire [23:0] sin_data;
    wire [47:0] fifo_data_in;
    wire fifo_write;
    wire fifo_full;
    wire [47:0] fifo_data_out;
    wire fifo_empty;
    wire fifo_read;

    //Wire assigments go here
    assign fifo_data_in = {sin_data, sin_data};

    //Module instatiations go here

    reset_logic reset_logic(
        .clk(clk),
        .arstn(arstn),
        .rst(rst)
    );

    led_blink led(
        .clk(clk),
        .rst(rst),
        .led(gpio_o)
    );

    clock_generator clk_gen(
        .clk(clk),
        .rst(rst),
        .clk_en_2(),
        .clk_en_4(clk_en_4),
        .clk_en_8(),
        .clk_en_16(clk_en_16)
    );

    sfifo #(.BW(48), .LGFLEN(4)) fifo(
        .i_clk(clk),
        .i_wr(fifo_write),
        .i_data(fifo_data_in),
        .o_full(fifo_full),
        .o_fill(),
        .i_rd(fifo_read),
        .o_data(fifo_data_out),
        .o_empty(fifo_empty)
    );

    i2s_master i2s(
        .clk(clk),
        .clk_en(1),
        .mclk_en(clk_en_4),
        .sclk_en(clk_en_16),
        .rst(rst),

        .fifo_data(fifo_data_out),
        .fifo_valid(!fifo_empty),
        .fifo_ready(fifo_read),

        .mclk(i2s_mclk),
        .sclk(i2s_sclk),
        .lrclk(i2s_lrclk),
        .sdata(i2s_sdata)
    );

    sine_generator sin(
        .clk(clk),
        .reset(rst),
        .valid(fifo_write),
        .ready(!fifo_full),
        .out(sin_data)
    );
endmodule
