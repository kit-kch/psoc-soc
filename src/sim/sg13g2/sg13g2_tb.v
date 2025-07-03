module sg13g2_tb ();

  initial begin
    $dumpfile("sg13g2_tb.vcd");
    $dumpvars(0, tb);
  end

  wire [31:0] pads;
  reg arstn;
  reg clk;

  assign pads[31] = arstn;
  assign pads[30] = clk;

  soc_top uut (
    .pads(pads)
  );

endmodule