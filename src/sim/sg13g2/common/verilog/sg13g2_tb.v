module sg13g2_tb ();
  wire [31:0] pads;
  reg arstn;
  reg clk;

  // DAC Pins
  wire dacl = pads[5];
  wire dacr = pads[4];

  // PWM Pins
  wire pwm0 = pads[20];
  wire pwm1 = pads[21];

  // JTAG Pins. Note: Must drive those, otherwise GL simulation becomes invalid!
  reg jtag_tms, jtag_tdi, jtag_tck;
  wire jtag_tdo = pads[24];
  assign pads[25] = jtag_tms;
  assign pads[23] = jtag_tdi;
  assign pads[22] = jtag_tck;

  // XIP SPI Flash slave peripheral
  reg xip_sdi;
  wire xip_sdo = pads[29];
  wire xip_clk = pads[27];
  wire xip_cs = pads[26];
  assign pads[28] = xip_sdi;

  assign pads[31] = arstn;
  assign pads[30] = clk;

  soc_top uut (
    .pads(pads)
  );

endmodule