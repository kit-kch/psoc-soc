module tb_adau_command_list();
    reg clk = 0;
    always #100 clk <= ~clk;

    wire [31:0] command;
    wire command_valid;
    wire adau_init_done;
    reg reset;
    reg spi_ready;

    adau_command_list uut(
        .command (command),
        .command_valid (command_valid),
        .adau_init_done (adau_init_done),

        .clk (clk),
        .reset (reset),
        .spi_ready (spi_ready)
    );

    reg [31:0] cmds[0:4];
    reg [31:0] cmd_last;

    task receive_validate;
        // index where to start validating
        input integer cmd_index;
        // stop receiving at this index
        input integer cmd_stop;
        // whether to validate or to just receive
        input validate;

        reg done;

        begin
            spi_ready <= 1;
            done = 0;
            while (!done) begin
                @(posedge clk);
                if (command_valid == 1 && spi_ready == 1) begin
                    if (validate && command !== cmds[cmd_index]) begin
                        $error("wrong command #%0d: want=%06x, got=%06x", cmd_index, cmds[cmd_index], command);
                        #10 ;
                        $finish;
                    end

                    cmd_index = cmd_index  + 1;
                    if (cmd_index == cmd_stop)
                        done = 1;
                end
            end
        end
    endtask

    initial begin
        $timeformat(-9, 5, " ns", 10);

        reset = 1;
        #100 ;
        reset <= 0;
        @(posedge clk);

        if (adau_init_done !== 0) begin
            $error("ADAU_INIT_DONE must be low after a reset");
            #10 ;
            $finish;
        end
        if (command_valid !== 1) begin
            $error("COMMAND_VALID must be high after a reset");
            #10 ;
            $finish;
        end

        // The CMDs we expect
        cmds[0] = 32'h00_0000_00;
        cmds[1] = 32'h00_0000_00;
        cmds[2] = 32'h00_0000_00;
        cmds[3] = 32'h00_4000_01;
        cmds[4] = 32'h00_40f9_ff;

        // Read and verify first four CMDs
        receive_validate(0, 4, 1);

        // Set ready low, should not get further data
        cmd_last <= 32'hxxxxxxxx;
        spi_ready <= 0;
        repeat (100) begin
            @(posedge clk);
            if (command_valid == 1) begin
                if (cmd_last != 32'hxxxxxxxx && cmd_last != command) begin
                    $error("Command should not change while valid is 1 and ready is 0. old=%06x, new=%06x", cmd_last, command);
                    #10 ;
                    $finish;
                end
                cmd_last = command;
            end
        end

        // Read and verify next CMD
        receive_validate(4, 5, 1);

        // Delay, then receive 10 more words
        // TODO: Adjust this, so it matches your last data word sent!
        repeat (10) begin
            spi_ready <= 0;
            repeat (10)
                @(posedge clk);

            receive_validate(0, 1, 0);
        end

        // TODO: Make sure you read all words until here, except for the last one!

        // Simulate that it takes some time until ready goes high
        spi_ready <= 0;
        repeat (10) begin
            @(posedge clk);
            // init_done should only go high once spi_master is ready again / has sent all data
            if (adau_init_done === 1) begin
                $error("adau_init_done is high, even though SPI_READY is not");
                #10 ;
                $finish;
            end
        end

        // No we're ready, do the last handshake
        spi_ready <= 1;
        @(posedge clk);
        #1 ;
        // And now adau_init_done should be high
        if (adau_init_done == 0) begin
            $error("adau_init_done did not go high");
            #10 ;
            $finish;
        end

        $display("Test OK");
        #10 ;
        $finish;
    end

endmodule
