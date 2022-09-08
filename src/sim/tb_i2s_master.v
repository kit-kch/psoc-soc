`timescale 1ns/1ps

// This testbench assumes the following:
// - set LRCLK at 50% duty cycle
// - SDATA read when BCLK falls
// - audio frames begin when LRCLK falls
// - 2 channels per frame
// - ADAU is the I2S slave
// - 48 BCLK cycles per audio frame
// - left channel first
// - MSB first
// - data starts one BCLK after the LRCLK edge (Data delay from LRCLK edge (in BCLK units))
module tb_i2s_master();
    // Generate clocks
    reg clk;
    initial clk <= 0;
    always #10.173 clk <= ~clk;

    reg [1:0] mclk_counter;
    initial mclk_counter <= 0;
    reg mclk_en;
    initial mclk_en <= 0;
    always @(posedge clk) begin
        mclk_counter <= mclk_counter + 1;
        if(mclk_counter == 0)
            mclk_en <= 1;
        else
            mclk_en <= 0;
    end

    reg [3:0] sclk_counter;
    initial sclk_counter <= 0;
    reg sclk_en;
    initial sclk_en <= 0;
    always @(posedge clk) begin
        sclk_counter <= sclk_counter + 1;
        if(sclk_counter == 0)
            sclk_en <= 1;
        else
            sclk_en <= 0;
    end

    // i2s_master signals
    wire sclk;
    wire lrclk;
    wire sdata;
    reg rst;
    reg [47:0] fifo_data;
    reg fifo_valid;
    wire fifo_ready;

    i2s_master uut(
        .sclk(sclk),
        .lrclk(lrclk),
        .sdata(sdata),
        .clk(clk),
        .sclk_en(sclk_en),
        .mclk_en(mclk_en),
        .rst(rst),
        .fifo_data(fifo_data),
        .fifo_ready(fifo_ready),
        .fifo_valid(fifo_valid)
    );

    task receive_frame;
        input [23:0] want_l, want_r;
        reg [23:0] l, r;
        integer count;
        begin
            $display("receive_frame(want_l=24'h%06x, want_r=24'h%06x) @ %t", want_l, want_r, $time);
            fork
                begin: receive
                    // Left sample
                    count = 0;
                    while (!lrclk) begin
                        @(posedge sclk or posedge lrclk);
                        if(sclk) begin
                            if (count > 32) begin
                                $error("got more BCLK edges than expected (> 31) while receiving the left sample");
                                #100
                                $finish;
                            end else if (count > 0 && count < 25)
                                l[24-count] = sdata;
                            count = count + 1;
                        end
                    end
                    if (count < 31) begin
                        $error("got less BCLK edges than expected (want 32, got %0d)", count);
                        #100
                        $finish;
                    end
                    if (want_l !== l) begin
                        $error("left sample was received incorrectly (want %06x, got %06x)", want_l, l);
                        #100
                        $finish;
                    end

                    // Right sample
                    count = 0;
                    while (lrclk) begin
                        @(posedge sclk or negedge lrclk);
                        if(sclk) begin
                            if (count > 32) begin
                                $error("got more BCLK edges than expected (> 32) while receiving the left sample");
                                #100
                                $finish;
                            end else if (count > 0 && count < 25)
                                r[24-count] = sdata;
                            count = count + 1;
                        end
                    end
                    if (count < 31) begin
                        $error("got less BCLK edges than expected (want 32, got %0d)", count);
                        #100
                        $finish;
                    end
                    if (want_r !== r) begin
                        $error("right sample was received incorrectly (want %06x, got %06x)", want_r, r);
                        #100
                        $finish;
                    end

                    disable timeout;
                end

                begin: timeout
                    #120000;
                    disable receive;
                    $error("Frame transfer timed out (waited for 120us)");
                    #100
                    $finish;
                end
            join
        end
    endtask

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
            @(posedge clk);
            fifo_valid = 1;
            fifo_data = {send_l,send_r};
            @(negedge fifo_ready);
    end    
    endtask

    initial begin
        $timeformat(-9, 5, " ns", 10);
        rst = 1;
        fifo_valid = 0;
        do_reset;

        
        // Push some test data into the FIFO.
        
        fork
            begin: send
                $display("sending 0xFFFFFF 0xFFFFFF");
                send_frame(24'hFFFFFF, 24'hFFFFFF);
                $display("sending 0x123456 0xabcdef");
                send_frame(24'h123456, 24'habcdef);
                $display("sending 0x000000 0x000000");
                send_frame(24'h000000, 24'h000000);
                $display("sending 0x7a1cff 0x001300");
                send_frame(24'h7a1cff, 24'h001300);
                $display("sending 0x8a1eaa 0x001400");
                send_frame(24'h8a1eaa, 24'h001400);
                $display("sending 0x9a1dff 0x001500");
                send_frame(24'h9a1dff, 24'h001500);

            end

            begin: receive
                @(negedge lrclk);
                receive_frame(24'hFFFFFF, 24'hFFFFFF);
                receive_frame(24'h123456, 24'habcdef);
                receive_frame(24'h000000, 24'h000000);
                receive_frame(24'h7a1cff, 24'h001300);
                receive_frame(24'h8a1eaa, 24'h001400);
                receive_frame(24'h9a1dff, 24'h001500);                
            end
        join

        $display("Test OK");
        $finish;
    end
endmodule
