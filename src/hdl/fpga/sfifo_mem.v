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
	input   wire [LGFLEN:0] i_wr_addr;
	// Read interface
	input	wire		i_rd;
	output	reg [(BW-1):0]	o_data;
	input   wire [LGFLEN:0] i_rd_addr;

	reg	[(BW-1):0]	fifo_mem[0:(1<<LGFLEN)-1];

	always @(posedge i_clk) begin
		if (i_rd)
			o_data <= fifo_mem[i_rd_addr];
		else if (i_wr)
			fifo_mem[i_wr_addr] <= i_data;
	end

endmodule
