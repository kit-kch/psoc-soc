`timescale 1ns / 1ps

module tb_spi_master();
    wire cclk;
    wire cdata;
    wire clatch_n;
    wire ready;

    reg clk;
    reg [31:0] data_in;
    reg reset;
    reg valid;

    reg [31:0] test_data [0:3];
    initial begin
        test_data[0] = 32'habcd0000;
        test_data[1] = 32'habcd0001;
        test_data[2] = 32'habcd0002;
        test_data[3] = 32'habcd0003;
    end

    adau_spi_master uut(
        .ready (ready),
        .cdata (cdata),
        .cclk (cclk),
        .clatch_n (clatch_n),

        .clk (clk),
        .reset (reset),
        .data_in (data_in),
        .valid (valid)
    );

    // Generate clk @5 MHz
    initial clk <= 0;
    always #100 clk <= ~clk;


    // Receive the data sent by SPI and check against test_data
    reg [31:0] receive_buf;
    // To check if clatch goes high
    reg clatch_was_high = 0;
    integer receive_bit = 0;
    integer receive_word = 0;

    initial begin
        while (1) begin
            if (clatch_n == 0)
                clatch_was_high = 1;

            @(posedge cclk) begin
                if (clatch_n == 0) begin
                    receive_buf[31 - receive_bit] = cdata;
                    receive_bit = receive_bit + 1;

                    if (receive_bit == 32) begin
                        $display("Received data (want: %08x, got: %08x)", test_data[receive_word], receive_buf);
                        if (clatch_was_high == 0)
                            $warning({"Clatch did not go high after word. This is OK for SPI, ",
                                "but make sure you get the 'pull clatch 3 times low' part for ",
                                "switching to SPI mode right!"});
                        clatch_was_high = 0;

                        receive_bit = 0;
                        if (receive_buf != test_data[receive_word]) begin
                            $error("Received incorrect data (want: %08x, got: %08x)", test_data[receive_word], receive_buf);
                            $finish;
                        end

                        receive_word = receive_word + 1;
                        if (receive_word == 4) begin
                            $display("Test OK");
                            $finish;
                        end
                        receive_buf = 32'hxxxxxxxx;
                    end
                end
            end
        end
    end


    // Pull reset high for 50 cycles
    task do_reset;
        begin
            // High for 50 cycles
            reset <= 1;
            repeat(50) begin
                @(posedge clk);
            end
            reset <= 0;
        end
    endtask


    // Pull reset high for 50 cycles
    task do_send;
        input integer index;

        reg sending;
        begin
            sending = 1;
            valid <= 1;

            data_in <= test_data[index];
            while (sending == 1) begin
                @(posedge clk);
                if (valid == 1 && ready == 1)
                    sending = 0;
            end

            valid <= 0;
        end
    endtask

    initial begin
        $timeformat(-9, 5, " ns", 10);

        valid <= 0;
        do_reset;

        // Immediately send after reset
        do_send(0);
        // send back-to-back (valid stays high)
        do_send(1);

        // wait some cycles (valid goes low)
        repeat(5) begin
            // May be invalid, as long as valid is low
            @(posedge clk);
            data_in = 31'hxxxxxxxx;
        end
        do_send(2);

        // Wait until 3rd word has been received
        while (receive_word != 3)
            @(receive_word)

        do_reset;
        do_send(3);

    end
endmodule
