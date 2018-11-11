`timescale 1ns/1ps

module i2s_master
   (input clk,
    input reset,
    input enable,

    output reg bclk,
    output reg lrclk,
    output sdata,

    input [47:0] frame_in,
    input write_frame,
    output full
    );
   wire [47:0] cur_frame;
   wire [23:0] cur_frame_right = cur_frame[23:0];
   wire [23:0] cur_frame_left = cur_frame[47:24];

   wire fifo_read, fifo_empty;

   // This FIFO stores the audio data.
   // The write interface just gets exposed to the user of this module.
   // We get our audio data from the read interface.
   fifo
      #(.WIDTH(48), .SIZE(8))
   audio_data_fifo
     (.clk(clk),
      .reset(reset),

      .din(frame_in),
      .wr(write_frame),
      .full(full),

      .rd(fifo_read),
      .dout(cur_frame),
      .empty(fifo_empty)
      );

   // We need a BCLK frequency/data rate of
   //   2 channels * (24 bit data + 1 bit overhead) * 48k / s = 2.4 Mbit/s
   // 120MHz/2.4MHz is a ratio of 50. Therefore our counter counts to 25.
   localparam COUNTER_TOP = 25;
   localparam DIV_BITS = $clog2(COUNTER_TOP);
   reg [DIV_BITS-1:0] divider;
   wire bclk_tick = divider == COUNTER_TOP - 1;

   // Once again, we send our data using a shift register.
   reg [23:0] shiftreg;
   assign sdata = shiftreg[23];

   // This counter keeps track of how many bits have been sent.
   reg [4:0] bclk_edges;

   always @(posedge clk) begin
      if(reset || !enable) begin
         bclk <= 0;
         lrclk <= 0;
         bclk_edges <= 0;
         divider <= 0;
      end else begin
         if(bclk_tick)
           divider <= 0;
         else
           divider <= divider + 1;

         if(bclk_tick) begin
            bclk <= ~bclk;

            if(bclk) begin  // Falling edge on BCLK imminent?
               if(bclk_edges == 0) begin
                  // First falling edge? Load the next sample.
                  // LRCLK tells us which channel to use.
                  shiftreg <= lrclk ? cur_frame_right : cur_frame_left;
                  // if(lrclk && !fifo_empty)
                  //     fifo_read is high
               end else begin // bclk_edges != 0
                  shiftreg <= {shiftreg[22:0], 1'b0};
               end
               if(bclk_edges == 24) begin  // Current sample done?
                  // Toggle LRCLK and prepare for the next sample.
                  lrclk <= ~lrclk;
                  bclk_edges <= 0;
               end else begin
                  bclk_edges <= bclk_edges + 1;
               end

            end // if(bclk)
         end  // if(bclk_tick)
      end  // else
   end  // always @(posedge clk)

   // We read from the FIFO when:
   assign fifo_read = (
                       !reset && enable &&       // We are actually sending data...
                       bclk_tick && bclk &&      // ...and BCLK will be low next CLK...
                       bclk_edges == 0 &&        // ...and we are loading new data into shiftreg...
                       lrclk &&                  // ...which belongs to the right (= last) channel.
                       !fifo_empty               // Also, we don't want to underflow the FIFO.
                       );
endmodule
