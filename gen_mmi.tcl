# This script will generate the file psoc_fpga.mmi from an implemented design,
# which can then be used in conjunction with the updatemem tool to replace the
# contents of the RISC-V CPU memory (i.e. the firmware).
# A few assumptions are made:
# - The part number is xc7z020clg484-1.
# - The memory is 4MiB big.
# - It is implemented using 120 RAMB36E1 cells which are all configured as 32k*1bit.
# - They are sorted like this:
#       _0_0_[0-7] are bits 0-7 of word 0   - 32k
#       _0_1_[0-7] are bits 0-7 of word 32k - 64k
#       _0_2_[0-7] are bits 0-7 of word 64k - 96k
#       _0_3_[0-7] are bits 0-7 of word 96k - 128k
#
#       _1_0_[0-7] are bits 8-15 of word 0   - 32k
#       _1_1_[0-7] are bits 8-15 of word 32k - 64k
#       _1_2_[0-7] are bits 8-15 of word 64k - 96k
#       _1_3_[0-7] are bits 8-15 of word 96k - 128k
# - Sorting the cells by their names orders them from low to high output bits.
#   To get the name of the inferred BRAMs, Vivado postfixes the name of Verilog
#   memory with "_reg_0_0_0", "_reg_0_0_1", "_reg_0_1_0", ... "_reg_0_2_1", etc. This
#   behaviour is not documented, however it seems stable across different versions.
open_run impl_1

set mmi [open fpga_riscv_top.mmi w]

puts $mmi {
<?xml version="1.0" encoding="UTF-8"?>
<MemInfo Version="1" Minor="0">
  <Processor Endianness="Little" InstPath="riscv">
    <AddressSpace Name="riscv" Begin="0" End="131071">
      <BusBlock>
}

set rambs [lsort [get_cells -hierarchical -filter { PRIMITIVE_TYPE == BMEM.bram.RAMB36E1 && NAME =~ "ram/words*" }]]

foreach ram $rambs {
    set site [get_property SITE $ram]
    # Remove RAMB36_ prefix
    set site [string replace $site 0 [string length "RAMB36_"]-1]
    set name [get_property NAME $ram]
    set bram_addr_begin [get_property bram_addr_begin $ram]
    set bram_addr_end [get_property bram_addr_end $ram]
    set bram_slice_begin [get_property bram_slice_begin $ram]
    set bram_slice_end [get_property bram_slice_end $ram]

    set m1 0
    set mall {}
    regexp -- {.*words_reg_(\d*)_\d*} $name mall m1

    set msb [expr $bram_slice_end + (8 * $m1)]
    set lsb [expr $bram_slice_begin + (8 * $m1)]
    
    # Convert addresses to bytes
    set bram_addr_begin [expr $bram_addr_begin * 4]
    set bram_addr_end [expr (($bram_addr_end + 1) * 4 ) - 1]

    puts $mmi "
        <BitLane MemType=\"RAMB32\" Placement=\"$site\">
          <DataWidth MSB=\"$msb\" LSB=\"$lsb\" />
          <AddressRange Begin=\"$bram_addr_begin\" End=\"$bram_addr_end\" />
          <Parity ON=\"false\" NumBits=\"0\" />
        </BitLane>
    "
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
