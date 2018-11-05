// MEMORY MAP:
// - 0x00010000 - 0x00013fff: RAM (read-write)
// - 0x80000000: DIP switches (read-only)
// - 0x80000004: LEDs (read-write)
// - 0x80000008: buttons (read-only)
// - 0x8000000c: audio status (read-only)
//   - bit 0: audio FIFO full
//   - bit 1: ADAU configuration complete
// - 0x80000010: left audio sample (write-only)
// - 0x80000014: right audio sample (write-only)
//   Writing to the right channel triggers a write into the audio FIFO.
module cpu_bus_logic(
   input clk,
   input reset,

   // CPU connections
   input [31:0] addr,
   input [31:0] wdata,
   output [31:0] rdata,
   input [3:0] wstrb,
   input valid,
   output ready,

   // debugging stuff
   input [7:0] dip,
   input [4:0] buttons,
   output reg [7:0] leds,

   // RAM interface
   output [13:0] ram_addr,
   output [31:0] ram_wdata,
   output reg ram_valid,
   output [3:0] ram_wstrb,
   input [31:0] ram_rdata,
   input ram_ready,

   // adau_interface signals
   output [47:0] adau_audio,
   output adau_audio_valid,
   input adau_audio_full,
   input adau_init_done
   );

   assign ram_addr = addr[13:0];
   assign ram_wstrb = wstrb;
   assign ram_wdata = wdata;

   // read logic
   always @(*) begin
      ram_valid = 0;
      ready = 1;
      case(addr)
         32'b0000_0000_0000_0001_00??_????_????_????: begin
            rdata = ram_rdata;
            ram_valid = 1;
            ready = ram_ready;
         end
         8'h8000_0000: mem_rdata = {24'b0, dip};
         8'h8000_0004: mem_rdata = {24'b0, led};
         8'h8000_0008: mem_rdata = {27'b0, buttons};
         8'h8000_000c: mem_rdata = {30'b0, adau_init_done, adau_audio_full};
         default: mem_rdata = 32'h0000_0000;
      endcase

      adau_audio_valid = (addr == 32'h8000_0014) && |mem_wstrb[2:0];
   end

   // write logic
   reg [23:0] left_audio;
   assign adau_audio = {left_audio, mem_wdata[23:0]};
   always @(posedge clk) begin
      if(reset) begin
         leds <= 8'h00;
         left_audio <= 24'h000000;
      end else if(valid) begin
         case(addr)
            8'h8000_0004: begin
               if(wstrb[0])
                  led <= mem_wdata[7:0];
            end

            8'h8000_0010: begin
               if(wstrb[2])
                  left_audio[23:16] <= wdata[23:16];
               if(wstrb[1])
                  left_audio[15:8] <= wdata[15:8];
               if(wstrb[0])
                  left_audio[7:0] <= wdata[7:0];
            end
         endcase
      end
   end
endmodule
