module foo_tb;
   reg sys_clk = 0;
   always #5 sys_clk <= ~sys_clk;  // 100MHz

   /*AUTOWIRE*/
   // Beginning of automatic wires (for undeclared instantiated-module outputs)
   wire                 ac_addr0_clatch;        // From uut of fpga_riscv_top.v
   wire                 ac_addr1_cdata;         // From uut of fpga_riscv_top.v
   wire                 ac_bclk;                // From uut of fpga_riscv_top.v
   wire                 ac_dac_sdata;           // From uut of fpga_riscv_top.v
   wire                 ac_lrclk;               // From uut of fpga_riscv_top.v
   wire                 ac_mclk;                // From uut of fpga_riscv_top.v
   wire                 ac_scl_cclk;            // From uut of fpga_riscv_top.v
   wire [7:0]           debug;                  // From uut of fpga_riscv_top.v
   wire [7:0]           led;                    // From uut of fpga_riscv_top.v
   // End of automatics

   /*AUTOREGINPUT*/
   // Beginning of automatic reg inputs (for undeclared instantiated-module inputs)
   reg                  btn_c;                  // To uut of fpga_riscv_top.v
   reg                  btn_d;                  // To uut of fpga_riscv_top.v
   reg                  btn_l;                  // To uut of fpga_riscv_top.v
   reg                  btn_r;                  // To uut of fpga_riscv_top.v
   reg                  btn_u;                  // To uut of fpga_riscv_top.v
   reg [7:0]            dip;                    // To uut of fpga_riscv_top.v
   // End of automatics

   initial begin
      btn_c <= 1;
      btn_d <= 0;
      btn_l <= 0;
      btn_r <= 0;
      btn_u <= 0;
      dip <= 8'h0;

      #1000 btn_c <= 0;
   end

   reg [23:0] l_signal;
   reg [23:0] r_signal;
   reg [23:0] sample;
   always @(ac_lrclk) begin
      if(ac_lrclk)
        l_signal = sample;
      else
        r_signal = sample;
      sample = 24'bx;
   end
   always @(posedge ac_bclk) begin
      sample = {sample[22:0], ac_dac_sdata};
   end

   fpga_riscv_top uut(/*AUTOINST*/
                      // Outputs
                      .led              (led[7:0]),
                      .debug            (debug[7:0]),
                      .ac_mclk          (ac_mclk),
                      .ac_addr0_clatch  (ac_addr0_clatch),
                      .ac_addr1_cdata   (ac_addr1_cdata),
                      .ac_scl_cclk      (ac_scl_cclk),
                      .ac_dac_sdata     (ac_dac_sdata),
                      .ac_bclk          (ac_bclk),
                      .ac_lrclk         (ac_lrclk),
                      // Inputs
                      .sys_clk          (sys_clk),
                      .dip              (dip[7:0]),
                      .btn_c            (btn_c),
                      .btn_d            (btn_d),
                      .btn_l            (btn_l),
                      .btn_r            (btn_r),
                      .btn_u            (btn_u));
endmodule
