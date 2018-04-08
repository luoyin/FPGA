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
module cpu_decode(
	IR_I,
	D_NOP_O, D_HLT_O,
	D_INC_O, D_DCR_O, D_ROT_O, D_RETC_O, D_ALUI_O, D_RST_O, D_LRI_O, D_LMI_O, D_RET_O,
	D_JMPC_O, D_CALC_O, D_JMP_O, D_CAL_O, D_INP_O, D_OUT_O,
	D_ALUR_O, D_ALUM_O,
	D_LRR_O, D_LRM_O, D_LMR_O
);

	// **********
	// DEFINE PARAMETER
	// **********

	// **********
	// DEFINE INPUT
	// **********
	input wire [7:0] IR_I;

	// **********
	// DEFINE OUTPUT
	// **********
	output wire D_NOP_O, D_HLT_O;
	output wire D_INC_O, D_DCR_O, D_ROT_O, D_RETC_O, D_ALUI_O, D_RST_O, D_LRI_O, D_LMI_O, D_RET_O;
	output wire D_JMPC_O, D_CALC_O, D_JMP_O, D_CAL_O, D_INP_O, D_OUT_O;
	output wire D_ALUR_O, D_ALUM_O;
	output wire D_LRR_O, D_LRM_O, D_LMR_O;

	// **********
	// ATRRIBUTE
	// **********
	wire wOP00, wOP01, wOP10, wOP11;

	// **********
	// INSTANCE MODULE
	// **********
	assign wOP00		= (~IR_I[7])&(~IR_I[6]);
	assign wOP01 		= (~IR_I[7])&( IR_I[6]);
	assign wOP10 		= ( IR_I[7])&(~IR_I[6]);
	assign wOP11 		= ( IR_I[7])&( IR_I[6]);
	// NOP:			0000000x
	assign D_NOP_O		= (wOP00)&(~IR_I[5])&(~IR_I[4])&(~IR_I[3])&(~IR_I[2])&(~IR_I[1]);
	// HLT:			11111111
	assign D_HLT_O		= &IR_I;
	// INC:			00DDD000
	assign D_INC_O		= (wOP00)&(~(&IR_I[5:3]))&(|IR_I[5:3])&(~IR_I[2])&(~IR_I[1])&(~IR_I[0]);
	// DCR:			00DDD001
	assign D_INC_O		= (wOP00)&(~(&IR_I[5:3]))&(|IR_I[5:3])&(~IR_I[2])&(~IR_I[1])&( IR_I[0]);
	// ROT:			000xx010
	assign D_ROT_O		= (wOP00)&(~IR_I[5])&(~IR_I[2])&( IR_I[1])&(~IR_I[0]);
	// RETC:		00CCC011
	assign D_RETC_O		= (wOP00)&(~IR_I[2])&( IR_I[1])&( IR_I[0]);
	// ALUI:		00PPP100
	assign D_ALUI_O		= (wOP00)&( IR_I[2])&(~IR_I[1])&(~IR_I[0]);
	// RST:			00AAA101
	assign D_RST_O		= (wOP00)&( IR_I[2])&(~IR_I[1])&( IR_I[0]);
	// LRI:			00DDD110
	assign D_LRI_O		= (wOP00)&(~(&IR_I[5:3]))&( IR_I[2])&( IR_I[1])&(~IR_I[0]);
	// LMI:			00111110
	assign D_LMI_O		= (wOP00)&(&IR_I[5:3])&( IR_I[2])&( IR_I[1])&(~IR_I[0]);
	// RET:			00xxx111
	assign D_RET_O		= (wOP00)&( IR_I[2])&( IR_I[1])&( IR_I[0]);
	// JMPC:		01CCC000
	assign D_JMPC_O		= (wOP01)&(~IR_I[2])&(~IR_I[1])&(~IR_I[0]);
	// CALC:		01CCC010
	assign D_CALC_O		= (wOP01)&(~IR_I[2])&( IR_I[1])&(~IR_I[0]);
	// JMP:			01CCC100
	assign D_JMP_O		= (wOP01)&( IR_I[2])&(~IR_I[1])&(~IR_I[0]);
	// CAL:			01CCC110
	assign D_CAL_O		= (wOP01)&( IR_I[2])&( IR_I[1])&(~IR_I[0]);
	// INP:			0100MMM1
	assign D_INP_O		= (wOP01)&(~(&IR_I[5:4]))&( IR_I[0]);
	// OUT:			01RRMMM1
	assign D_OUT_O		= (wOP01)&(|IR_I[5:4])&( IR_I[0]);
	// ALUR:		10PPPSSS
	assign D_ALUR_O		= (wOP10)&(~(&IR_I[2:0]));
	// ALUM:		10PPP111
	assign D_ALUM_O		= (wOP10)&(&IR_I[2:0]);
	// LRR:			11DDDSSS
	assign D_LRR_O		= (wOP11)&(~(&IR_I[5:3]))&(~(&IR_I[2:0]));
	// LRM:			11DDD111
	assign D_LRM_O		= (wOP11)&(~(&IR_I[5:3]))&(&IR_I[2:0]);
	// LMR:			11111SSS
	assign D_LMR_O		= (wOP11)&(&IR_I[5:3])&(~(&IR_I[2:0]));
	
	// **********
	// MAIN CODE
	// **********
	
endmodule
