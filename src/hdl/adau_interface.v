`timescale 1ns / 1ps

module adau_interface(
   input clk_120mhz,
   input ac_mclk,
   input reset,

   // user signals
   input [47:0] audio_in,
   input audio_in_valid,
   output audio_full,
   output adau_init_done,

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
      .adau_init_done(adau_init_done)
      );

   i2s_master i2s
      (.clk_soc(clk_120mhz),
       .ac_mclk(ac_mclk),
       .reset(0), //FIXME

       .frame_in(audio_in),
       .write_frame(audio_in_valid),
       .full(audio_full),

       .bclk(bclk),
       .lrclk(lrclk),
       .sdata(sdata)
       );
endmodule
