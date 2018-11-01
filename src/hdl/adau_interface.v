`timescale 1ns / 1ps

module adau_interface(
   input clk_120mhz,
   input reset,

   // user signals
   input [47:0] audio_in,
   input audio_in_valid,
   output audio_full,
   input enable_audio,
   output init_complete,

   // ADAU signals
   output cclk,
   output clatch_n,
   output cdata,

   output sdata,
   output bclk,
   output lrclk
);

   wire [31:0] adau_command;
   wire adau_command_valid, spi_ready;

   adau_spi_master spi
     (.clk(clk_120mhz),
      .reset(reset),

      .data_in(adau_command),
      .valid(adau_command_valid),
      .ready(spi_ready),

      .cdata(cdata),
      .cclk(cclk),
      .clatch_n(clatch_n)
      );
   adau_command_list adau_commands
     (.clk(clk_120mhz),
      .reset(reset),
      
      .command(adau_command),
      .command_valid(adau_command_valid),
      .spi_ready(spi_ready),
      .init_complete(init_complete)
      );

   wire i2s_enable = init_complete && enable_audio;
   i2s_master i2s
      (.clk(clk_120mhz),
       .reset(reset),

       .enable(i2s_enable),
       .frame_in(audio_in),
       .write_frame(audio_in_valid),
       .full(audio_full),

       .bclk(bclk),
       .lrclk(lrclk),
       .sdata(sdata)
       );
endmodule
