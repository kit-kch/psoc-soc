module tb_fpga_standalone_top();
    reg clk;
    initial clk <= 0;
    always #10.173 clk <= ~clk;

    reg arst;
    initial arst <= 1;

    fpga_standalone_top uut(
            .clk(),
            .arst(),
            .i2s_mclk(),
            .i2s_sdata(),
            .i2s_sclk(),
            .i2s_lrclk()
        );

    initial begin
        $display("Test OK");
        $finish;
    end

endmodule