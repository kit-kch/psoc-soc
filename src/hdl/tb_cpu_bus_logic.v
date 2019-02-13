`timescale 1ns/1ps

module tb_cpu_bus_logic;
   /*AUTOREGINPUT*/
   // Beginning of automatic reg inputs (for undeclared instantiated-module inputs)
   reg                  adau_audio_full;        // To uut of cpu_bus_logic.v
   reg                  adau_init_done;         // To uut of cpu_bus_logic.v
   reg [31:0]           addr;                   // To uut of cpu_bus_logic.v
   reg [4:0]            buttons;                // To uut of cpu_bus_logic.v
   reg                  clk;                    // To uut of cpu_bus_logic.v
   reg [7:0]            dip;                    // To uut of cpu_bus_logic.v
   reg [31:0]           ram_rdata;              // To uut of cpu_bus_logic.v
   reg                  ram_ready;              // To uut of cpu_bus_logic.v
   reg                  reset;                  // To uut of cpu_bus_logic.v
   reg                  valid;                  // To uut of cpu_bus_logic.v
   reg [31:0]           wdata;                  // To uut of cpu_bus_logic.v
   reg [3:0]            wstrb;                  // To uut of cpu_bus_logic.v
   // End of automatics
   /*AUTOWIRE*/
   // Beginning of automatic wires (for undeclared instantiated-module outputs)
   wire [47:0]          adau_audio;             // From uut of cpu_bus_logic.v
   wire                 adau_audio_valid;       // From uut of cpu_bus_logic.v
   wire [7:0]           led;                    // From uut of cpu_bus_logic.v
   wire [14:0]          ram_addr;               // From uut of cpu_bus_logic.v
   wire                 ram_valid;              // From uut of cpu_bus_logic.v
   wire [31:0]          ram_wdata;              // From uut of cpu_bus_logic.v
   wire [3:0]           ram_wstrb;              // From uut of cpu_bus_logic.v
   wire [31:0]          rdata;                  // From uut of cpu_bus_logic.v
   wire                 ready;                  // From uut of cpu_bus_logic.v
   // End of automatics
   cpu_bus_logic uut(/*AUTOINST*/
                     // Outputs
                     .rdata             (rdata[31:0]),
                     .ready             (ready),
                     .led               (led[7:0]),
                     .ram_addr          (ram_addr[14:0]),
                     .ram_wdata         (ram_wdata[31:0]),
                     .ram_valid         (ram_valid),
                     .ram_wstrb         (ram_wstrb[3:0]),
                     .adau_audio        (adau_audio[47:0]),
                     .adau_audio_valid  (adau_audio_valid),
                     // Inputs
                     .clk               (clk),
                     .reset             (reset),
                     .addr              (addr[31:0]),
                     .wdata             (wdata[31:0]),
                     .wstrb             (wstrb[3:0]),
                     .valid             (valid),
                     .dip               (dip[7:0]),
                     .buttons           (buttons[4:0]),
                     .ram_rdata         (ram_rdata[31:0]),
                     .ram_ready         (ram_ready),
                     .adau_audio_full   (adau_audio_full),
                     .adau_init_done    (adau_init_done));

   // TODO
   initial $finish;
endmodule
