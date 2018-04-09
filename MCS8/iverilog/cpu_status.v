// **********
// COPYRIGHT(c) 2018, LUOYIN
// All rights reserved
// 
// IP LIB INDEX	:
// IP Name		: Intel8008
// File Name	: cpu_status.v
// Module Name	: cpu_status
// Full Name	: CPU Status Register
// 
// Author		: LUO YIN
// Email		: luoyin1986@gmail.com
// Data			: 2018/04/09
// Version		: 1.0
//
// Abstract		:
// Called By	: cpu
// 
// Modification Histroy
// 
// **********

// **********
// DEFINE MODEL PORT
// **********
//
module cpu_status(
	CLK1_I, CLK2_I, SYNC_I, nRST_I,
	RD_I, WR_I,
	CF_I, PF_I, ZF_I, SF_I,
	CF_O, PF_O, ZF_O, SF_O, BUS_O
);

	// **********
	// DEFINE PARAMETER
	// **********

	// **********
	// DEFINE INPUT
	// **********
	input wire CLK1_I, CLK2_I, SYNC_I, nRST_I;
	input wire RD_I, WR_I;
	input wire CF_I, PF_I, ZF_I, SF_I;

	// **********
	// DEFINE OUTPUT
	// **********
	output wire CF_O, PF_O, ZF_O, SF_O;
	output wire [7:0] BUS_O;

	// **********
	// ATRRIBUTE
	// **********
	reg [3:0] rStatus;

	// **********
	// INSTANCE MODULE
	// **********

	// **********
	// MAIN CODE
	// **********
	assign CF_O = rStatus[3];
	assign PF_O = rStatus[2];
	assign ZF_O = rStatus[1];
	assign SF_O = rStatus[0];
	assign BUS_O = { 8{RD_I} } & { 4'b0, rStatus };
	
	always @(posedge CLK2_I) begin
		if(nRST_I)	rStatus <= 4'b0;
		else		rStatus <= { CF_I, PF_I, ZF_I, SF_I };
		end

endmodule
