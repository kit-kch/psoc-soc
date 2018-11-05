module fifo #(
     parameter WIDTH = 48,
     parameter SIZE = 8
   ) (
     input clk,
     input reset,

     input [WIDTH-1:0] din,
     input wr,
     output full,

     output reg [WIDTH-1:0] dout,
     output empty,
     input rd
     );

   localparam WORD_COUNT = 1 << SIZE;

   reg [WIDTH-1:0] words[0:WORD_COUNT-1];
   reg [SIZE:0] rd_ptr, wr_ptr;

   always @(posedge clk) begin
      if(reset) begin
         rd_ptr <= 0;
         wr_ptr <= 0;
      end else begin
         if(wr) begin
            words[wr_ptr[SIZE-1:0]] <= din;
            wr_ptr <= wr_ptr + 1;
         end
         if(rd) begin
            dout <= words[rd_ptr[SIZE-1:0]];
            rd_ptr <= rd_ptr + 1;
         end
      end
   end

   assign low_eq = rd_ptr[SIZE-1:0] == wr_ptr[SIZE-1:0];
   assign msb_eq = rd_ptr[SIZE] == wr_ptr[SIZE];
   assign empty = low_eq && msb_eq;
   assign full = low_eq && !msb_eq;
endmodule

