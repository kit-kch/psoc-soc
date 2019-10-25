module tb_spi_full();
    reg clk = 0;
    reg reset = 1;

    wire [31:0] cmd_data;
    wire cmd_valid;
    wire cmd_init_done;

    wire spi_cclk;
    wire spi_cdata;
    wire spi_clatch_n;
    wire spi_ready;

    adau_command_list cmd(
        .command (cmd_data),
        .command_valid (cmd_valid),
        .adau_init_done (cmd_init_done),

        .clk (clk),
        .reset (reset),
        .spi_ready (spi_ready)
    );

    adau_spi_master spi(
        .ready (spi_ready),
        .cdata (spi_cdata),
        .cclk (spi_cclk),
        .clatch_n (spi_clatch_n),

        .clk (clk),
        .reset (reset),
        .data_in (cmd_data),
        .valid (cmd_valid)
    );

    // Generate CKL
    always #100 clk <= ~clk;

    initial begin
        repeat (10)
            @(posedge clk);
        
        reset <= 0;
    end

endmodule
