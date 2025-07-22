onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /sg13g2_tb/uut/clk
add wave -noupdate /sg13g2_tb/uut/arstn
add wave -noupdate /sg13g2_tb/pwm0
add wave -noupdate /sg13g2_tb/pwm1
add wave -noupdate {/sg13g2_tb/uut/cpu/inst/memory_system_neorv32_int_dmem_enabled_neorv32_int_dmem_inst/\bus_req_i_bus_req_i[addr] }
add wave -noupdate {/sg13g2_tb/uut/cpu/inst/memory_system_neorv32_int_dmem_enabled_neorv32_int_dmem_inst/\bus_req_i_bus_req_i[data] }
add wave -noupdate {/sg13g2_tb/uut/cpu/inst/memory_system_neorv32_int_dmem_enabled_neorv32_int_dmem_inst/\bus_req_i_bus_req_i[ben] }
add wave -noupdate {/sg13g2_tb/uut/cpu/inst/memory_system_neorv32_int_dmem_enabled_neorv32_int_dmem_inst/\bus_req_i_bus_req_i[stb] }
add wave -noupdate {/sg13g2_tb/uut/cpu/inst/memory_system_neorv32_int_dmem_enabled_neorv32_int_dmem_inst/\bus_req_i_bus_req_i[rw] }
add wave -noupdate {/sg13g2_tb/uut/cpu/inst/memory_system_neorv32_int_dmem_enabled_neorv32_int_dmem_inst/\bus_rsp_o_bus_rsp_o[data] }
add wave -noupdate {/sg13g2_tb/uut/cpu/inst/memory_system_neorv32_int_dmem_enabled_neorv32_int_dmem_inst/\bus_rsp_o_bus_rsp_o[ack] }
add wave -noupdate {/sg13g2_tb/uut/cpu/inst/memory_system_neorv32_int_dmem_enabled_neorv32_int_dmem_inst/\bus_rsp_o_bus_rsp_o[err] }
add wave -noupdate -divider internal
add wave -noupdate /sg13g2_tb/uut/cpu/inst/memory_system_neorv32_int_dmem_enabled_neorv32_int_dmem_inst/word_addr
add wave -noupdate /sg13g2_tb/uut/cpu/inst/memory_system_neorv32_int_dmem_enabled_neorv32_int_dmem_inst/ram_addr
add wave -noupdate -radix binary -childformat {{{/sg13g2_tb/uut/cpu/inst/memory_system_neorv32_int_dmem_enabled_neorv32_int_dmem_inst/ram_row_en[1]} -radix binary} {{/sg13g2_tb/uut/cpu/inst/memory_system_neorv32_int_dmem_enabled_neorv32_int_dmem_inst/ram_row_en[0]} -radix binary}} -subitemconfig {{/sg13g2_tb/uut/cpu/inst/memory_system_neorv32_int_dmem_enabled_neorv32_int_dmem_inst/ram_row_en[1]} {-radix binary} {/sg13g2_tb/uut/cpu/inst/memory_system_neorv32_int_dmem_enabled_neorv32_int_dmem_inst/ram_row_en[0]} {-radix binary}} /sg13g2_tb/uut/cpu/inst/memory_system_neorv32_int_dmem_enabled_neorv32_int_dmem_inst/ram_row_en
add wave -noupdate /sg13g2_tb/uut/cpu/inst/memory_system_neorv32_int_dmem_enabled_neorv32_int_dmem_inst/ram_row_rdata
add wave -noupdate /sg13g2_tb/uut/cpu/inst/memory_system_neorv32_int_dmem_enabled_neorv32_int_dmem_inst/wr_mask
add wave -noupdate /sg13g2_tb/uut/cpu/inst/memory_system_neorv32_int_dmem_enabled_neorv32_int_dmem_inst/rdata
add wave -noupdate -divider c1r1
add wave -noupdate /sg13g2_tb/uut/cpu/inst/memory_system_neorv32_int_dmem_enabled_neorv32_int_dmem_inst/col_n1_row_n1_inst/A_WEN
add wave -noupdate /sg13g2_tb/uut/cpu/inst/memory_system_neorv32_int_dmem_enabled_neorv32_int_dmem_inst/col_n1_row_n1_inst/A_REN
add wave -noupdate /sg13g2_tb/uut/cpu/inst/memory_system_neorv32_int_dmem_enabled_neorv32_int_dmem_inst/col_n1_row_n1_inst/A_ADDR
add wave -noupdate /sg13g2_tb/uut/cpu/inst/memory_system_neorv32_int_dmem_enabled_neorv32_int_dmem_inst/col_n1_row_n1_inst/A_DIN
add wave -noupdate /sg13g2_tb/uut/cpu/inst/memory_system_neorv32_int_dmem_enabled_neorv32_int_dmem_inst/col_n1_row_n1_inst/A_BM
add wave -noupdate /sg13g2_tb/uut/cpu/inst/memory_system_neorv32_int_dmem_enabled_neorv32_int_dmem_inst/col_n1_row_n1_inst/A_DOUT
add wave -noupdate -divider c2r1
add wave -noupdate /sg13g2_tb/uut/cpu/inst/memory_system_neorv32_int_dmem_enabled_neorv32_int_dmem_inst/col_n2_row_n1_inst/A_WEN
add wave -noupdate /sg13g2_tb/uut/cpu/inst/memory_system_neorv32_int_dmem_enabled_neorv32_int_dmem_inst/col_n2_row_n1_inst/A_REN
add wave -noupdate /sg13g2_tb/uut/cpu/inst/memory_system_neorv32_int_dmem_enabled_neorv32_int_dmem_inst/col_n2_row_n1_inst/A_ADDR
add wave -noupdate /sg13g2_tb/uut/cpu/inst/memory_system_neorv32_int_dmem_enabled_neorv32_int_dmem_inst/col_n2_row_n1_inst/A_DIN
add wave -noupdate /sg13g2_tb/uut/cpu/inst/memory_system_neorv32_int_dmem_enabled_neorv32_int_dmem_inst/col_n2_row_n1_inst/A_BM
add wave -noupdate /sg13g2_tb/uut/cpu/inst/memory_system_neorv32_int_dmem_enabled_neorv32_int_dmem_inst/col_n2_row_n1_inst/A_DOUT
add wave -noupdate -divider c1r2
add wave -noupdate /sg13g2_tb/uut/cpu/inst/memory_system_neorv32_int_dmem_enabled_neorv32_int_dmem_inst/col_n1_row_n2_inst/A_WEN
add wave -noupdate /sg13g2_tb/uut/cpu/inst/memory_system_neorv32_int_dmem_enabled_neorv32_int_dmem_inst/col_n1_row_n2_inst/A_REN
add wave -noupdate /sg13g2_tb/uut/cpu/inst/memory_system_neorv32_int_dmem_enabled_neorv32_int_dmem_inst/col_n1_row_n2_inst/A_ADDR
add wave -noupdate /sg13g2_tb/uut/cpu/inst/memory_system_neorv32_int_dmem_enabled_neorv32_int_dmem_inst/col_n1_row_n2_inst/A_DIN
add wave -noupdate /sg13g2_tb/uut/cpu/inst/memory_system_neorv32_int_dmem_enabled_neorv32_int_dmem_inst/col_n1_row_n2_inst/A_BM
add wave -noupdate /sg13g2_tb/uut/cpu/inst/memory_system_neorv32_int_dmem_enabled_neorv32_int_dmem_inst/col_n1_row_n2_inst/A_DOUT
add wave -noupdate -divider c2r2
add wave -noupdate /sg13g2_tb/uut/cpu/inst/memory_system_neorv32_int_dmem_enabled_neorv32_int_dmem_inst/col_n2_row_n2_inst/A_WEN
add wave -noupdate /sg13g2_tb/uut/cpu/inst/memory_system_neorv32_int_dmem_enabled_neorv32_int_dmem_inst/col_n2_row_n2_inst/A_REN
add wave -noupdate /sg13g2_tb/uut/cpu/inst/memory_system_neorv32_int_dmem_enabled_neorv32_int_dmem_inst/col_n2_row_n2_inst/A_ADDR
add wave -noupdate /sg13g2_tb/uut/cpu/inst/memory_system_neorv32_int_dmem_enabled_neorv32_int_dmem_inst/col_n2_row_n2_inst/A_DIN
add wave -noupdate /sg13g2_tb/uut/cpu/inst/memory_system_neorv32_int_dmem_enabled_neorv32_int_dmem_inst/col_n2_row_n2_inst/A_BM
add wave -noupdate /sg13g2_tb/uut/cpu/inst/memory_system_neorv32_int_dmem_enabled_neorv32_int_dmem_inst/col_n2_row_n2_inst/A_DOUT
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {281644216 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 235
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {228977739 ps}
