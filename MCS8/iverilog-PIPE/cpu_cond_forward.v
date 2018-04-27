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
module cpu_cond_forward(
	D_OPCODE_I, 
	E_OPCODE_I, E_IFUN_I,
	E_ALU_STATUS_I, STATUS_I,
	COND_JMP_O, COND_CAL_O, COND_RET_O
);

	// **********
	// DEFINE PARAMETER
	// **********

	// **********
	// DEFINE INPUT
	// **********
	input wire	[7:0]		D_OPCODE_I;
	input wire	[7:0]		E_OPCODE_I;
	input wire	[2:0]		E_IFUN_I;
	input wire	[3:0]		E_ALU_STATUS_I;
	input wire	[3:0]		STATUS_I;

	// **********
	// DEFINE OUTPUT
	// **********
	output wire				COND_JMP_O;
	output wire				COND_CAL_O;
	output wire				COND_RET_O;

	// **********
	// ATRRIBUTE
	// **********
	wire					wD_INS_JMP_CAL;
	wire					wD_INS_RET;
	wire					wD_INS_RET;
	wire					wE_INS_ALU;
	wire					wE_INS_ROT;
	wire		[3:0]		wStatus;
	wire					wCOND;

	// **********
	// INSTANCE MODULE
	// **********
	// JMP/CAL: 01xxx100
	assign wD_INS_JMP_CAL	= (~D_OPCODE_I[7]) & ( D_OPCODE_I[6]) & (~D_OPCODE_I[0]);
	assign wE_INS_ALU		= ( ( D_OPCODE_I[7]) & (~D_OPCODE_I[6]) & (~(&D_OPCODE_I[2:0])) ) |
							  ( (~D_OPCODE_I[7]) & (~D_OPCODE_I[6]) & ( D_OPCODE_I[2]) & (~D_OPCODE_I[1]) & (~D_OPCODE_I[0]) );
	assign wE_INS_ROT		= ( (~D_OPCODE_I[7]) & (~D_OPCODE_I[6]) & (~D_OPCODE_I[2]) & ( D_OPCODE_I[1]) & (~D_OPCODE_I[0]) );
	
	assign wStatus			= ( {4{wE_INS_ALU}} & E_ALU_STATUS_I ) |
							  ( {STATUS_I[3:1], (wE_INS_ROT & E_ALU_STATUS_I[0])|STATUS_I[0]} );
	assign wCOND			= ( (~D_OPCODE_I[4]) & (~D_OPCODE_I[3])& wStatus[0] ) |
							  ( (~D_OPCODE_I[4]) & ( D_OPCODE_I[3])& wStatus[1] ) |
							  ( ( D_OPCODE_I[4]) & (~D_OPCODE_I[3])& wStatus[2] ) |
							  ( ( D_OPCODE_I[4]) & ( D_OPCODE_I[3])& wStatus[3] );
	assign COND_JMP_CAL_O	= wD_INS_JMP_CAL & ( ( D_OPCODE_I[2] ) | ( (~D_OPCODE_I[5])^wCOND ) );
	assign COND_RET_O		= wD_INS_RET     & ( ( D_OPCODE_I[2] ) | ( (~D_OPCODE_I[5])^wCOND ) );

	// **********
	// MAIN CODE
	// **********

endmodule
