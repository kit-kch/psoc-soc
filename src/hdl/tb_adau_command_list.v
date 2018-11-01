module tb_adau_command_list();
   reg clk = 0;
   always #10 clk <= ~clk;

   wire [31:0] command;
   wire command_valid;
   wire init_done;
   reg reset;
   reg spi_ready;

   adau_command_list uut
     (
      // Outputs
      .command (command),
      .command_valid (command_valid),
      .init_done (init_done),
      // Inputs
      .clk (clk),
      .reset (reset),
      .spi_ready (spi_ready)
      );

   integer i;
   reg [31:0] cmds[0:4];

   initial begin
      $timeformat(-9, 5, " ns", 10);

      reset = 1;
      #100 ;
      reset <= 0;
      @(posedge clk);

      if(init_done !== 0)
        $error("INIT_DONE must be low after a reset");
      if(command_valid !== 1)
        $error("COMMAND_VALID must be high after a reset");

      fork
         begin: check_stable
            forever begin
               @(command);
               $error("COMMAND changed while SPI_READY is low");
            end
         end
         begin
            repeat(10)
              @(posedge clk);
            disable check_stable;
         end
      join

      cmds[0] = 32'h00_0000_00;
      cmds[1] = 32'h00_0000_00;
      cmds[2] = 32'h00_0000_00;
      cmds[3] = 32'h01_4000_01;
      cmds[4] = 32'h01_40f9_ff;

      spi_ready <= 1;
      for(i = 0; i < 5; i = i + 1) begin
         @(posedge clk);
         if(command !== cmds[i])
           $display("wrong command #%0d: want=%06x, got=%06x", i, cmds[i], command);
      end

      fork
         begin: timeout
            repeat(1000)
              @(posedge clk);
            disable wait_until_not_valid;
            $error("COMMAND_VALID did not go low after waiting for 1000 clocks");
         end
         begin: wait_until_not_valid
            @(negedge command_valid);
            disable timeout;
            spi_ready <= 0;
         end
      join

      @(posedge clk);
      if(init_done === 1)
        $error("INIT_DONE is high, even though SPI_READY is not");

      spi_ready <= 1;
      @(posedge clk);
      if(init_done === 0)
        $error("INIT_DONE did not go high");

      $finish;
   end

endmodule
