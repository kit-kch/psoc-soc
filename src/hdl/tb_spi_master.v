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
   adau_spi_master uut
     (
      // Outputs
      .ready (ready),
      .cdata (cdata),
      .cclk (cclk),
      .clatch_n (clatch_n),
      // Inputs
      .clk (clk),
      .reset (reset),
      .data_in (data_in),
      .valid (valid)
      );

   initial clk <= 0;
   always #4.167 clk <= ~clk;

   specify
      $period(posedge cclk, 50);
      $width(posedge clatch_n, 10);
      $width(negedge clatch_n, 10);
   endspecify

   always @(cdata) begin
      if(cclk !== 0)
        $error("CDATA changed while CCLK is high");
   end

   task do_reset;
      begin
         reset <= 1;
         repeat(50)
           @(posedge clk);
         reset <= 0;
         @(negedge clk);
         if(ready !== 1)
           $error("READY must be high after a reset");
      end
   endtask

   task receive_bits;
      input [31:0] expected;
      integer count;
      reg timeout;
      reg [31:0] bits;
      begin
         count = 0;
         timeout = 0;
         timeout <= #50000 1;
         @(negedge clatch_n or timeout);
         if(timeout) begin
            $error("no negative edge on CLATCH_N after waiting for 50us");
         end else begin
            while(clatch_n !== 1) begin
               @(posedge cclk or clatch_n or timeout);
               if(timeout) begin
                  $error("transfer took longer than expected (waited for 50us)");
               end else if(clatch_n === 1) begin
                  // loop will end
               end else begin
                  bits[31 - count] = cdata;
                  count = count + 1;
                  if(count > 32)
                    $error("received more than 32 edges on CCLK");
               end
            end
            if(bits !== expected)
              $error("received incorrect data (want: %08x, got: %08x)", expected, bits);
         end
      end
   endtask

   initial begin
      $timeformat(-9, 5, " ns", 10);

      valid <= 0;
      do_reset;

      $display("test 1: sending 32'h1234_5678 @ t=%t", $time);
      data_in <= 32'h1234_5678;
      valid <= 1;
      @(posedge clk);
      fork
         begin
            @(posedge clk);
            if(ready !== 0)
              $error("READY did not go low after the transfer was started");
         end
         begin
            data_in <= 32'hx;
            valid <= 0;
            receive_bits(32'h1234_5678);
         end
      join
      #1000 ;
      if(ready !== 1)
        $error("READY did not go high after the transfer was finished");

      do_reset;

      $display("test 2: sending 32'hf000_00ba, followed by 32'hc000_ffee @ t=%t", $time);
      data_in <= 32'hf000_0baa;
      valid <= 1;
      @(posedge clk);
      data_in <= 32'hc000_ffee;
      valid <= 1;
      fork
         receive_bits(32'hf000_0baa);
         begin
            @(posedge ready);
            @(posedge clk);
            data_in <= 32'hxxxx_xxxx;
            valid <= 0;
         end
      join
      receive_bits(32'hc000_ffee);

      $finish;
   end
endmodule
