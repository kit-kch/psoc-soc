module tb_fpga_soc_top();
    reg clk;
    initial clk <= 0;
    always #5.087 clk <= ~clk;

    reg arstn;
    initial arstn <= 0;

    wire [31:0] pads;
    assign pads[31] = arstn;
    assign pads[30] = clk;

    fpga_soc_top uut(
        .pads(pads)
    );


    task do_reset;
        begin
            repeat(10)
                @(posedge clk);
            arstn <= 1;
        end
    endtask

    initial begin
        do_reset;
        repeat(100)
            @(posedge clk);
        $display("Test OK");
        $finish;
    end

endmodule
