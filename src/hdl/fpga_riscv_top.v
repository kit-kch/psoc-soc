`timescale 1ns / 1ps

module fpga_riscv_top(
        // system clock
        input sys_clk,

        // for debugging
        output [7:0] led,
        input [7:0] dip,
        output [7:0] debug,
        input btn_c,
        input btn_d,
        input btn_l,
        input btn_r,
        input btn_u,

        // ADAU signals
        output ac_mclk,

        output ac_addr0_clatch,
        output ac_addr1_cdata,
        output ac_scl_cclk,

        output ac_dac_sdata,
        output ac_bclk,
        output ac_lrclk
    );

    wire clk_soc;
    wire locked;
    wire reset;

    assign reset = btn_c;

    // Generate all required clocks
    clk_wiz_0 pll(
        .clk_in1(sys_clk),
        .reset(0),
        .clk_soc(clk_soc),
        .clk_adau_mclk(ac_mclk),
        .locked(locked)
    );


    // ctrl <=> spi interface
    wire [31:0] adau_command;
    wire adau_command_valid, spi_ready, adau_init_done;

    adau_command_list ctrl(
        .clk(clk_soc),
        .reset(reset),

        .command(adau_command),
        .command_valid(adau_command_valid),
        .spi_ready(spi_ready),
        .adau_init_done(adau_init_done)
    );

    adau_spi_master spi(
        .clk(clk_soc),
        .reset(reset),

        .data_in(adau_command),
        .valid(adau_command_valid),
        .ready(spi_ready),

        .cdata(ac_addr1_cdata),
        .cclk(ac_scl_cclk),
        .clatch_n(ac_addr0_clatch)
    );


    // sin <=> i2s
    wire [23:0] adau_audio_in_l, adau_audio_in_r;
    wire adau_audio_in_valid, adau_audio_full;

    i2s_master i2s(
        .clk_soc(clk_soc),
        .ac_mclk(ac_mclk),
        .reset(reset),

        .frame_in_r(adau_audio_in_r),
        .frame_in_l(adau_audio_in_l),
        .write_frame(adau_audio_in_valid),
        .full(adau_audio_full),

        .bclk(ac_bclk),
        .lrclk(ac_lrclk),
        .sdata(ac_dac_sdata)
    );


    // RAM for the CPU
    wire [18:0] ram_addr;
    wire [31:0] ram_wdata, ram_rdata;
    wire ram_valid, ram_ready;
    wire [3:0] ram_wstrb;

    // This gives exactly 4MiB
    cpu_ram #(.SIZE(17), .HEIGHT(131072-1)) ram(
        .clk(clk_soc),
        .reset(reset),
        .addr(ram_addr),
        .wdata(ram_wdata),
        .valid(ram_valid),
        .wstrb(ram_wstrb),
        .rdata(ram_rdata),
        .ready(ram_ready)
    );


    // CPU bus logic
    wire [31:0] bus_addr, bus_wdata, bus_rdata;
    wire bus_valid, bus_ready;
    wire [3:0] bus_wstrb;

    cpu_bus_logic bus(
        .clk(clk_soc),
        .reset(reset),
        .addr(bus_addr),
        .wdata(bus_wdata),
        .wstrb(bus_wstrb),
        .rdata(bus_rdata),
        .valid(bus_valid),
        .ready(bus_ready),

        .dip(dip),
        .buttons({btn_c, btn_d, btn_l, btn_r, btn_u}),
        .led(led),

        .ram_addr(ram_addr),
        .ram_wdata(ram_wdata),
        .ram_valid(ram_valid),
        .ram_wstrb(ram_wstrb),
        .ram_rdata(ram_rdata),
        .ram_ready(ram_ready),

        .adau_audio_l(adau_audio_in_l),
        .adau_audio_r(adau_audio_in_r),
        .adau_audio_valid(adau_audio_in_valid),
        .adau_audio_full(adau_audio_full),
        .adau_init_done(adau_init_done)
    );

   // CPU instance
   picorv32 #(
        .REGS_INIT_ZERO(1),
        .PROGADDR_RESET(32'h0000_0000),
        .PROGADDR_IRQ(32'h0000_0010),
        .ENABLE_MUL(1),
        .ENABLE_IRQ(1),
        .LATCHED_IRQ(32'hffff_ffff),
        .MASKED_IRQ(32'hffff_ff00)
        ) cpu (
            .clk(clk_soc),
            .resetn(!reset),
            .mem_valid(bus_valid),
            .mem_ready(bus_ready),
            .mem_addr(bus_addr),
            .mem_wdata(bus_wdata),
            .mem_wstrb(bus_wstrb),
            .mem_rdata(bus_rdata),
            .pcpi_wr(1'b0),
            .pcpi_rd(32'b0),
            .pcpi_wait(1'b0),
            .pcpi_ready(1'b0),
            .irq({24'b0, btn_c, btn_d, btn_l, btn_r, btn_u, 3'b0})
    );

    // Debug signals
    assign debug[7:0] = {reset, ac_mclk, ac_addr0_clatch, ac_addr1_cdata, ac_scl_cclk, ac_dac_sdata, ac_bclk, ac_lrclk};
endmodule
