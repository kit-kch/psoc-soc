--
-- Small wrapper for the neorv32 CPU. Configures the generics and only
-- exports the ports we need. This is especially important as this
-- code will be instantiated from verilog and vivado has some
-- issues with some of the neorv ports when using those in verilog.
-- Using a wrapper with simpler interface, we avoid that issue.
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library neorv32;
use neorv32.neorv32_package.all;

entity neorv32_wrap is
  port (
    -- Global control --
    clk_i          : in  std_ulogic; -- global clock, rising edge
    rstn_i         : in  std_ulogic; -- global reset, low-active, async

    -- JTAG on-chip debugger interface (available if ON_CHIP_DEBUGGER_EN = true) --
    jtag_trst_i    : in  std_ulogic := 'U'; -- low-active TAP reset (optional)
    jtag_tck_i     : in  std_ulogic := 'U'; -- serial clock
    jtag_tdi_i     : in  std_ulogic := 'U'; -- serial data input
    jtag_tdo_o     : out std_ulogic;        -- serial data output
    jtag_tms_i     : in  std_ulogic := 'U'; -- mode select

    -- Wishbone bus interface (available if MEM_EXT_EN = true) --
    wb_adr_o       : out std_ulogic_vector(31 downto 0); -- address
    wb_dat_i       : in  std_ulogic_vector(31 downto 0) := (others => 'U'); -- read data
    wb_dat_o       : out std_ulogic_vector(31 downto 0); -- write data
    wb_we_o        : out std_ulogic; -- read/write
    wb_sel_o       : out std_ulogic_vector(03 downto 0); -- byte enable
    wb_stb_o       : out std_ulogic; -- strobe
    wb_ack_i       : in  std_ulogic := 'L'; -- transfer acknowledge

    -- XIP (execute in place via SPI) signals (available if IO_XIP_EN = true) --
    xip_csn_o      : out std_ulogic; -- chip-select, low-active
    xip_clk_o      : out std_ulogic; -- serial clock
    xip_sdi_i      : in  std_ulogic := 'L'; -- device data input
    xip_sdo_o      : out std_ulogic; -- controller data output

    -- GPIO (available if IO_GPIO_EN = true) --
    gpio_o         : out std_ulogic_vector(1 downto 0); -- parallel output
    gpio_i         : in  std_ulogic_vector(6 downto 0) := (others => 'U'); -- parallel input
    i2s_fifo_low_i : in std_ulogic;

    -- primary UART0 (available if IO_UART0_EN = true) --
    uart0_txd_o    : out std_ulogic; -- UART0 send data
    uart0_rxd_i    : in  std_ulogic := 'U'; -- UART0 receive data

    -- SPI (available if IO_SPI_EN = true) --
    spi_sck_o      : out std_ulogic; -- SPI serial clock
    spi_sdo_o      : out std_ulogic; -- controller data out, peripheral data in
    spi_sdi_i      : in  std_ulogic := 'U'; -- controller data in, peripheral data out
    spi_csn_o      : out std_ulogic_vector(07 downto 0); -- chip-select

    -- TWI (available if IO_TWI_EN = true) --
    twi_sda_i      : in std_logic; -- twi serial data line
    twi_sda_o      : out std_logic; -- twi serial data line
    twi_scl_i      : in std_logic; -- twi serial clock line
    twi_scl_o      : out std_logic; -- twi serial clock line

    -- PWM (available if IO_PWM_NUM_CH > 0) --
    pwm_o          : out std_ulogic_vector(0 downto 0) -- pwm channels
  );
end neorv32_wrap;

architecture rtl of neorv32_wrap is
    signal onewire_unconnected : std_logic;

    signal gpio_o_tmp, gpio_i_tmp : std_ulogic_vector(31 downto 0);
    signal pwm_o_tmp : std_ulogic_vector(15 downto 0);

    -- jtagspi
    signal jtagspi_sck : std_ulogic;
    signal jtagspi_sdo : std_ulogic;
    signal jtagspi_csn : std_ulogic;

    signal xip_csn : std_ulogic;
    signal xip_clk : std_ulogic;
    signal xip_sdo : std_ulogic;

    -- xbus switch
    constant base_io_i2s_c : std_ulogic_vector(31 downto 0) := x"ffd00000";
    signal xbus_req : bus_req_t;
    signal xbus_rsp : bus_rsp_t;
    signal i2s_req : bus_req_t;
    signal i2s_rsp : bus_rsp_t;
begin

    gpio_o <= gpio_o_tmp(1 downto 0);
    pwm_o <= pwm_o_tmp(0 downto 0);
    gpio_i_tmp(6 downto 0) <= gpio_i;
    gpio_i_tmp(7) <= 'U';
    gpio_i_tmp(8) <= i2s_fifo_low_i;
    gpio_i_tmp(31 downto 9) <= (others => 'U');

    inst: neorv32_top
    generic map (
        -- General --
        CLOCK_FREQUENCY => 98304000,  -- clock frequency of clk_i in Hz
        BOOT_MODE_SELECT => 0,

        -- On-Chip Debugger (OCD) --
        OCD_EN => true,  -- implement on-chip debugger

        -- RISC-V CPU Extensions --
        RISCV_ISA_C => true,  -- implement compressed extension?
        RISCV_ISA_M => true,  -- implement mul/div extension?
        RISCV_ISA_U => true,  -- implement user mode extension?
        RISCV_ISA_Zfinx => true,  -- implement 32-bit floating-point extension (using INT regs!)

        -- Hardware Performance Monitors (HPM) --
        HPM_NUM_CNTS => 1, -- number of implemented HPM counters (0..13)

        -- Internal Instruction memory (IMEM) --
        MEM_INT_IMEM_EN => false,  -- implement processor-internal instruction memory

        -- Internal Data memory (DMEM) --
        MEM_INT_DMEM_EN => true,  -- implement processor-internal data memory
        MEM_INT_DMEM_SIZE => 16*1024, -- size of processor-internal data memory in bytes

        -- Internal Instruction Cache (iCACHE) --
        ICACHE_EN => false,  -- implement instruction cache
        ICACHE_NUM_BLOCKS => 8,      -- i-cache: number of blocks (min 1), has to be a power of 2
        ICACHE_BLOCK_SIZE => 64,     -- i-cache: block size in bytes (min 4), has to be a power of 2

        -- External memory interface (WISHBONE) --
        XBUS_EN => true,  -- implement external memory bus interface?

        -- Processor peripherals --
        IO_GPIO_NUM => 7,  -- implement general purpose input/output port unit (GPIO)?
        IO_CLINT_EN => true,  -- implement machine system timer (MTIME)?
        IO_UART0_EN => true,  -- implement primary universal asynchronous receiver/transmitter (UART0)?
        IO_SPI_EN => true,  -- implement serial peripheral interface (SPI)?
        IO_TWI_EN => true,  -- implement two-wire interface (TWI)?
        IO_PWM_NUM_CH => 1,  -- number of PWM channels to implement (0..60); 0 = disabled
        XIP_EN => true  -- implement execute in place module (XIP)?
    )
    port map (
        -- Global control --
        clk_i => clk_i, -- global clock, rising edge
        rstn_i => rstn_i, -- global reset, low-active, async

        -- JTAG on-chip debugger interface (available if ON_CHIP_DEBUGGER_EN = true) --
        jtag_tck_i => jtag_tck_i, -- serial clock
        jtag_tdi_i => jtag_tdi_i, -- serial data input
        jtag_tdo_o => jtag_tdo_o, -- serial data output
        jtag_tms_i => jtag_tms_i, -- mode select
        -- jtagspi passthrough support --
        jtagspi_sck_o => jtagspi_sck,
        jtagspi_sdo_o => jtagspi_sdo,
        jtagspi_sdi_i => xip_sdi_i,
        jtagspi_csn_o => jtagspi_csn,

        -- Wishbone bus interface (available if MEM_EXT_EN = true) --
        xbus_tag_o => open, -- request tag
        xbus_adr_o => xbus_req.addr, -- address
        xbus_dat_i => xbus_rsp.data, -- read data
        xbus_dat_o => xbus_req.data, -- write data
        xbus_we_o => xbus_req.rw, -- read/write
        xbus_sel_o => xbus_req.ben, -- byte enable
        xbus_stb_o => xbus_req.stb, -- strobe
        xbus_cyc_o => open, -- valid cycle
        xbus_ack_i => xbus_rsp.ack, -- transfer acknowledge
        xbus_err_i => xbus_rsp.err, -- transfer error

        -- XIP (execute in place via SPI) signals (available if IO_XIP_EN = true) --
        xip_csn_o => xip_csn, -- chip-select, low-active
        xip_clk_o => xip_clk, -- serial clock
        xip_dat_i => xip_sdi_i, -- device data input
        xip_dat_o => xip_sdo, -- controller data output

        -- GPIO (available if IO_GPIO_EN = true) --
        gpio_o => gpio_o_tmp, -- parallel output
        gpio_i => gpio_i_tmp, -- parallel input

        -- primary UART0 (available if IO_UART0_EN = true) --
        uart0_txd_o => uart0_txd_o, -- UART0 send data
        uart0_rxd_i => uart0_rxd_i, -- UART0 receive data
        uart0_rts_o => open, -- hw flow control: UART0.RX ready to receive ("RTR"), low-active, optional
        uart0_cts_i => '0', -- hw flow control: UART0.TX allowed to transmit, low-active, optional

        -- secondary UART1 (available if IO_UART1_EN = true) --
        uart1_txd_o => open, -- UART1 send data
        uart1_rxd_i => 'U', -- UART1 receive data
        uart1_rts_o => open, -- hw flow control: UART1.RX ready to receive ("RTR"), low-active, optional
        uart1_cts_i => 'L', -- hw flow control: UART1.TX allowed to transmit, low-active, optional

        -- SPI (available if IO_SPI_EN = true) --
        spi_clk_o => spi_sck_o, -- SPI serial clock
        spi_dat_o => spi_sdo_o, -- controller data out, peripheral data in
        spi_dat_i => spi_sdi_i, -- controller data in, peripheral data out
        spi_csn_o => spi_csn_o, -- chip-select

        -- TWI (available if IO_TWI_EN = true) --
        twi_sda_i => twi_sda_i, -- twi serial data line
        twi_sda_o => twi_sda_o, -- twi serial data line
        twi_scl_i => twi_scl_i, -- twi serial clock line
        twi_scl_o => twi_scl_o, -- twi serial clock line


        -- PWM (available if IO_PWM_NUM_CH > 0) --
        pwm_o => pwm_o_tmp, -- pwm channels


        -- CPU interrupts --
        mtime_irq_i => 'L', -- machine timer interrupt, available if IO_MTIME_EN = false
        msw_irq_i => 'L', -- machine software interrupt
        mext_irq_i => 'L'  -- machine external interrupt
    );

  -- jtagspi mux
  xip_csn_o <= jtagspi_csn and xip_csn;
  xip_clk_o <= jtagspi_sck when jtagspi_csn = '0' else xip_clk;
  xip_sdo_o <= jtagspi_sdo when jtagspi_csn = '0' else xip_sdo;

  -- Switch for the XBUS
  xbus_switch: entity neorv32.neorv32_bus_io_switch
  generic map (
    INREG_EN  => true,
    OUTREG_EN => true,
    DEV_SIZE  => iodev_size_c,
    DEV_00_EN => true,            DEV_00_BASE => base_io_i2s_c,
    DEV_01_EN => false,           DEV_01_BASE => (others => '0'),
    DEV_02_EN => false,           DEV_02_BASE => (others => '0'),
    DEV_03_EN => false,           DEV_03_BASE => (others => '0'),
    DEV_04_EN => false,           DEV_04_BASE => (others => '0'),
    DEV_05_EN => false,           DEV_05_BASE => (others => '0'),
    DEV_06_EN => false,           DEV_06_BASE => (others => '0'),
    DEV_07_EN => false,           DEV_07_BASE => (others => '0'),
    DEV_08_EN => false,           DEV_08_BASE => (others => '0'),
    DEV_09_EN => false,           DEV_09_BASE => (others => '0'),
    DEV_10_EN => false,           DEV_10_BASE => (others => '0'),
    DEV_11_EN => false,           DEV_11_BASE => (others => '0'),
    DEV_12_EN => false,           DEV_12_BASE => (others => '0'),
    DEV_13_EN => false,           DEV_13_BASE => (others => '0'),
    DEV_14_EN => false,           DEV_14_BASE => (others => '0'),
    DEV_15_EN => false,           DEV_15_BASE => (others => '0'),
    DEV_16_EN => false,           DEV_16_BASE => (others => '0'),
    DEV_17_EN => false,           DEV_17_BASE => (others => '0'),
    DEV_18_EN => false,           DEV_18_BASE => (others => '0'),
    DEV_19_EN => false,           DEV_19_BASE => (others => '0'),
    DEV_20_EN => false,           DEV_20_BASE => (others => '0'),
    DEV_21_EN => false,           DEV_21_BASE => (others => '0'),
    DEV_22_EN => false,           DEV_22_BASE => (others => '0'),
    DEV_23_EN => false,           DEV_23_BASE => (others => '0'),
    DEV_24_EN => false,           DEV_24_BASE => (others => '0'),
    DEV_25_EN => false,           DEV_25_BASE => (others => '0'),
    DEV_26_EN => false,           DEV_26_BASE => (others => '0'),
    DEV_27_EN => false,           DEV_27_BASE => (others => '0'),
    DEV_28_EN => false,           DEV_28_BASE => (others => '0'),
    DEV_29_EN => false,           DEV_29_BASE => (others => '0'),
    DEV_30_EN => false,           DEV_30_BASE => (others => '0'),
    DEV_31_EN => false,           DEV_31_BASE => (others => '0')
  )
  port map (
    clk_i        => clk_i,
    rstn_i       => rstn_i,
    main_req_i   => xbus_req,
    main_rsp_o   => xbus_rsp,
    dev_00_req_o => i2s_req,                  dev_00_rsp_i => i2s_rsp,
    dev_01_req_o => open,                     dev_01_rsp_i => rsp_terminate_c,
    dev_02_req_o => open,                     dev_02_rsp_i => rsp_terminate_c,
    dev_03_req_o => open,                     dev_03_rsp_i => rsp_terminate_c,
    dev_04_req_o => open,                     dev_04_rsp_i => rsp_terminate_c,
    dev_05_req_o => open,                     dev_05_rsp_i => rsp_terminate_c,
    dev_06_req_o => open,                     dev_06_rsp_i => rsp_terminate_c,
    dev_07_req_o => open,                     dev_07_rsp_i => rsp_terminate_c,
    dev_08_req_o => open,                     dev_08_rsp_i => rsp_terminate_c,
    dev_09_req_o => open,                     dev_09_rsp_i => rsp_terminate_c,
    dev_10_req_o => open,                     dev_10_rsp_i => rsp_terminate_c,
    dev_11_req_o => open,                     dev_11_rsp_i => rsp_terminate_c,
    dev_12_req_o => open,                     dev_12_rsp_i => rsp_terminate_c,
    dev_13_req_o => open,                     dev_13_rsp_i => rsp_terminate_c,
    dev_14_req_o => open,                     dev_14_rsp_i => rsp_terminate_c,
    dev_15_req_o => open,                     dev_15_rsp_i => rsp_terminate_c,
    dev_16_req_o => open,                     dev_16_rsp_i => rsp_terminate_c,
    dev_17_req_o => open,                     dev_17_rsp_i => rsp_terminate_c,
    dev_18_req_o => open,                     dev_18_rsp_i => rsp_terminate_c,
    dev_19_req_o => open,                     dev_19_rsp_i => rsp_terminate_c,
    dev_20_req_o => open,                     dev_20_rsp_i => rsp_terminate_c,
    dev_21_req_o => open,                     dev_21_rsp_i => rsp_terminate_c,
    dev_22_req_o => open,                     dev_22_rsp_i => rsp_terminate_c,
    dev_23_req_o => open,                     dev_23_rsp_i => rsp_terminate_c,
    dev_24_req_o => open,                     dev_24_rsp_i => rsp_terminate_c,
    dev_25_req_o => open,                     dev_25_rsp_i => rsp_terminate_c,
    dev_26_req_o => open,                     dev_26_rsp_i => rsp_terminate_c,
    dev_27_req_o => open,                     dev_27_rsp_i => rsp_terminate_c,
    dev_28_req_o => open,                     dev_28_rsp_i => rsp_terminate_c,
    dev_29_req_o => open,                     dev_29_rsp_i => rsp_terminate_c,
    dev_30_req_o => open,                     dev_30_rsp_i => rsp_terminate_c,
    dev_31_req_o => open,                     dev_31_rsp_i => rsp_terminate_c
  );

  -- The internal NEORV bus has additional signals. We don't use these 
  xbus_req.src <= '0';
  xbus_req.priv <= '0';
  xbus_req.amo <= '0';
  xbus_req.amoop <= (others => '0');
  xbus_req.fence <= '0';
  xbus_req.sleep <= '0';
  xbus_req.debug <= '0';

  -- Map back from internal representation to wishbone
  wb_adr_o <= i2s_req.addr;
  wb_dat_o <= i2s_req.data;
  wb_we_o <= i2s_req.rw;
  wb_sel_o <= i2s_req.ben;
  wb_stb_o <= i2s_req.stb;
  i2s_rsp.data <= wb_dat_i;
  i2s_rsp.ack <= wb_ack_i;
  i2s_rsp.err <= '0';

end rtl;
