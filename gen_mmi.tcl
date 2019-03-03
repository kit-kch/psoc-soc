# This script will generate the file psoc_fpga.mmi from an implemented design,
# which can then be used in conjunction with the updatemem tool to replace the
# contents of the RISC-V CPU memory (i.e. the firmware).
# A few assumptions are made:
# - The part number is xc7z020clg484-1.
# - The memory is 8k*32bit = 32KiB big.
# - It is implemented using 8 RAMB36E1 cells which are all configured as 8k*4bit.
# - Sorting the cells by their names orders them from low to high output bits.
#   To get the name of the inferred BRAMs, Vivado postfixes the name of Verilog
#   memory with "_reg_0_0", "_reg_0_1", "_reg_1_0", ... "_reg_2_1", etc. This
#   behaviour is not documented, however it seems stable across different versions.
open_run impl_1

set mmi [open psoc_fpga.mmi w]

puts $mmi {
<?xml version="1.0" encoding="UTF-8"?>
<MemInfo Version="1" Minor="0">
  <Processor Endianness="Little" InstPath="riscv">
    <AddressSpace Name="riscv" Begin="0" End="8191">
      <BusBlock>
}

set rambs [lsort [get_cells -hierarchical -filter { PRIMITIVE_TYPE == BMEM.bram.RAMB36E1 && NAME =~ "ram/words*" }]]
set msb 3
set lsb 0

foreach site [get_property SITE $rambs] {
    puts $mmi "
        <BitLane MemType=\"RAMB32\" Placement=\"$site\">
          <DataWidth MSB=\"$msb\" LSB=\"$lsb\" />
          <AddressRange Begin=\"0\" End=\"8191\" />
          <Parity ON=\"false\" NumBits=\"0\" />
        </BitLane>
    "
    set msb [expr $msb + 4]
    set lsb [expr $lsb + 4]
}

puts $mmi {
      </BusBlock>
    </AddressSpace>
  </Processor>
  <Config>
    <Option Name="Part" Val="xc7z020clg484-1" />
  </Config>
</MemInfo>
}

close $mmi
