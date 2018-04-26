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
module cpu_bubble_data(
	REG_SRC_I, REG_SRC_CS_I,
	M_DSTR_I, M_VALID_I, M_DSTR_CS_I, M_DSTR_CS_C_I, M_DSTR_CS_S_I, M_DSTR_CS_E_I, M_DSTR_CS_M_I,
	W_DSTR_I, W_VALID_I, W_DSTR_CS_I, W_DSTR_CS_C_I, W_DSTR_CS_S_I, W_DSTR_CS_E_I, W_DSTR_CS_M_I,
	BUBBLE_DATA_O
);

	// **********
	// DEFINE PARAMETER
	// **********

	// **********
	// DEFINE INPUT
	// **********
	input wire [2:0] 	REG_SRC_I;
	input wire			REG_SRC_CS_I;
	input wire [2:0]	M_DSTR_I;
	input wire			M_VALID_I;
	input wire			M_DSTR_CS_I;
	input wire			M_DSTR_CS_C_I;
	input wire			M_DSTR_CS_S_I;
	input wire			M_DSTR_CS_E_I;
	input wire			M_DSTR_CS_M_I;
	input wire [2:0]	W_DSTR_I;
	input wire			W_VALID_I;
	input wire			W_DSTR_CS_I;
	input wire			W_DSTR_CS_C_I;
	input wire			W_DSTR_CS_S_I;
	input wire			W_DSTR_CS_E_I;
	input wire			W_DSTR_CS_M_I;

	// **********
	// DEFINE OUTPUT
	// **********
	output wire			BUBBLE_DATA_O;

	// **********
	// ATRRIBUTE
	// **********
	wire				wM_Enable;
	wire				wW_Enable;

	// **********
	// INSTANCE MODULE
	// **********
	assign wM_Enable = (~(|(M_DSTR_I ^ REG_SRC_I))) & M_DSTR_CS_I & M_VALID_I;
	assign wW_Enable = (~(|(W_DSTR_I ^ REG_SRC_I))) & W_DSTR_CS_I & W_VALID_I;
	assign BUBBLE_DATA_O = ( wM_Enable) & (M_DSTR_CS_M_I);

	// **********
	// MAIN CODE
	// **********
	
endmodule
