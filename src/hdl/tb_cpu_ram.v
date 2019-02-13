module tb_cpu_ram;
   reg clk = 0;
   always #10 clk <= ~clk;

   reg reset = 1;
   reg valid = 0;
   reg [31:0] addr;
   reg [31:0] wdata;
   reg [3:0] wstrb;

   wire [31:0] rdata;
   wire ready;

   localparam SIZE = 13;

   cpu_ram #(.SIZE(SIZE)) uut
     (
      // Outputs
      .rdata            (rdata[31:0]),
      .ready            (ready),
      // Inputs
      .clk              (clk),
      .reset            (reset),
      .addr             (addr[SIZE+1:0]),
      .wdata            (wdata[31:0]),
      .valid            (valid),
      .wstrb            (wstrb[3:0])
      );

   task wait_ready;
      fork
         begin: waiting
            while(!ready)
              @(posedge clk);
            disable timeout;
         end
         begin: timeout
            #1000 disable waiting;
            $error("READY did not go high after 1000ns");
         end
      join
   endtask

   task write;
      input [29:0] word_addr;
      input [3:0] wstrb_;
      input [31:0] data;
      begin
         addr <= {word_addr, 2'b00};
         wstrb <= wstrb_;
         wdata <= data;
         valid <= 1;
         @(posedge clk);
         valid <= 0;
         wait_ready;
         addr <= 32'hx;
         wstrb <= 4'bx;
         wdata <= 32'hx;
         @(posedge clk);
      end
   endtask

   task read_check;
      input [29:0] word_addr;
      input [31:0] data;
      begin
         addr <= {word_addr, 2'b00};
         wstrb <= 4'b0000;
         valid <= 1;
         @(posedge clk);
         valid <= 0;
         wait_ready;
         if(rdata !== data)
           $error("bad output data for address (want: %08x, got: %08x)", {word_addr, 2'b00}, data, rdata);
         addr <= 32'hx;
         wstrb <= 4'bx;
         @(posedge clk);
      end
   endtask

   //integer n_words = 1 << SIZE;
   localparam n_words = 5;

   reg [31:0] test_pattern[0:n_words-1];

   integer rng = 12345;
   task gen_test_pattern;
      integer ii;
      begin
         for(ii = 0; ii < n_words; ii = ii+1) begin
            rng = rng * 1664525 + 1013904223;  // simple linear congruential generator
            test_pattern[ii] = rng;
         end
      end
   endtask

   integer ii;

   initial begin
      $dumpvars;

      repeat(5)
        @(posedge clk);
      reset <= 0;

      $display("testing word access");
      gen_test_pattern;
      for(ii = n_words-1; ii >= 0; ii = ii-1)  // backwards
        write(ii, 4'b1111, test_pattern[ii]);

      for(ii = 0; ii < n_words; ii = ii+1)
        read_check(ii, test_pattern[ii]);

      $display("testing halfword access");
      gen_test_pattern;
      for(ii = 0; ii < n_words; ii = ii+1)
        write(ii, 4'b0011, test_pattern[ii]);
      for(ii = n_words-1; ii >= 0; ii = ii-1)  // backwards
        write(ii, 4'b1100, test_pattern[ii]);

      for(ii = 0; ii < n_words; ii = ii+1)
        read_check(ii, test_pattern[ii]);

      $display("testing byte access");
      gen_test_pattern;
      for(ii = n_words-1; ii >= 0; ii = ii-1)  // backwards
        write(ii, 4'b0001, test_pattern[ii]);
      for(ii = 0; ii < n_words; ii = ii+1)
        write(ii, 4'b0010, test_pattern[ii]);
      for(ii = n_words-1; ii >= 0; ii = ii-1)  // backwards
        write(ii, 4'b0100, test_pattern[ii]);
      for(ii = 0; ii < n_words; ii = ii+1)
        write(ii, 4'b1000, test_pattern[ii]);

      for(ii = n_words-1; ii >= 0; ii = ii-1)  // backwards
        read_check(ii, test_pattern[ii]);

      $finish;
   end
endmodule
