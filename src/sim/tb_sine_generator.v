`timescale 1ns/1ps

module tb_sine_generator;
   reg clk = 0;
   always #10 clk <= ~clk;

   reg reset = 1;
   reg ready = 0;

   wire [23:0] out;
   wire valid;

   sine_generator uut
     (
      // Outputs
      .valid            (valid),
      .out              (out[23:0]),
      // Inputs
      .clk              (clk),
      .reset            (reset),
      .ready            (ready)
      );

   task next_sample;
      begin
         fork
            begin: waiting
               @(posedge clk);
               while(!valid)
                 @(posedge clk);
               disable timeout;
            end
            begin: timeout
               #1000 disable waiting;
               $error("VALID did not rise after waiting 1000ns");
            end
         join
      end
   endtask

   task check;
      input [23:0] want;
      begin
         next_sample;
         if(out !== want)
           $error("bad output data (want: %06x, got: %06x)", want, out);
      end
   endtask

   initial begin
      repeat(5) @(posedge clk);
      reset <= 0;

      $display("checking the first 5 samples");
      ready <= 1;
      check(24'h000000);
      check(24'h000000);
      check(24'h08d4b3);
      check(24'h119ea1);
      check(24'h1a5310);
      check(24'h22e761);

      $display("testing periodicity (output should repeat after 91 samples)");
      repeat(91 - 5)
        next_sample;
      check(24'h000000);
      check(24'h08d4b3);
      check(24'h119ea1);

      $display("testing that OUT is static when READY is low");
      ready <= 0;
      check(24'h1a5310);

      $display("testing that OUT changes after pulling READY high again");
      ready <= 1;
      check(24'h22e761);

      $finish;
   end
endmodule
