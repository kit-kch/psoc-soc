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
      input rst,

      // CPU connections
      input [3:0] wb_sel_i,
      input [31:0] wb_dat_i,
      input [31:0] wb_adr_i,
      input wb_stb_i,
      input wb_we_i,
      output reg [31:0] wb_dat_o,
      output reg wb_ack_o,


      // adau_interface signals
      output reg [23:0] adau_audio_l, adau_audio_r,
      output reg adau_audio_valid,
      input adau_audio_full,
      input adau_init_done
   );

   wire o_wb_stall;
    assign o_wb_stall = 1'b0;
    reg adau_word_complete;
    
   // read logic
   always @(posedge clk) begin
//      ram_valid = 0;
 
      case(wb_adr_i)
         // 15 bit address / 256 kiBit
         // 0x0000_0000 - 0x0000_7FFF
//         32'b0000_0000_0000_0000_0???_????_????_????: begin
//            rdata = ram_rdata;
//            ram_valid = valid;
//            ready = ram_ready;
//         end
         32'h9000_000c: wb_dat_o = {30'b0, adau_init_done, adau_word_complete};
         default: wb_dat_o = 32'h0000_0000;
      endcase
   end

   // write logic
   always @(posedge clk) begin
      if(rst) begin
         adau_audio_l <= 24'h000000;
         adau_audio_r <= 24'h000000;
         adau_word_complete <= 1'b0;
      end else begin
          adau_audio_valid <= 0;
          if (!adau_audio_full && adau_word_complete)
          begin
              adau_audio_valid <= 1;
              adau_word_complete <= 0;
          end

          if ((wb_stb_i)&&(wb_we_i)&&(!o_wb_stall))
	        begin
             case(wb_adr_i)
                32'h9000_0010: begin
                   if(wb_sel_i[2])
                      adau_audio_l[23:16] <= wb_dat_i[23:16];
                   if(wb_sel_i[1])
                      adau_audio_l[15:8] <= wb_dat_i[15:8];
                   if(wb_sel_i[0])
                      adau_audio_l[7:0] <= wb_dat_i[7:0];
                end
                32'h9000_0014: begin
                   if(wb_sel_i[2])
                      adau_audio_r[23:16] <= wb_dat_i[23:16];
                   if(wb_sel_i[1])
                      adau_audio_r[15:8] <= wb_dat_i[15:8];
                   if(wb_sel_i[0])
                      adau_audio_r[7:0] <= wb_dat_i[7:0];
                   if(|wb_sel_i)
                     adau_word_complete <= 1;
                end
             endcase
         end
      end
   end
   
   // Acknowledgement
   always @(posedge clk) begin
        if (rst) begin
	       wb_ack_o <= 1'b0;
	       end 
        else begin
	       wb_ack_o <= ((wb_stb_i)&&(!o_wb_stall));
	       end
   end
    
endmodule





