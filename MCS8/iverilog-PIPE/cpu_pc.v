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
module cpu_pc(
	CLK_I, nRST_I,
	D_OPCODE_I, E_ALU_OPR, 
	STATUS_I, ALU_STATUS_I,
	PC_O
);

	// **********
	// DEFINE PARAMETER
	// **********

	// **********
	// DEFINE INPUT
	// **********
	input wire				CLK_I;
	input wire				nRST_I;
	input wire	 [7:0]		D_OPCODE_I;
	input wire				E_ALU_OPR;
	input wire	 [3:0]		STATUS_I;
	input wire	 [3:0]		ALU_STATUS_I;
	
	// **********
	// DEFINE OUTPUT
	// **********
	output wire	[13:0]		PC_O;

	// **********
	// ATRRIBUTE
	// **********
	reg			[13:0]		rStack [7:0];
	reg			 [2:0]		rStack_ndx;

	// **********
	// INSTANCE MODULE
	// **********

	// **********
	// MAIN CODE
	// **********

endmodule
