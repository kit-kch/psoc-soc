module tb_thermometer_encoder();
    reg clk;
    reg reset;
    wire [255:0] thermometer_code;

    encoder_top encoder(
        .clk(clk),
        .reset(reset),
        .thermometer_code(thermometer_code)
    );

    always #2 clk <= ~clk;
    initial begin
        #0 clk = 0;
        #0 reset = 1;
        #5 reset = 0;

        #10000 $finish;
    end
endmodule
