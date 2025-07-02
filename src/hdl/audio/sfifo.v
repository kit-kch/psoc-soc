////////////////////////////////////////////////////////////////////////////////
//
// Filename: 	sfifo.v
//
// Project:	Verilog Tutorial Example file
//
// Purpose:	A synchronous data FIFO.
//
// Creator:	Dan Gisselquist, Ph.D.
//		Gisselquist Technology, LLC
//
// Modified by Johannes Pfau to work with single ported RAM. Read has priority
//
////////////////////////////////////////////////////////////////////////////////
//
// Written and distributed by Gisselquist Technology, LLC
//
// This program is hereby granted to the public domain.
//
// This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTIBILITY or
// FITNESS FOR A PARTICULAR PURPOSE.
//
////////////////////////////////////////////////////////////////////////////////
module sfifo(i_clk, i_wr, i_data, o_ready, o_full, o_fill, i_rd, o_data, o_empty);
	parameter	BW=32;	// Byte/data width
	parameter 	LGFLEN=4;

	input	wire		i_clk;
	// Write interface
	input	wire		i_wr;
	input	wire [(BW-1):0]	i_data;
	output	wire		o_ready;
	output	reg 		o_full;
	output	reg [LGFLEN:0]	o_fill;
	// Read interface
	input	wire		i_rd;
	output	wire [(BW-1):0]	o_data;
	output	reg		o_empty;

	reg	[(BW-1):0]	fifo_mem[0:(1<<LGFLEN)-1];
	reg	[LGFLEN:0]	wr_addr, rd_addr;
	reg	[LGFLEN-1:0]	rd_next;

	wire	w_wr = (i_wr && !o_full);
	wire	w_rd = (i_rd && !o_empty);

	assign o_ready = !i_rd;

	//
	// Write a new value into our FIFO
	//
	initial	wr_addr = 0;
	always @(posedge i_clk)
	if (!i_rd && w_wr)
		wr_addr <= wr_addr + 1'b1;

	// Instantiate the memory
    sfifo_mem #(.BW(BW), .LGFLEN(LGFLEN)) mem(
        .i_clk(i_clk),
        .i_wr(w_wr),
		.i_wr_addr(wr_addr[(LGFLEN-1):0]),
        .i_data(i_data),
        .i_rd(i_rd),
        .i_rd_addr(rd_addr[LGFLEN-1:0]),
        .o_data(o_data)
    );

	//
	// Read a value back out of it
	//
	initial	rd_addr = 0;
	always @(posedge i_clk)
	if (w_rd)
		rd_addr <= rd_addr + 1;

	//
	// Return some metrics of the FIFO, it's current fill level,
	// whether or not it is full, and likewise whether or not it is
	// empty
	//
	always @(*)
		o_fill = wr_addr - rd_addr;
	always @(*)
		o_full = o_fill == { 1'b1, {(LGFLEN){1'b0}} };
	always @(*)
		o_empty = (o_fill  == 0);


	always @(*)
		rd_next = rd_addr[LGFLEN-1:0] + 1;

endmodule
