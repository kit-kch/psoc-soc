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
    gpio_o         : out std_ulogic_vector(63 downto 0); -- parallel output
    gpio_i         : in  std_ulogic_vector(63 downto 0) := (others => 'U'); -- parallel input

    -- primary UART0 (available if IO_UART0_EN = true) --
    uart0_txd_o    : out std_ulogic; -- UART0 send data
    uart0_rxd_i    : in  std_ulogic := 'U'; -- UART0 receive data

    -- SPI (available if IO_SPI_EN = true) --
    spi_sck_o      : out std_ulogic; -- SPI serial clock
    spi_sdo_o      : out std_ulogic; -- controller data out, peripheral data in
    spi_sdi_i      : in  std_ulogic := 'U'; -- controller data in, peripheral data out
    spi_csn_o      : out std_ulogic_vector(07 downto 0); -- chip-select

    -- TWI (available if IO_TWI_EN = true) --
    twi_sda_io     : inout std_logic; -- twi serial data line
    twi_scl_io     : inout std_logic; -- twi serial clock line

    -- PWM (available if IO_PWM_NUM_CH > 0) --
    pwm_o          : out std_ulogic_vector(59 downto 0); -- pwm channels

    -- External platform interrupts (available if XIRQ_NUM_CH > 0) --
    xirq_i         : in  std_ulogic_vector(31 downto 0) := (others => 'L') -- IRQ channels
  );
end neorv32_wrap;

architecture rtl of neorv32_wrap is
    signal onewire_unconnected : std_logic;
begin

    inst: neorv32_top
    generic map (
        -- General --
        CLOCK_FREQUENCY => 99304000,  -- clock frequency of clk_i in Hz
        INT_BOOTLOADER_EN => true,  -- boot configuration: true = boot explicit bootloader; false = boot from int/ext (I)MEM

        -- On-Chip Debugger (OCD) --
        ON_CHIP_DEBUGGER_EN => true,  -- implement on-chip debugger

        -- RISC-V CPU Extensions --
        CPU_EXTENSION_RISCV_B => true,  -- implement bit-manipulation extension?
        CPU_EXTENSION_RISCV_C => true,  -- implement compressed extension?
        CPU_EXTENSION_RISCV_E => true,  -- implement embedded RF extension?
        CPU_EXTENSION_RISCV_M => true,  -- implement mul/div extension?
        CPU_EXTENSION_RISCV_U => true,  -- implement user mode extension?
        CPU_EXTENSION_RISCV_Zfinx => true,  -- implement 32-bit floating-point extension (using INT regs!)
        CPU_EXTENSION_RISCV_Zicsr => true,   -- implement CSR system?
        CPU_EXTENSION_RISCV_Zifencei => true,  -- implement instruction stream sync.?

        -- Internal Instruction memory (IMEM) --
        MEM_INT_IMEM_EN => true,  -- implement processor-internal instruction memory
        MEM_INT_IMEM_SIZE => 32*1024, -- size of processor-internal instruction memory in bytes

        -- Internal Data memory (DMEM) --
        MEM_INT_DMEM_EN => true,  -- implement processor-internal data memory
        MEM_INT_DMEM_SIZE => 96*1024, -- size of processor-internal data memory in bytes

        -- Internal Instruction Cache (iCACHE) --
        ICACHE_EN => true,  -- implement instruction cache
        ICACHE_NUM_BLOCKS => 8,      -- i-cache: number of blocks (min 1), has to be a power of 2
        ICACHE_BLOCK_SIZE => 64,     -- i-cache: block size in bytes (min 4), has to be a power of 2
        ICACHE_ASSOCIATIVITY => 2,      -- i-cache: associativity / number of sets (1=direct_mapped), has to be a power of 2

        -- External memory interface (WISHBONE) --
        MEM_EXT_EN => true,  -- implement external memory bus interface?
        -- TODO: Was 0, do we need this?
        --MEM_EXT_TIMEOUT              : natural := 255;    -- cycles after a pending bus access auto-terminates (0 = disabled)

        -- External Interrupts Controller (XIRQ) --
        XIRQ_NUM_CH => 5,  -- number of external IRQ channels (0..32)
        XIRQ_TRIGGER_TYPE => x"ffffffff", -- trigger type: 0=level, 1=edge
        XIRQ_TRIGGER_POLARITY => x"00000000", -- trigger polarity: 0=low-level/falling-edge, 1=high-level/rising-edge

        -- Processor peripherals --
        IO_GPIO_EN => true,  -- implement general purpose input/output port unit (GPIO)?
        IO_MTIME_EN => true,  -- implement machine system timer (MTIME)?
        IO_UART0_EN => true,  -- implement primary universal asynchronous receiver/transmitter (UART0)?
        IO_SPI_EN => true,  -- implement serial peripheral interface (SPI)?
        IO_TWI_EN => true,  -- implement two-wire interface (TWI)?
        IO_PWM_NUM_CH => 1,  -- number of PWM channels to implement (0..60); 0 = disabled
        IO_XIP_EN => true  -- implement execute in place module (XIP)?
    )
    port map (
        -- Global control --
        clk_i => clk_i, -- global clock, rising edge
        rstn_i => rstn_i, -- global reset, low-active, async

        -- JTAG on-chip debugger interface (available if ON_CHIP_DEBUGGER_EN = true) --
        jtag_trst_i => jtag_trst_i, -- low-active TAP reset (optional)
        jtag_tck_i => jtag_tck_i, -- serial clock
        jtag_tdi_i => jtag_tdi_i, -- serial data input
        jtag_tdo_o => jtag_tdo_o, -- serial data output
        jtag_tms_i => jtag_tms_i, -- mode select

        -- Wishbone bus interface (available if MEM_EXT_EN = true) --
        wb_tag_o => open, -- request tag
        wb_adr_o => wb_adr_o, -- address
        wb_dat_i => wb_dat_i, -- read data
        wb_dat_o => wb_dat_o, -- write data
        wb_we_o => wb_we_o, -- read/write
        wb_sel_o => wb_sel_o, -- byte enable
        wb_stb_o => wb_stb_o, -- strobe
        wb_cyc_o => open, -- valid cycle
        wb_ack_i => wb_ack_i, -- transfer acknowledge
        wb_err_i => 'L', -- transfer error

        -- Advanced memory control signals --
        fence_o => open, -- indicates an executed FENCE operation
        fencei_o => open, -- indicates an executed FENCEI operation

        -- XIP (execute in place via SPI) signals (available if IO_XIP_EN = true) --
        xip_csn_o => xip_csn_o, -- chip-select, low-active
        xip_clk_o => xip_clk_o, -- serial clock
        xip_sdi_i => xip_sdi_i, -- device data input
        xip_sdo_o => xip_sdo_o, -- controller data output

        -- TX stream interfaces (available if SLINK_NUM_TX > 0) --
        slink_tx_dat_o => open, -- output data
        slink_tx_val_o => open, -- valid output
        slink_tx_rdy_i => (others => 'L'), -- ready to send
        slink_tx_lst_o => open, -- last data of packet

        -- RX stream interfaces (available if SLINK_NUM_RX > 0) --
        slink_rx_dat_i => (others => (others => 'U')), -- input data
        slink_rx_val_i => (others => 'L'), -- valid input
        slink_rx_rdy_o => open, -- ready to receive
        slink_rx_lst_i => (others => 'L'), -- last data of packet

        -- GPIO (available if IO_GPIO_EN = true) --
        gpio_o => gpio_o, -- parallel output
        gpio_i => gpio_i, -- parallel input

        -- primary UART0 (available if IO_UART0_EN = true) --
        uart0_txd_o => uart0_txd_o, -- UART0 send data
        uart0_rxd_i => uart0_rxd_i, -- UART0 receive data
        uart0_rts_o => open, -- hw flow control: UART0.RX ready to receive ("RTR"), low-active, optional
        uart0_cts_i => 'L', -- hw flow control: UART1.TX allowed to transmit, low-active, optional

        -- secondary UART1 (available if IO_UART1_EN = true) --
        uart1_txd_o => open, -- UART1 send data
        uart1_rxd_i => 'U', -- UART1 receive data
        uart1_rts_o => open, -- hw flow control: UART1.RX ready to receive ("RTR"), low-active, optional
        uart1_cts_i => 'L', -- hw flow control: UART1.TX allowed to transmit, low-active, optional

        -- SPI (available if IO_SPI_EN = true) --
        spi_sck_o => spi_sck_o, -- SPI serial clock
        spi_sdo_o => spi_sdo_o, -- controller data out, peripheral data in
        spi_sdi_i => spi_sdi_i, -- controller data in, peripheral data out
        spi_csn_o => spi_csn_o, -- chip-select

        -- TWI (available if IO_TWI_EN = true) --
        twi_sda_io => twi_sda_io, -- twi serial data line
        twi_scl_io => twi_scl_io, -- twi serial clock line

        -- 1-Wire Interface (available if IO_ONEWIRE_EN = true) --
        onewire_io => onewire_unconnected, -- 1-wire bus

        -- PWM (available if IO_PWM_NUM_CH > 0) --
        pwm_o => pwm_o, -- pwm channels

        -- Custom Functions Subsystem IO (available if IO_CFS_EN = true) --
        cfs_in_i => (others => 'U'), -- custom CFS inputs conduit
        cfs_out_o => open, -- custom CFS outputs conduit

        -- NeoPixel-compatible smart LED interface (available if IO_NEOLED_EN = true) --
        neoled_o => open, -- async serial data line

        -- System time --
        mtime_i => (others => 'U'), -- current system time from ext. MTIME (if IO_MTIME_EN = false)
        mtime_o => open, -- current system time from int. MTIME (if IO_MTIME_EN = true)

        -- External platform interrupts (available if XIRQ_NUM_CH > 0) --
        xirq_i => xirq_i, -- IRQ channels

        -- CPU interrupts --
        mtime_irq_i => 'L', -- machine timer interrupt, available if IO_MTIME_EN = false
        msw_irq_i => 'L', -- machine software interrupt
        mext_irq_i => 'L'  -- machine external interrupt
    );

end rtl;
