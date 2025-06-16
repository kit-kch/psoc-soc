module tb_psoc_dac();
    // Generate clocks
    reg clk;
    reg clk_en;
    initial clk <= 0;
    initial clk_en <= 1;
    always #10.173 clk <= ~clk;

    wire phone_l, phone_r;
    wire fifo_ready;
    reg rst;
    reg [47:0] fifo_data;


    psoc_dac uut(
        .clk(clk),
        .rst(rst),
        .enable(1'b1),
        .fifo_data(fifo_data),
        .fifo_ready(fifo_ready),
        .phone_l(phone_l),
        .phone_r(phone_r)
    );

    task do_reset;
        begin
            rst <= 1;
            repeat (10)
                @(posedge clk);

            rst <= 0;
            repeat (10)
                @(posedge clk);
        end
    endtask

    task send_frame;
    input [23:0] send_l, send_r;
    begin
            fifo_data = {send_l,send_r};
            @(negedge fifo_ready);
    end    
    endtask

    initial begin
        $timeformat(-9, 5, " ns", 10);
        rst = 1;
        fifo_data = 'b0;
        do_reset;
        
        // Push some test data into the FIFO.
        send_frame(0, 0);
        send_frame(2048, 2048);
        send_frame(-2048, -2048);
        send_frame(8388607, 8388607);
        send_frame(-8388608, -8388608);
        @(negedge fifo_ready);

        $display("Test OK");
        $finish;
    end
endmodule