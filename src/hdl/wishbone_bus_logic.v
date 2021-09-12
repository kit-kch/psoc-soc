`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/11/2021 05:36:49 PM
// Design Name: 
// Module Name: wishbone_bus_logic
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module wishbone_bus_logic(



// MEMORY MAP:
// - 0x00010000 - 0x00017fff: RAM (read-write)
// - 0x80000000: DIP switches (read-only)
// - 0x80000004: LEDs (read-write)
// - 0x80000008: buttons (read-only)
// - 0x8000000c: audio status (read-only)
//   - bit 0: audio FIFO full
//   - bit 1: ADAU configuration complete
// - 0x80000010: left audio sample (write-only)
// - 0x80000014: right audio sample (write-only)
//   Writing to the right channel triggers a write into the audio FIFO.

      input clk,
      input reset,

      // CPU connections
      input [3:0] i_wb_sel,
      input [31:0] i_wb_data,
      input i_wb_addr,
      input i_wb_stb,
      input i_wb_we,
      output o_wb_stall,
      output reg [31:0] o_wb_data,
      output reg o_wb_ack,

      // debugging stuff
      input [7:0] dip,
      input [4:0] buttons,
      output reg [7:0] led,


      // adau_interface signals
      output reg [23:0] adau_audio_l, adau_audio_r,
      output reg adau_audio_valid,
      input adau_audio_full,
      input adau_init_done
   );


   // read logic
   always @(posedge clk) begin
//      ram_valid = 0;
 
      case(i_wb_addr)
         // 15 bit address / 256 kiBit
         // 0x0000_0000 - 0x0000_7FFF
//         32'b0000_0000_0000_0000_0???_????_????_????: begin
//            rdata = ram_rdata;
//            ram_valid = valid;
//            ready = ram_ready;
//         end
         32'h8000_0000: o_wb_data = {24'b0, dip};
         32'h8000_0004: o_wb_data = {24'b0, led};
         32'h8000_0008: o_wb_data = {27'b0, buttons};
         32'h8000_000c: o_wb_data = {30'b0, adau_init_done, adau_audio_full};
         default: o_wb_data = 32'h0000_0000;
      endcase
   end

   // write logic
   always @(posedge clk) begin
      if(reset) begin
         led <= 8'h00;
         adau_audio_l <= 24'h000000;
         adau_audio_r <= 24'h000000;
      end else begin
          if (!adau_audio_full && adau_audio_valid)
              adau_audio_valid <= 0;

          if ((i_wb_stb)&&(i_wb_we)&&(!o_wb_stall))
	        begin
             case(i_wb_addr)
                32'h8000_0004: begin
                   if(i_wb_sel[0])
                      led <= i_wb_data[7:0];
                end
                32'h8000_0010: begin
                   if(i_wb_sel[2])
                      adau_audio_l[23:16] <= i_wb_data[23:16];
                   if(i_wb_sel[1])
                      adau_audio_l[15:8] <= i_wb_data[15:8];
                   if(i_wb_sel[0])
                      adau_audio_l[7:0] <= i_wb_data[7:0];
                end
                32'h8000_0014: begin
                   if(i_wb_sel[2])
                      adau_audio_r[23:16] <= i_wb_data[23:16];
                   if(i_wb_sel[1])
                      adau_audio_r[15:8] <= i_wb_data[15:8];
                   if(i_wb_sel[0])
                      adau_audio_r[7:0] <= i_wb_data[7:0];
                   if(|i_wb_sel)
                     adau_audio_valid <= 1;
                end
             endcase
         end
      end
   end
   
   // Acknowledgement
   always @(posedge clk) begin
        if (reset) begin
	       o_wb_ack <= 1'b0;
	       end 
        else begin
	       o_wb_ack <= ((i_wb_stb)&&(!o_wb_stall));
	       end
   end
    
endmodule





