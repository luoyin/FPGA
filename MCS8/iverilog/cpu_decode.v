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
	D_LOAD_O,
	D_ALU_O,
	D_JUMP_O,
	D_CALL_O
	D_RET_O,
	D_RST_O,
	D_IO_O,
	D_SRC_R_O,
	D_SRC_M_O,
	D_SRC_I_O,
	D_DST_R_O,
	D_DSt_M_O
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
	output wire D_LOAD_O;
	output wire D_ALU_O;
	output wire D_JUMP_O;
	output wire D_CALL_O;
	output wire D_RET_O;
	output wire D_RST_O;
	output wire D_IO_O;
	output wire D_SRC_R_O;
	output wire D_SRC_M_O;
	output wire D_SRC_I_O;
	output wire D_DST_R_O;
	output wire D_DST_M_O;

	// **********
	// ATRRIBUTE
	// **********

	// **********
	// INSTANCE MODULE
	// **********
	// LOAD: 11xxxxxx/00xxx110
	assign D_LOAD_O 	= ( (( IR_I[7])&( IR_I[6])) | ((~IR_I[7])&(~IR_I[6])&( IR_I[2])&( IR_I[1])&(~IR_I[0])) );
	// ALU: 10xxxxxx/00xxx100
	assign D_ALU_O  	= ( (( IR_I[7])&(~IR_I[6])) | ((~IR_I[7])&(~IR_I[6])&( IR_I[2])&(~IR_I[1])&(~IR_I[0])) );
	// JUMP: 01xxxx00
	assign D_JUMP_O		= (~IR_I[7])&( IR_I[6])&(~IR_I[1])&(~IR_I[0]);
	// CALL: 01xxxx10
	assign D_CALL_O		= (~IR_I[7])&( IR_I[6])&( IR_I[1])&(~IR_I[0]);
	// RET: 00xxxx11
	assign D_RET_O		= (~IR_I[7])&(~IR_I[6])&( IR_I[1])&( IR_I[0]);
	

	// **********
	// MAIN CODE
	// **********
	
endmodule
