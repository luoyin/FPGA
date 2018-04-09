// **********
// COPYRIGHT(c) 2018, LUOYIN
// All rights reserved
// 
// IP LIB INDEX	:
// IP Name		: 
// File Name	: 
// Module Name	: 
// Full Name	: 
// 
// Author		: 
// Email		: 
// Data			: 
// Version		: 
//
// Abstract		: 
// Called By	: 
// 
// Modification Histroy
// 
// **********

// **********
// DEFINE MODEL PORT
// **********
//
module cpu_stack(
	CLK1_I, CLK2_I, SYNC_I, nRST_I,
	RD_I, WR_I, HA_I, INCR_I,
	PUSH_I, POP_I,
	DAT_I, DAT_O
);

	// **********
	// DEFINE PARAMETER
	// **********

	// **********
	// DEFINE INPUT
	// **********
	input wire CLK1_I, CLK2_I, SYNC_I, nRST_I;
	input wire RD_I, WR_I, HA_I, INCR_I;
	input wire PUSH_I, POP_I;
	input wire [7:0] DAT_I;
	
	// **********
	// DEFINE OUTPUT
	// **********
	output wire [7:0] DAT_O;

	// **********
	// ATRRIBUTE
	// **********
	reg [13:0] rStack [7:0];
	reg [2:0] rStack_ndx;
	wire [7:0] wRDH;
	wire [7:0] wRDL;

	// **********
	// INSTANCE MODULE
	// **********

	// **********
	// MAIN CODE
	// **********
	assign wRDH = { 1'b0, 1'b0, { 6{RD_I&HA_I} } };
	assign wRDL = { 8{RD_I&(~HA_I)} };
	assign DAT_O = (wRDH & {1'b0, 1'b0, rStack[rStack_ndx][13:8]}) | (wRDL & rStack[rStack_ndx][7:0]);
	
	always @(posedge CLK2_I) begin
		if(~nRST_I) begin
			rStack[0] <= 14'b0;
			rStack[1] <= 14'b0;
			rStack[2] <= 14'b0;
			rStack[3] <= 14'b0;
			rStack[4] <= 14'b0;
			rStack[5] <= 14'b0;
			rStack[6] <= 14'b0;
			rStack[7] <= 14'b0;
			rStack_ndx <= 3'b0;
			end
		else if(WR_I&HA_I) begin
			rStack[rStack_ndx][13:8] <= DAT_I[5:0];
			end
		else if(WR_I&(~HA_I)) begin
			rStack[rStack_ndx][7:0] <= DAT_I[7:0];
			end
		else if(INCR_I) begin
			rStack[rStack_ndx] <= rStack[rStack_ndx]+1;
			end
		else if(PUSH_I) begin
			rStack_ndx <= rStack_ndx+1;
			end
		else if(POP_I) begin
			rStack_ndx <= rStack_ndx-1;
			end
		end
	
endmodule
