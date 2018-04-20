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
module cpu_forward(
	REG_BANK_I, REG_SRC_I,
	M_VAL_C_I, M_VAL_S_I, M_VAL_E_I,
	W_VAL_C_I, W_VAL_S_I, W_VAL_E_I, W_VAL_M_I,
	M_DST_I, M_VALID_I, M_DSTR_CS_I, M_DSTR_CS_C_I, M_DSTR_CS_S_I, M_DSTR_CS_E_I,
	W_DST_I, W_VALID_I, W_DSTR_CS_I, W_DSTR_CS_C_I, W_DSTR_CS_S_I, W_DSTR_CS_E_I, W_DSTR_CS_M_I,
	REG_BANK_O
);

	// **********
	// DEFINE PARAMETER
	// **********

	// **********
	// DEFINE INPUT
	// **********
	input [7:0] 	REG_BANK_I;
	input [2:0] 	REG_SRC_I;
	input [7:0] 	M_VAL_C_I;
	input [7:0] 	M_VAL_S_I;
	input [7:0] 	M_VAL_E_I;
	input [7:0] 	W_VAL_C_I;
	input [7:0] 	W_VAL_S_I;
	input [7:0] 	W_VAL_E_I;
	input [7:0] 	W_VAL_M_I;
	input [2:0]		M_DST_I;
	input			M_VALID_I;
	input 			M_DSTR_CS_I;
	input			M_DSTR_CS_C_I;
	input			M_DSTR_CS_S_I;
	input			M_DSTR_CS_E_I;
	input [2:0]		W_DST_I;
	input			W_VALID_I;
	input 			W_DSTR_CS_I;
	input			W_DSTR_CS_C_I;
	input			W_DSTR_CS_S_I;
	input			W_DSTR_CS_E_I;
	input			W_DSTR_CS_M_I;

	// **********
	// DEFINE OUTPUT
	// **********
	output [7:0] 	REG_BANK_O;
	
	// **********
	// ATRRIBUTE
	// **********
	wire			wM_Enable;
	wire			wW_Enable;

	// **********
	// INSTANCE MODULE
	// **********
	assign wM_Enable = (~(|(M_DST_I ^ REG_SRC_I))) & M_DSTR_CS_I & M_VALID_I;
	assign wW_Enable = (~(|(W_DST_I ^ REG_SRC_I))) & W_DSTR_CS_I & W_VALID_I;

	// **********
	// MAIN CODE
	// **********

endmodule
