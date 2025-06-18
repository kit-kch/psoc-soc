-- ================================================================================ --
-- NEORV32 SoC - Processor-Internal Data Memory (DMEM)                              --
-- -------------------------------------------------------------------------------- --
-- [TIP] This file can be replaced by a technology-specific implementation to       --
--       optimize timing, area, energy, etc.                                        --
-- -------------------------------------------------------------------------------- --
-- The NEORV32 RISC-V Processor - https://github.com/stnolting/neorv32              --
-- Copyright (c) NEORV32 contributors.                                              --
-- Copyright (c) 2020 - 2024 Stephan Nolting. All rights reserved.                  --
-- Licensed under the BSD-3-Clause license, see LICENSE for details.                --
-- SPDX-License-Identifier: BSD-3-Clause                                            --
-- ================================================================================ --

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library neorv32;
use neorv32.neorv32_package.all;

entity neorv32_dmem is
  generic (
    DMEM_SIZE : natural -- memory size in bytes, has to be a power of 2, min 4
  );
  port (
    clk_i     : in  std_ulogic; -- global clock line
    rstn_i    : in  std_ulogic; -- async reset, low-active
    bus_req_i : in  bus_req_t;  -- bus request
    bus_rsp_o : out bus_rsp_t   -- bus response
  );
end neorv32_dmem;

architecture neorv32_dmem_rtl of neorv32_dmem is

  -- alternative memory description style --
  constant alt_style_c : boolean := false; -- [TIP] enable this if synthesis fails to infer block RAM

  -- local signals --
  signal rdata         : std_logic_vector(31 downto 0);
  signal wr_mask       : std_logic_vector(31 downto 0);
  signal rden          : std_ulogic;
  signal addr, addr_ff : unsigned(index_size_f(DMEM_SIZE/4)-1 downto 0);

  signal wen, ren : std_logic;

  component RM_IHPSG13_1P_4096x16_c3_bm_bist is
    port (
      A_CLK: in std_logic;
      A_MEN: in std_logic;
      A_WEN: in std_logic;
      A_REN: in std_logic;
      A_ADDR: in std_logic_vector(11 downto 0);
      A_DIN: in std_logic_vector(15 downto 0);
      A_DLY: in std_logic;
      A_DOUT: out std_logic_vector(15 downto 0);
      A_BM: in std_logic_vector(15 downto 0);
      A_BIST_CLK: in std_logic;
      A_BIST_EN: in std_logic;
      A_BIST_MEN: in std_logic;
      A_BIST_WEN: in std_logic;
      A_BIST_REN: in std_logic;
      A_BIST_ADDR: in std_logic_vector(11 downto 0);
      A_BIST_DIN: in std_logic_vector(15 downto 0);
      A_BIST_BM: in std_logic_vector(15 downto 0)
  );
  end component;

begin

    -- Boot configuration: boot from initialized IMEM requires the IMEM to be enabled --
  assert (DMEM_SIZE = 16384) report
    "SG13G2 DMEM implementation is hardcoded for 16kB DMEM!" severity error;

  wen <= bus_req_i.stb and bus_req_i.rw;
  ren <= bus_req_i.stb and not bus_req_i.rw;
  -- Memory Core ----------------------------------------------------------------------------
  -- -------------------------------------------------------------------------------------------
  row: for i in 0 to 1 generate
    inst: RM_IHPSG13_1P_4096x16_c3_bm_bist
      port map (
        A_CLK => clk_i,
        A_MEN => '1',
        A_WEN => wen,
        A_REN => ren,
        A_ADDR => std_logic_vector(addr),
        A_DIN => std_logic_vector(bus_req_i.data(16*i+15 downto 16*i)),
        A_DLY => '1',
        A_DOUT => rdata(16*i+15 downto 16*i),
        A_BM => wr_mask(16*i+15 downto 16*i),
        A_BIST_CLK => '0',
        A_BIST_EN => '0',
        A_BIST_MEN => '0',
        A_BIST_WEN => '0',
        A_BIST_REN => '0',
        A_BIST_ADDR => x"000",
        A_BIST_DIN => x"0000",
        A_BIST_BM => x"0000"
    );
    wr_mask(16*i+7 downto 16*i) <= x"00" when bus_req_i.ben(i*2) = '0' else x"FF";
    wr_mask(16*i+15 downto 16*i+8) <= x"00" when bus_req_i.ben(i*2+1) = '0' else x"FF";
  end generate;


  -- word aligned access address --
  addr <= unsigned(bus_req_i.addr(index_size_f(DMEM_SIZE/4)+1 downto 2));

  -- Bus Response ---------------------------------------------------------------------------
  -- -------------------------------------------------------------------------------------------
  bus_feedback: process(rstn_i, clk_i)
  begin
    if (rstn_i = '0') then
      rden          <= '0';
      bus_rsp_o.ack <= '0';
    elsif rising_edge(clk_i) then
      rden          <= bus_req_i.stb and (not bus_req_i.rw);
      bus_rsp_o.ack <= bus_req_i.stb;
    end if;
  end process bus_feedback;

  bus_rsp_o.data <= std_ulogic_vector(rdata) when (rden = '1') else (others => '0'); -- output gate
  bus_rsp_o.err  <= '0'; -- no access error possible


end neorv32_dmem_rtl;