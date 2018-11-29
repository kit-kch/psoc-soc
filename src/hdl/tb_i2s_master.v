`timescale 1ns/1ps

module tb_i2s_master();
   reg clk;
   initial clk <= 0;
   always #4.167 clk <= ~clk;

   wire bclk;
   wire full;
   wire lrclk;
   wire sdata;
   reg reset;
   reg write_frame;
   reg [47:0] frame_in;
   i2s_master uut
     (
      // Outputs
      .bclk (bclk),
      .lrclk (lrclk),
      .sdata (sdata),
      .full (full),
      // Inputs
      .clk_soc (clk),
      .ac_mclk (clk),
      .reset(reset),
      .frame_in (frame_in),
      .write_frame (write_frame)
      );

   specify
      $period(posedge bclk, 416.7);  // ~2.4MHz
      $period(posedge lrclk, 20834);  // 48kHz
      // SDATA changes when BCLK falls
   endspecify

   task receive_frame;
      input [23:0] want_l, want_r;
      reg [23:0] l, r;
      integer count;
      begin
         fork
            begin: receive
               while(lrclk)
                 @(lrclk);

               // Left sample
               count = 0;
               while(!lrclk) begin
                  @(posedge bclk or posedge lrclk);
                  if(lrclk) begin
                     // loop will end
                  end else if(bclk) begin
                     //if(count != 0) begin
                        l[23-count] = sdata;
                     //end
                     if(count > 24) begin
                        $error("got more BCLK edges than expected (> 24) while receiving the left sample");
                     end
                     count = count + 1;
                  end
               end
               if(count < 24)
                 $error("got less BCLK edges than expected (want 24, got %0d)", count);
               if(want_l !== l)
                 $error("left sample was received incorrectly (want %06x, got %06x)", want_l, l);

               // Right sample
               count = 0;
               while(lrclk) begin
                  @(posedge bclk or negedge lrclk);
                  if(!lrclk) begin
                     // loop will end
                  end else if(bclk) begin
                     if(count != 0) begin
                        r[24-count] = sdata;
                     end
                     if(count > 25) begin
                        $error("got more BCLK edges than expected (> 25) while receiving the right sample");
                     end
                     count = count + 1;
                  end
               end
               if(count < 25)
                 $error("got less BCLK edges than expected (want 25, got %0d)", count);
               if(want_r !== r)
                 $error("right sample was received incorrectly (want %06x, got %06x)", want_r, r);

               disable timeout;
            end

            begin: timeout
               #25000;
               disable receive;
               $error("Frame transfer timed out (waited for 25us)");
            end
         join
      end
   endtask

   task do_reset;
      begin
         reset <= 1;
         write_frame <= 0;
         repeat(10)
           @(posedge clk);
         reset <= 0;
         repeat(10)
           @(posedge clk);
      end
   endtask

   // Uncomment to display the received data:
   // reg [23:0] din;
   // reg last_lrclk = 0;
   // always @(posedge bclk) begin
   //    if(lrclk != last_lrclk) begin
   //       $display("%c %06x", last_lrclk ? "R" : "L", din);
   //       din <= 24'hx;
   //    end else begin
   //       din <= {din[22:0], sdata};
   //    end
   //    last_lrclk <= lrclk;
   // end

   // Uncomment to display FIFO writes:
   // always @(posedge clk) begin
   //    if(write_frame)
   //      $display("FIFO write: %06x %06x", frame_in[47:24], frame_in[23:0]);
   // end

   // Uncomment to display FIFO reads (you might need to change uut.{fifo_read, cur_frame}):
   // always @(posedge clk) begin
   //    if(uut.fifo_read)
   //      $display("FIFO read: %06x %06x", uut.cur_frame[47:24], uut.cur_frame[23:0]);
   // end

   integer i;

   initial begin
      $timeformat(-9, 5, " ns", 10);

      reset = 1;
      write_frame = 0;
      do_reset;

      wait (full == 0);

      // Push some test data into the FIFO.
      // Do this while CLK is stopped, to ensure the correct clock signal is used.
      @(posedge clk);
      write_frame <= 1;
      frame_in <= 48'h123456_abcdef;
      $display("sending 0x123456 0xabcdef");
      @(posedge clk);
      frame_in <= 48'h111111_222222;
      $display("sending 0x111111 0x222222");
      @(posedge clk);
      frame_in <= 48'h333333_444444;
      $display("sending 0x333333 0x444444");
      @(posedge clk);
      frame_in <= 48'h555555_666666;
      $display("sending 0x555555 0x666666");
      @(posedge clk);
      write_frame <= 0;

      // Check the received data.
      @(posedge clk);
      receive_frame(24'h000000, 24'h000000);  // The FIFO output is registered, so there is a delay of one frame before we receive valid data.
      receive_frame(24'h123456, 24'habcdef);
      receive_frame(24'h111111, 24'h222222);
      receive_frame(24'h333333, 24'h444444);
      receive_frame(24'h555555, 24'h666666);
      receive_frame(24'h000000, 24'h000000);

      /*
      // Test the transfer duration.
      do_reset;
      frame_in <= 48'haaaaaa_aaaaaa;
      write_frame <= 1;
      @(posedge clk);
      write_frame <= 0;
      enable <= 1;
      @(posedge clk);
      // 50 (clks per bclk) * (25 bclks per sample) = 1250 (bclks per sample)
      while(lrclk)
        @(negedge lrclk);
      repeat(1250)
        @(posedge clk);
      if(!lrclk)
        $error("Transfer took too long (should be exactly 1250 BCLKs per sample)");
      repeat(1250)
        @(posedge clk);
      if(lrclk)
        $error("Transfer took too long (should be exactly 1250 BCLKs per sample)");

      // Test the FULL flag.
      do_reset;

      frame_in <= 48'hffffff_ffffff;
      write_frame <= 1;
      @(posedge clk);
      for(i = 0; i < 10000 && !full; i = i+1) begin
         @(posedge clk);
      end
      write_frame = 0;
      if(!full)
        $error("FULL is still low after 10000 writes; this does not seem correct");*/

      $finish;
   end
endmodule
