`timescale 1ns / 1ps

module fpga_riscv_top(
        // system clock
        input sys_clk,

        // for debugging
        output [7:0] led,
        input [7:0] dip,
        output [7:0] debug,
        // Taster BTNC auf zedboard
        input btn_rst,
        
        // extension board
        
        // ADAU signals
        output ac_mclk,
        output ac_dac_sdata,
        output ac_bclk,
        output ac_lrclk,
        output ac_addr0_clatch,
        output ac_addr1_cdata,
        output ac_scl_cclk,

        
        // i2c signals
        inout i2c_sda,
        inout i2c_scl,
        
        // UART0 
        output uart0_txd_o,
        input uart0_rxd_i,

        // parallel output
        output [1:0] gpio_o, 
        input btn_c,
        input btn_d,
        input btn_l,
        input btn_r,
        input btn_u,
        
        //SPI SD
        output spi_clk,
        input spi_miso,
        output spi_mosi,
        output spi_sd_ss,
        output spi_flash_ss,
        
        //PWM 
        output pwm_led,

        //JTAG
        input jtag_trst_i,
        input jtag_tck_i,
        input jtag_tdi_i,
        output jtag_tdo_o,
        input jtag_tms_i
    );
    

    wire clk_soc;
    wire locked;

    // Generate all required clocks
    clk_wiz_0 pll(
        .clk_in1(sys_clk),
        .reset(0),
        .clk_soc(clk_soc),
        .clk_adau_mclk(ac_mclk),
        .locked(locked)
    );

    // stretch the reset pulse
    reg [5:0] reset_counter = 6'b111111;
    wire reset = reset_counter[5];

    always @(posedge clk_soc) begin
        if (btn_rst == 1)
            reset_counter <= 6'b111111;
        else if(!locked)
            reset_counter <= 6'b111111;
        else if(|reset_counter)
            reset_counter <= reset_counter - 1;
    end

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

        .cdata(ac_addr1_cdata),//ac_addr1_cdata
        .cclk(ac_scl_cclk),//ac_scl_cclk
        .clatch_n(ac_addr0_clatch)//ac_addr0_clatch
    );


    // sin <=> i2s
    wire [23:0] adau_audio_in_l, adau_audio_in_r;
    wire adau_audio_in_valid, adau_audio_full;
    wire [7:0] spi_csn_o;
    assign spi_flash_ss = spi_csn_o[0];
    assign spi_sd_ss = spi_csn_o[1];

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

    // CPU bus logic
    wire [31:0] bus_addr, bus_wdata, bus_rdata;
    wire bus_stb, bus_we, bus_stall, bus_ack;
    wire [3:0] bus_sel;

     wishbone_bus_logic bus(
        .clk(clk_soc),
        .reset(reset),
        .i_wb_addr(bus_addr),
        .i_wb_data(bus_wdata),
        .i_wb_sel(bus_sel),
        .o_wb_data(bus_rdata),
        .i_wb_stb(bus_stb),
        .i_wb_we(bus_we),
        .o_wb_stall(bus_stall),
        .o_wb_ack(bus_ack),
        

        .dip(dip),
        .buttons({btn_c, btn_d, btn_l, btn_r, btn_u}),
        .led(led),

        .adau_audio_l(adau_audio_in_l),
        .adau_audio_r(adau_audio_in_r),
        .adau_audio_valid(adau_audio_in_valid),
        .adau_audio_full(adau_audio_full),
        .adau_init_done(adau_init_done)
    );
  
  // The Core Of The Problem ----------------------------------------------------------------
  // -------------------------------------------------------------------------------------------
   neorv32_top #(
   //-- Global control --
    .CLOCK_FREQUENCY(100000000),   // clock frequency of clk_i in Hz
    .INT_BOOTLOADER_EN(1'b1),       // boot configuration: true = boot explicit bootloader; false = boot from int/ext (I)MEM
    .USER_CODE(0),                    // custom user code
    .HW_THREAD_ID(0),                // hardware thread id (hartid)
    //-- On-Chip Debugger (OCD) --
    .ON_CHIP_DEBUGGER_EN(1'b1),         //implement on-chip debugger
    //-- RISC-V CPU Extensions --
    .CPU_EXTENSION_RISCV_A(1'b0),        //implement atomic extension?
    .CPU_EXTENSION_RISCV_C(1'b1),        //implement compressed extension?
    .CPU_EXTENSION_RISCV_E(1'b0),       //implement embedded RF extension?
    .CPU_EXTENSION_RISCV_M(1'b1),        //implement muld/div extension?
    .CPU_EXTENSION_RISCV_U(1'b1),        //implement user mode extension?
    .CPU_EXTENSION_RISCV_Zfinx(1'b0),    //implement 32-bit floating-point extension (using INT reg!)
    .CPU_EXTENSION_RISCV_Zicsr(1'b1),    //implement CSR system?
    .CPU_EXTENSION_RISCV_Zifencei(1'b0), //implement instruction stream sync.?
    //-- Extension Options --
    .FAST_MUL_EN(1'b0),                  //use DSPs for M extension's multiplier
    .FAST_SHIFT_EN(1'b0),                //use barrel shifter for shift operations
    .CPU_CNT_WIDTH(64),                //total width of CPU cycle and instret counters (0..64)
    //-- Physical Memory Protection (PMP) --
    .PMP_NUM_REGIONS(0),              //number of regions (0..64)
    .PMP_MIN_GRANULARITY(64*1024),          //minimal region granularity in bytes, has to be a power of 2, min 8 bytes
    //-- Hardware Performance Monitors (HPM) --
    .HPM_NUM_CNTS(4),                 //number of implemented HPM counters (0..29)
    .HPM_CNT_WIDTH(40),                //total size of HPM counters (0..64)
    //-- Internal Instruction memory --
    .MEM_INT_IMEM_EN(1'b1),              //implement processor-internal instruction memory
    .MEM_INT_IMEM_SIZE(192*1024),            //size of processor-internal instruction memory in bytes
    //-- Internal Data memory --
    .MEM_INT_DMEM_EN(1'b1),              //implement processor-internal data memory
    .MEM_INT_DMEM_SIZE(96*1024),            //size of processor-internal data memory in bytes
    //-- Internal Cache memory --
    .ICACHE_EN(1'b0),                    //implement instruction cache
    .ICACHE_NUM_BLOCKS(4),            //i-cache: number of blocks (min 1), has to be a power of 2
    .ICACHE_BLOCK_SIZE(64),            //i-cache: block size in bytes (min 4), has to be a power of 2
    .ICACHE_ASSOCIATIVITY(1),         //i-cache: associativity / number of sets (1=direct_mapped), has to be a power of 2
    //-- External memory interface --
    .MEM_EXT_EN(1'b1),                   //implement external memory bus interface?
    .MEM_EXT_TIMEOUT(0),              //cycles after a pending bus access auto-terminates (0 = disabled)
    //-- Processor peripherals --
    .IO_GPIO_EN(1'b1),                   // implement general purpose input/output port unit (GPIO)?
    .IO_MTIME_EN(1'b1),                  // implement machine system timer (MTIME)?
    .IO_UART0_EN(1'b1),                  // implement primary universal asynchronous receiver/transmitter (UART0)?
    .IO_UART1_EN(1'b0),                  // implement secondary universal asynchronous receiver/transmitter (UART1)?
    .IO_SPI_EN(1'b1),                    // implement serial peripheral interface (SPI)?
    .IO_TWI_EN(1'b1),                    // implement two-wire interface (TWI)?
    .IO_PWM_NUM_CH(1),                // number of PWM channels to implement (0..60); 0 = disabled, initial value is 0
    .IO_WDT_EN(1'b1),                    // implement watch dog timer (WDT)?
    .IO_TRNG_EN(1'b0),                   // implement true random number generator (TRNG)?
    .IO_CFS_EN(1'b0),                    // implement custom functions subsystem (CFS)?
    .IO_CFS_CONFIG(0),                // custom CFS configuration generic
    .IO_CFS_IN_SIZE(32),               // size of CFS input conduit in bits
    .IO_CFS_OUT_SIZE(32),              // size of CFS output conduit in bits
    .IO_NEOLED_EN(1'b0),                 // implement NeoPixel-compatible smart LED interface (NEOLED)?
    .XIRQ_NUM_CH(5),
    .XIRQ_TRIGGER_POLARITY(32'h00000000)
  )
  neorv32_top_inst (
    //-- Global control --
    .clk_i(clk_soc),           //-- global clock, rising edge
    .rstn_i(~reset),          //-- global reset, low-active, async
    //-- JTAG on-chip debugger interface (available if ON_CHIP_DEBUGGER_EN = true) --
    .jtag_trst_i(jtag_trst_i),          //-- low-active TAP reset (optional)
    .jtag_tck_i(jtag_tck_i),         //-- serial clock
    .jtag_tdi_i(jtag_tdi_i),         //-- serial data input
    .jtag_tdo_o(jtag_tdo_o),          //-- serial data output
    .jtag_tms_i(jtag_tms_i),          //-- mode select
    //-- Wishbone bus interface (available if MEM_EXT_EN = true) --
    .wb_tag_o(),          //-- tag
    .wb_adr_o(bus_addr),            //-- address
    .wb_dat_i(bus_rdata), //-- read data {n {1'b0}} 
    .wb_dat_o(bus_wdata),            //-- write data
    .wb_we_o(bus_we),            //-- read/write
    .wb_sel_o(bus_sel),            //-- byte enable
    .wb_stb_o(bus_stb),            //-- strobe
    .wb_cyc_o(),            //-- valid cycle
    .wb_lock_o(),            //-- exclusive access request
    .wb_ack_i(bus_ack),             //-- transfer acknowledge
    .wb_err_i(0),             //-- transfer error
    //-- Advanced memory control signals (available if MEM_EXT_EN = true) --
    .fence_o(),            //-- indicates an executed FENCE operation
    .fencei_o(),            //-- indicates an executed FENCEI operation
    //-- GPIO (available if IO_GPIO_EN = true) --
    .gpio_o(gpio_o),        //-- parallel output
    .gpio_i({btn_c, btn_d, btn_l, btn_u, btn_r}), //-- parallel input {n {1'b0}} 
    //-- primary UART0 (available if IO_UART0_EN = true) --
    .uart0_txd_o(uart0_txd_o),     //-- UART0 send data
    .uart0_rxd_i(uart0_rxd_i),     //-- UART0 receive data
    .uart0_rts_o(),            //-- hw flow control: UART0.RX ready to receive ("RTR"), low-active, optional
    .uart0_cts_i(0),             //-- hw flow control: UART0.TX allowed to transmit, low-active, optional
    //-- secondary UART1 (available if IO_UART1_EN = true) --
    .uart1_txd_o(),            //-- UART1 send data
    .uart1_rxd_i(0),             //-- UART1 receive data
    .uart1_rts_o(),            //-- hw flow control: UART1.RX ready to receive ("RTR"), low-active, optional
    .uart1_cts_i(0),             //-- hw flow control: UART1.TX allowed to transmit, low-active, optional
    //-- SPI (available if IO_SPI_EN = true) --
    .spi_sck_o(spi_clk),            //-- SPI serial clock
    .spi_sdo_o(spi_mosi),            //-- controller data out, peripheral data in
    .spi_sdi_i(spi_miso),             //-- controller data in, peripheral data out
    .spi_csn_o(spi_csn_o),            //-- SPI CS
    
    //-- TWI (available if IO_TWI_EN = true) --
    .twi_sda_io(i2c_sda),            //-- twi serial data line
    .twi_scl_io(i2c_scl),            //-- twi serial clock line
    //-- PWM (available if IO_PWM_NUM_CH > 0) --
    .pwm_o({pwm_led}),            //-- pwm channels
    //-- Custom Functions Subsystem IO --
    .cfs_in_i(0), //-- custom inputs {n {1'b0}} 
    .cfs_out_o(),            //-- custom outputs
    //-- NeoPixel-compatible smart LED interface (available if IO_NEOLED_EN = true) --
    .neoled_o(),           // -- async serial data line
    //-- System time --
    .mtime_i(0), //-- current system time from ext. MTIME (if IO_MTIME_EN = false) {n {1'b0}} 
    .mtime_o(),            //-- current system time from int. MTIME (if IO_MTIME_EN = true)
    //-- Interrupts --
    .nm_irq_i(0),             //-- non-maskable interrupt
    .mtime_irq_i(0),             //-- machine timer interrupt, available if IO_MTIME_EN = false
    .msw_irq_i(0),             //-- machine software interrupt
    .mext_irq_i(0),              //-- machine external interrupt
    .xirq_i({btn_c, btn_d, btn_l, btn_u, btn_r})
  );

    // Debug signals
    assign debug[7:0] = {ac_mclk, ac_bclk, ac_lrclk, ac_dac_sdata, ac_scl_cclk, ac_addr1_cdata, ac_addr0_clatch, reset};
endmodule
