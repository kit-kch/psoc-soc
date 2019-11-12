`timescale 1ns/1ps

module tb_sine_generator;
    // Generate clock
    reg clk = 0;
    always #10 clk <= ~clk;

    reg reset = 1;
    reg ready = 0;

    wire [23:0] out;
    wire valid;

    sine_generator uut(
        // Outputs
        .valid            (valid),
        .out              (out[23:0]),
        // Inputs
        .clk              (clk),
        .reset            (reset),
        .ready            (ready)
    );

    // Wait at least till next rising edge when valid=1
    // Timeout after 1000 ns
    task next_sample;
        begin
            fork
                begin: waiting
                    @(posedge clk);
                    while (!valid)
                        @(posedge clk);
                    disable timeout;
                end
                begin: timeout
                    #1000 disable waiting;
                    $error("VALID did not rise after waiting 1000ns");
                    $finish;
                end
            join
        end
    endtask

    task check;
        input [23:0] want;
        begin
            next_sample;
            if (out !== want) begin
                $error("bad output data (want: %06x, got: %06x)", want, out);
                $finish;
            end
        end
    endtask

    initial begin
        // Keep reset high
        repeat(5)
            @(posedge clk);
        reset <= 0;

        // TODO: Adjust to your expected values
        $display("checking the first 5 samples");
        ready <= 1;
        // Note: If your sin generator immed
        check(24'h000000);
        check(24'h08edc7);
        check(24'h11d06c);
        check(24'h1a9cd9);
        check(24'h234815);

        // TODO: Adjust to your expected number of samples
        $display("testing periodicity (output should repeat after 91 samples)");
        repeat(90 - 5)
            next_sample;

        // TODO: Adjust to your expected values
        check(24'h000000);
        check(24'h08edc7);
        check(24'h11d06c);

        $display("testing that OUT is static when READY is low");
        ready <= 0;
        check(24'h1a9cd9);

        $display("testing that OUT changes after pulling READY high again");
        ready <= 1;
        // h1a5310 was not read yet
        check(24'h1a9cd9);
        check(24'h234815);

        $display("Test OK");
        $finish;
    end
endmodule
