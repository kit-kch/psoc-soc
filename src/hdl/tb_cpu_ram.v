module tb_cpu_ram;
   reg clk = 0;
   always #10 clk <= ~clk;

   reg reset = 1;

   reg d_req = 0;
   reg [31:0] d_addr;
   reg [31:0] d_wdata;
   reg [3:0] d_be;
   wire [31:0] d_rdata;
   wire d_valid;

   reg i_req = 0;
   reg [31:0] i_addr;
   wire [31:0] i_rdata;
   wire i_valid;

   localparam size = 13;
   localparam n_words = 1 << size;
   localparam verbose = 0;

   cpu_ram uut
     (.clk              (clk),
      .reset            (reset),

      .d_addr           (d_addr[size+1:0]),
      .d_req            (d_req),
      .d_we             (|d_be),
      .d_be             (d_be),
      .d_wdata          (d_wdata[31:0]),

      .d_rdata          (d_rdata[31:0]),
      .d_valid          (d_valid),

      .i_addr           (i_addr[size+1:0]),
      .i_req            (i_req),
      .i_rdata          (i_rdata),
      .i_valid          (i_valid));

   task wait_d_valid;
      fork
         begin: waiting
            while(!d_valid)
              @(posedge clk);
            disable timeout;
         end
         begin: timeout
            #1000 disable waiting;
            $error("D_VALID did not go high after 1000ns");
         end
      join
   endtask

   task wait_i_valid;
      fork
         begin: waiting
            while(!i_valid)
              @(posedge clk);
            disable timeout;
         end
         begin: timeout
            #1000 disable waiting;
            $error("I_VALID did not go high after 1000ns");
         end
      join
   endtask

   task write;
      input [29:0] word_addr;
      input [3:0] wstrb_;
      input [31:0] data;
      begin
         if(verbose)
           $display("write: %08x <- %08x [%04b] @ %t", {word_addr, 2'b00}, data, wstrb_, $time);
         d_addr <= {word_addr, 2'b00};
         d_be <= wstrb_;
         d_wdata <= data;
         d_req <= 1;
         @(posedge clk);
         d_req <= 0;
         wait_d_valid;
         d_addr <= 32'hx;
         d_be <= 4'bx;
         d_wdata <= 32'hx;
         @(posedge clk);
      end
   endtask

   task read_check;
      input [29:0] word_addr;
      input [31:0] data;
      begin
         if(verbose)
           $display("read: %08x (expecting %08x) @ %t", {word_addr, 2'b00}, data, $time);

         d_addr <= {word_addr, 2'b00};
         d_be <= 4'b0000;
         d_req <= 1;
         @(posedge clk);
         d_req <= 0;
         wait_d_valid;
         if(d_rdata !== data)
           $error("bad output data for address %08x on the D port (want: %08x, got: %08x)", {word_addr, 2'b00}, data, d_rdata);
         d_addr <= 32'hx;
         d_be <= 4'bx;
         @(posedge clk);

         i_addr <= {word_addr, 2'b00};
         i_req <= 1;
         @(posedge clk);
         i_req <= 0;
         wait_i_valid;
         if(i_rdata !== data)
           $error("bad output data for address %08x on the I port (want: %08x, got: %08x)", {word_addr, 2'b00}, data, i_rdata);
         i_addr <= 32'bx;
         @(posedge clk);
      end
   endtask

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
      $timeformat(-9, 3, " ns", 1);

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
