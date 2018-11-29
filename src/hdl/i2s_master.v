`timescale 1ns/1ps

module i2s_master
   (input clk_soc,
    input ac_mclk,
    input reset,

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
   wire fifo_empty;
   reg fifo_read;

   // This FIFO stores the audio data.
   // The write interface just gets exposed to the user of this module.
   // We get our audio data from the read interface.
   audio_fifo audio_data_fifo (
      .rst(reset),                // input wire rst
      .wr_clk(clk_soc),           // input wire wr_clk
      .rd_clk(ac_mclk),         // input wire rd_clk
      .din(frame_in),             // input wire [47 : 0] din
      .wr_en(write_frame),        // input wire wr_en
      .rd_en(fifo_read),          // input wire rd_en
      .dout(cur_frame),           // output wire [47 : 0] dout
      .full(full),                // output wire full
      .empty(fifo_empty),         // output wire empty
      .wr_rst_busy(),             // output wire wr_rst_busy
      .rd_rst_busy()              // output wire rd_rst_busy
   );
   
   reg [5:0] bclk_counter;
   reg [23:0] sdata_sreg;
   reg [1:0] startup;
   assign sdata = sdata_sreg[23];
   reg fifo_was_empty;
   
   reg mclk_tick_counter;
   always @(posedge ac_mclk) begin
      if(reset) begin
         bclk <= 0;
         lrclk <= 1;
         // This forces the FSM to do the initial lcclk transisiton
         bclk_counter <= 63;
         sdata_sreg <= 24'b0;
         fifo_read <= 0;
         startup <= 0;
         mclk_tick_counter <= 0;
      end else begin
         // Reset on every adau_mclk clk, to pulse for only one adau_mclk cycle
         fifo_read <= 0;
         mclk_tick_counter <= mclk_tick_counter + 1;
         
         // After reset, first read one FIFO entry
         if (startup == 0) begin
             if (!fifo_empty) begin
                 fifo_read <= 1;
                 startup <= 1;
             end
         end if (startup == 1) begin
             fifo_read <= 0;
             startup <= 2;
         // Everything else is done on the tick counter, which essentially stretches the pulses
         end else if (mclk_tick_counter == 1) begin
            bclk_counter <= bclk_counter + 1;
            
            // Prepare next output bit. write before bclk goes low
            // Note: requires LRDEL=1
            if (bclk == 0 && bclk_counter != 0) begin
                sdata_sreg <= {sdata_sreg[22:0], 1'b0};
            end
            
            // Generate bclk signal for first 48 cycles only
            if (bclk_counter < 48) begin
                bclk <= ! bclk;
            end
            // Generate lrclk
            if (bclk_counter == 63) begin
                // Load next output value
                if (lrclk == 0) begin
                    if (fifo_was_empty)
                        sdata_sreg <= 24'b0;
                    else
                        sdata_sreg <= cur_frame_right;

                    // Read next FIFO entry
                    fifo_was_empty <= 1;
                    if (!fifo_empty) begin
                        fifo_read <= 1;
                        fifo_was_empty <= 0;
                    end
                end else begin
                    if (fifo_was_empty)
                    sdata_sreg <= 24'b0;
                else
                    sdata_sreg <= cur_frame_left;
                end
                
                lrclk <= !lrclk;
                bclk_counter <= 0;
            end
         end
      end
   end
endmodule
