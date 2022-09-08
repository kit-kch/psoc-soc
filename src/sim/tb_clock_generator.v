module tb_clock_generator();
    reg clk;
    initial clk <= 0;
    always #10 clk <= ~clk;
    reg rst;
    initial rst <= 1;

    wire [3:0] clk_en;


    clock_generator uut(
        .clk(clk),
        .rst(rst),
        .clk_en_2(clk_en[0]),
        .clk_en_4(clk_en[1]),
        .clk_en_8(clk_en[2]),
        .clk_en_16(clk_en[3])
    );

    task check_clk;
        input[3:0] is, want;
        begin
            $display("Check Clocks (is=4'b%04b, want_r=4'b%04b) @ %t", is, want, $time);
            if(is !== want) begin
                $error("There is something wrong with your clock enables... @ %t", $time);
                #100
                $finish;           
            end
        end
    endtask

    task do_reset;
        begin
            rst <= 1;
            repeat(5)
                @(posedge clk);
            rst <= 0;
        end
    endtask

    initial begin
        $timeformat(-9, 5, " ns", 10);
        do_reset;
        @(posedge clk);
        check_clk(clk_en,4'b0000);
        @(posedge clk);
        check_clk(clk_en,4'b1111);
        @(posedge clk);
        check_clk(clk_en,4'b0000);
        @(posedge clk);
        check_clk(clk_en,4'b0001);
        @(posedge clk);
        check_clk(clk_en,4'b0000);
        @(posedge clk);
        check_clk(clk_en,4'b0011);
        @(posedge clk);
        check_clk(clk_en,4'b0000);
        @(posedge clk);
        check_clk(clk_en,4'b0001);
        @(posedge clk);
        check_clk(clk_en,4'b0000);
        @(posedge clk);
        check_clk(clk_en,4'b0111);
        @(posedge clk);
        check_clk(clk_en,4'b0000);
        @(posedge clk);
        check_clk(clk_en,4'b0001);
        @(posedge clk);
        check_clk(clk_en,4'b0000);
        @(posedge clk);
        check_clk(clk_en,4'b0011);
        @(posedge clk);
        check_clk(clk_en,4'b0000);
        @(posedge clk);
        check_clk(clk_en,4'b0001);
        @(posedge clk);
        check_clk(clk_en,4'b0000);
        @(posedge clk);
        check_clk(clk_en,4'b1111); 

        $display("Test OK");
        $finish;

    end


endmodule

