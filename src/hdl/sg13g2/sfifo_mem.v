////////////////////////////////////////////////////////////////////////////////
//
// Filename: 	sfifo_mem.v
//
// Purpose:	FIFO memory implementation for FPGA, using single port memory
//
// Creator:	Johannes Pfau
//
////////////////////////////////////////////////////////////////////////////////
module sfifo_mem(i_clk, i_wr, i_wr_addr, i_data, i_rd, i_rd_addr, o_data);
	parameter	BW=32;	// Byte/data width
	parameter 	LGFLEN=4;

	input	wire		i_clk;
	// Write interface
	input	wire		i_wr;
	input	wire [(BW-1):0]	i_data;
	input   wire [LGFLEN-1:0] i_wr_addr;
	// Read interface
	input	wire		i_rd;
	output	wire [(BW-1):0]	o_data;
	input   wire [LGFLEN-1:0] i_rd_addr;

    initial begin
        if (BW !== 48) begin
            $error("Parameter BW must be 48, but is %0d", BW);
            $finish;
        end
        if (LGFLEN !== 8) begin
            $error("Parameter LGFLEN must be 8, but is %0d", LGFLEN);
            $finish;
        end
    end

	// Map to IHP SRAM
	wire[LGFLEN-1:0] addr = i_rd ? i_rd_addr : i_wr_addr;
    RM_IHPSG13_1P_256x48_c2_bm_bist sram(
        .A_CLK(i_clk),
        .A_MEN(1'b1),
        .A_WEN(i_wr),
        .A_REN(i_rd),
        .A_ADDR(addr),
        .A_DIN(i_data),
        .A_DLY(1'b1),
        .A_DOUT(o_data),
        .A_BM('hFFFFFFFFFFFF),
        .A_BIST_CLK(1'b0),
        .A_BIST_EN(1'b0),
        .A_BIST_MEN(1'b0),
        .A_BIST_WEN(1'b0),
        .A_BIST_REN(1'b0),
        .A_BIST_ADDR(8'h00),
        .A_BIST_DIN(48'h000000000000),
        .A_BIST_BM(48'h000000000000)
    );

endmodule
