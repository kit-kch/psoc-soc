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
    wb_cyc_o       : out std_ulogic; -- valid cycle
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

        -- Hardware Performance Monitors (HPM) --
        HPM_NUM_CNTS => 1, -- number of implemented HPM counters (0..13)

        -- Internal Instruction memory (IMEM) --
        MEM_INT_IMEM_EN => false,  -- implement processor-internal instruction memory

        -- Internal Data memory (DMEM) --
        MEM_INT_DMEM_EN => true,  -- implement processor-internal data memory
        MEM_INT_DMEM_SIZE => 16*1024, -- size of processor-internal data memory in bytes

        -- Internal Instruction Cache (iCACHE) --
        ICACHE_EN => true,  -- implement instruction cache
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
        XIP_EN => true,  -- implement execute in place module (XIP)?
        CPU_RF_HW_RST_EN => true
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
        xbus_adr_o => wb_adr_o, -- address
        xbus_dat_i => wb_dat_i, -- read data
        xbus_dat_o => wb_dat_o, -- write data
        xbus_we_o => wb_we_o, -- read/write
        xbus_sel_o => wb_sel_o, -- byte enable
        xbus_stb_o => wb_stb_o, -- strobe
        xbus_cyc_o => wb_cyc_o, -- valid cycle
        xbus_ack_i => wb_ack_i, -- transfer acknowledge
        xbus_err_i => 'L', -- transfer error

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

end rtl;
