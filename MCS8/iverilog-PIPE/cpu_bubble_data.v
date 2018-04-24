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
	E_DST_I, E_VALID_I, E_DSTR_CS_I, E_DSTR_CS_C_I, E_DSTR_CS_S_I, E_DSTR_CS_E_I, E_DSTR_CS_M_I,
	M_DST_I, M_VALID_I, M_DSTR_CS_I, M_DSTR_CS_C_I, M_DSTR_CS_S_I, M_DSTR_CS_E_I, M_DSTR_CS_M_I,
	W_DST_I, W_VALID_I, W_DSTR_CS_I, W_DSTR_CS_C_I, W_DSTR_CS_S_I, W_DSTR_CS_E_I, W_DSTR_CS_M_I,
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
	input wire [2:0]	E_DST_I;
	input wire			E_VALID_I;
	input wire			E_DST_CS_I;
	input wire			E_DSTR_CS_C_I;
	input wire			E_DSTR_CS_S_I;
	input wire			E_DSTR_CS_E_I;
	input wire			E_DSTR_CS_M_I;
	input wire [2:0]	M_DST_I;
	input wire			M_VALID_I;
	input wire			M_DST_CS_I;
	input wire			M_DSTR_CS_C_I;
	input wire			M_DSTR_CS_S_I;
	input wire			M_DSTR_CS_E_I;
	input wire			M_DSTR_CS_M_I;
	input wire [2:0]	W_DST_I;
	input wire			W_VALID_I;
	input wire			W_DST_CS_I;
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
	wire				wE_Enable;
	wire				wM_Enable;
	wire				wW_Enable;

	// **********
	// INSTANCE MODULE
	// **********
	assign wE_Enable = (~(|(E_DST_I ^ REG_SRC_I))) & E_VALID_I;
	assign wM_Enable = (~(|(M_DST_I ^ REG_SRC_I))) & M_VALID_I;
	assign wW_Enable = (~(|(W_DST_I ^ REG_SRC_I))) & W_VALID_I;
	assign BUBBLE_DATA_O = (wE_Enable & (E_DSTR_CS_E_I | E_DSTR_CS_M_I)) |
						   (wM_Enable & (M_DSTR_CS_M_I));

	// **********
	// MAIN CODE
	// **********
	
endmodule
