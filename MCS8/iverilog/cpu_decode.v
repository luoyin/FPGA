// **********
// COPYRIGHT(c) 2018, LUOYIN
// All rights reserved
// 
// IP LIB INDEX	: MCS8
// IP Name		: cpu
// File Name	: cpu_decode.v
// Module Name	: cpu_decode
// Full Name	: Instruction decoder of Intel8008 CPU
// 
// Author		: LUO YIN
// Email		: luoyin1986@gmail.com
// Data			: 2018/04/04
// Version		: 1.0
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
	D_LOAD_O,
	D_ALU_O, D_ROT_O,
	D_INC_O, D_DCR_O,
	D_JUMP_O, D_CALL_O,	D_RET_O,
	D_RST_O,
<<<<<<< HEAD
	D_INP_O,
	D_OUT_O,
	D_SRC_R_O,
	D_SRC_M_O,
	D_SRC_I_O,
	D_DST_R_O,
	D_DSt_M_O
=======
	D_INP_O, D_OUT_O,
	D_SRC_R_O, D_SRC_M_O, D_SRC_I_O,
	D_DST_R_O, D_DST_M_O,
	D_SRC_R_NDX_O, D_DST_R_NDX_O
>>>>>>> f2fd6529fb1f0921697e16b3afb7632b02ec9fb6
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
	output wire D_NOP_O;
	output wire D_HLT_O;
	output wire D_LOAD_O;
	output wire D_ALU_O;
	output wire D_ROT_O;
	output wire D_INC_O;
	output wire D_DCR_O;
	output wire D_JUMP_O;
	output wire D_CALL_O;
	output wire D_RET_O;
	output wire D_RST_O;
	output wire D_INP_O;
	output wire D_OUT_O;
	output wire D_SRC_R_O;
	output wire D_SRC_M_O;
	output wire D_SRC_I_O;
	output wire D_DST_R_O;
	output wire D_DST_M_O;
	output wire [2:0] D_SRC_R_NDX_O;
	output wire [2:0] D_DST_R_NDX_O;

	// **********
	// ATRRIBUTE
	// **********
	wire wOP00;
	wire wOP01;
	wire wOP10;
	wire wOP11;
	wire wOP00_INC, wOP00_DCR, wOP00_ROT, wOP00_RETC, wOP00_ALU, wOP00_RST, wOP00_LOAD, wOP00_RET;
	wire wSRC_R, wSRC_M, wDST_R, wDST_M;

	// **********
	// INSTANCE MODULE
	// **********
<<<<<<< HEAD
	// LOAD: 11xxxxxx/00xxx110
	assign D_LOAD_O 	= (( IR_I[7])&( IR_I[6])) | ((~IR_I[7])&(~IR_I[6])&( IR_I[2])&( IR_I[1])&(~IR_I[0]));
	// ALU: 10xxxxxx/00xxx100
	assign D_ALU_O  	= (( IR_I[7])&(~IR_I[6])) | ((~IR_I[7])&(~IR_I[6])&( IR_I[2])&(~IR_I[1])&(~IR_I[0]));
	// JUMP: 01xxxx00
	assign D_JUMP_O		= (~IR_I[7])&( IR_I[6])&(~IR_I[1])&(~IR_I[0]);
	// CALL: 01xxxx10
	assign D_CALL_O		= (~IR_I[7])&( IR_I[6])&( IR_I[1])&(~IR_I[0]);
	// RET: 00xxxx11
	assign D_RET_O		= (~IR_I[7])&(~IR_I[6])&( IR_I[1])&( IR_I[0]);
	// RST: 00xxx101
	assign D_RST_O		= (~IR_I[7])&(~IR_I[6])&( IR_I[2])&(~IR_I[1])&( IR_I[0]);
	// INP: 0100xxx1
	assign D_INP_O		= (~IR_I[7])&( IR_I[6])&(~IR_I[5])&(~IR_I[4])&( IR_I[0]);
	// OUT: 01RRxxx1
	assign D_OUT_O		= (~IR_I[7])&( IR_I[6])&( IR_I[5] |  IR_I[4])&( IR_I[0]);
	// SRC_R: 
=======
	// SRC_R_NDX
	assign D_SRC_R_NDX_O	= IR_I[2:0];
	// DST_R_NDX
	assign D_DST_R_NDX_O	= IR_I[5:3];
>>>>>>> f2fd6529fb1f0921697e16b3afb7632b02ec9fb6
	
	// OP00
	assign wOP00			= (~IR_I[7])&(~IR_I[6]);
	// OP01
	assign wOP01			= (~IR_I[7])&( IR_I[6]);
	// OP10
	assign wOP10			= ( IR_I[7])&(~IR_I[6]);
	// OP11
	assign wOP11			= ( IR_I[7])&( IR_I[6]);
	// OP00_INC: 	00DDD000
	assign wOP00_INC		= (~IR_I[2])&(~IR_I[1])&(~IR_I[0]);
	// OP00_DCR: 	00DDD001
	assign wOP00_DCR		= (~IR_I[2])&(~IR_I[1])&( IR_I[0]);
	// OP00_ROT:	000XX010
	assign wOP00_ROT		= (~IR_I[2])&( IR_I[1])&(~IR_I[0]);
	// OP00_RETC:	00XXX011
	assign wOP00_RETC		= (~IR_I[2])&( IR_I[1])&( IR_I[0]);
	// OP00_ALU_I:	00PPP100
	assign wOP00_ALU		= ( IR_I[2])&(~IR_I[1])&(~IR_I[0]);
	// OP00_RST:	00AAA101
	assign wOP00_RST		= ( IR_I[2])&(~IR_I[1])&( IR_I[0]);
	// OP00_LOAD:	00XXX110
	assign wOP00_LOAD		= ( IR_I[2])&( IR_I[1])&(~IR_I[0]);
	// OP00_RET:	00XXX111
	assign wOP00_RET		= ( IR_I[2])&( IR_I[1])&( IR_I[0]);
	
	// NOP:			0000000x
	assign D_NOP_O			= (wOP00) & (~IR_I[5])&(~IR_I[4])&(~IR_I[3])&(~IR_I[2])&(~IR_I[1]);
	// HLT:			11111111
	assign D_HLT_O			= &IR_I;
	// LOAD: 		11xxxxxx/00xxx110
	assign D_LOAD_O 		= (wOP11) | (wOP00 & wOP00_LOAD);
	// ALU: 		10xxxxxx/00xxx100
	assign D_ALU_O  		= (wOP10) | (wOP00 & wOP00_ALU);
	// ROT:			000XX010
	assign D_ROT_O			= (wOP00) & (wOP00_ROT);
	// INC:			00DDD000
	assign D_INC_O			= (wOP00) & (wOP00_INC);
	// DCR:			00DDD001
	assign D_DCR_O			= (wOP00) & (wOP00_DCR);
	// JUMP: 		01xxxx00
	assign D_JUMP_O			= (wOP01) & (~IR_I[1])&(~IR_I[0]);
	// CALL: 		01xxxx10
	assign D_CALL_O			= (wOP01) & ( IR_I[1])&(~IR_I[0]);
	// RET: 		00xxxx11
	assign D_RET_O			= (wOP00) & ( IR_I[1])&( IR_I[0]);
	// RST: 		00xxx101
	assign D_RST_O			= (wOP00) & (wOP00_RST);
	// INP: 		0100xxx1
	assign D_INP_O			= (wOP01) & (~IR_I[5])&(~IR_I[4])&( IR_I[0]);
	// OUT:			01RRxxx1
	assign D_OUT_O			= (wOP01) & ( IR_I[5] |  IR_I[4])&( IR_I[0]);
	// SRC_R
	assign D_SRC_R_O		= ~(&D_SRC_R_NDX_O);
	// SRC_M
	assign D_SRC_M_O		= &D_SRC_R_NDX_O;
	// SRC_I:		00xxx110/00xxx100
	assign D_SRC_I_O		= (wOP00) & (wOP00_LOAD|wOP00_ALU);
	// DST_R
	assign D_DST_R_O		= ~(&D_DST_R_NDX_O);
	// DST_M
	assign D_DST_M_O		= &D_DST_R_NDX_O;

	// **********
	// MAIN CODE
	// **********
	
endmodule
