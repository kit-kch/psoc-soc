// Date: 02.07.2025
// Author: Johannes Pfau
// Description: Minimal wishbone crossbar based on https://zipcpu.com/blog/2017/06/22/simple-wb-interconnect.html
//              We however keep everything combinational. We still meet timing and this way we avoid additional registers.
// Note: This xbar assumes that we use the neorv xbus interface an that all slaves set their outputs to 0 when they're not actively reading.


module wb_xbar(
    // Master port
    input[31:0] wb_adr,
    output[31:0] wb_dat_i,
    input[31:0] wb_dat_o,
    input wb_we,
    input[3:0] wb_sel,
    input wb_stb,
    input wb_cyc,
    output wb_ack,

    // I2S downstream
    output[31:0] wb_i2s_adr,
    input[31:0] wb_i2s_dat_i,
    output[31:0] wb_i2s_dat_o,
    output wb_i2s_we,
    output[3:0] wb_i2s_sel,
    output wb_i2s_stb,
    output wb_i2s_cyc,
    input wb_i2s_ack,

    // IO Downstream
    output[31:0] wb_io_adr,
    input[31:0] wb_io_dat_i,
    output[31:0] wb_io_dat_o,
    output wb_io_we,
    output[3:0] wb_io_sel,
    output wb_io_stb,
    output wb_io_cyc,
    input wb_io_ack
);
    // 0xFFE0_0000 and up is used by NEORV32 Peripherals
    // We use 0xFFD0_0000 to 0xFFDF_FFFF for up to 16 devices with 64kB addr space each

    wire i2s_sel, io_sel;
    // Address decoder: Select device if 16 high bits have the proper address
    assign i2s_sel = (wb_adr[31:16] == 16'hFFD0) ? 1'b1 : 1'b0;
    assign io_sel = (wb_adr[31:16] == 16'hFFD1) ? 1'b1 : 1'b0;

    // Forward address, write data, write enable and sel
    assign wb_i2s_adr = wb_adr;
    assign wb_io_adr = wb_adr;
    assign wb_i2s_dat_o = wb_dat_o;
    assign wb_io_dat_o = wb_dat_o;
    assign wb_i2s_we = wb_we;
    assign wb_io_we = wb_we;
    assign wb_i2s_sel = wb_sel;
    assign wb_io_sel = wb_sel;

    // Only forward STB and CYC if the slave is active
    assign wb_i2s_stb = wb_stb & i2s_sel;
    assign wb_io_stb = wb_stb & io_sel;
    assign wb_i2s_cyc = wb_cyc & i2s_sel;
    assign wb_io_cyc = wb_cyc & io_sel;

    // Simply OR data response
    assign wb_dat_i = wb_i2s_dat_i | wb_io_dat_i;

    // Simply OR acks
    assign wb_ack = wb_i2s_ack | wb_io_ack;

endmodule