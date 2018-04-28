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
// Description
// F1->F2->F3->D->E->M->W
// **********

// **********
// DEFINE MODEL PORT
// **********
module cpu(
	// Clock
	CLK_I, nRST_I,
	// ICode
	I_DAT_I, I_ADDR_O,
	// DCode
	D_DAT_I, D_DAT_O, D_ADDR_O,
	// IO
	IO_DAT_I, IO_DAT_O, IO_ADDR_O
);

	// **********
	// DEFINE PARAMETER
	// **********

	// **********
	// DEFINE INPUT
	// **********
	// Clock
	input wire CLK_I, nRST_I;
	// ICode
	input wire [7:0] I_DAT_I;
	// DCode
	input wire [7:0] D_DAT_I;
	// IO
	input wire [7:0] IO_DAT_I;

	// **********
	// DEFINE OUTPUT
	// **********
	// ICode
	output wire [13:0] I_ADDR_O;
	// DCode
	output wire [7:0]  D_DAT_O;
	output wire [13:0] D_ADDR_O;
	// IO
	output wire [7:0]  IO_DAT_O;
	output wire [4:0]  IO_ADDR_O;
	
	// **********
	// ATRRIBUTE
	// **********
	// Stage F1
	reg [13:0]	rF1_valPC;
	reg  [7:0] 	rF1_IR;
	reg 		rF1_IR_valid;
	// Stage F2
	reg [13:0]	rF2_valPC;
	reg  [7:0] 	rF2_IR;
	reg 		rF2_IR_valid;
	// Stage F3
	reg [13:0]	rF3_valPC;
	reg  [7:0] 	rF3_IR;
	reg 		rF3_IR_valid;
	// State D
	reg        	rD_valid;
	reg [13:0]	rD_valPC;
	reg  [7:0] 	rD_icode;
	reg  [2:0] 	rD_ifun;
	reg  [2:0] 	rD_src;
	reg  [2:0] 	rD_dst;
	reg [13:0] 	rD_valP;
	reg  [7:0] 	rD_valC;				// imm
	reg  [1:0] 	rD_count;
	wire		wD_INS_NOP;
	wire		wD_INS_INC;
	wire		wD_INS_DCR;
	wire		wD_INS_ALUR;
	wire		wD_INS_ALUI;
	wire		wD_INS_ROT;
	wire 		wD_INS_LRR;
	wire		wD_INS_LRM;
	wire		wD_INS_LMR;
	wire		wD_INS_LRI;
	wire		wD_INS_LMI;
	wire [7:0]	wD_forward_S;
	wire [7:0]	wD_forward_A;
	wire [7:0]	wD_forward_H;
	wire [7:0]	wD_forward_L;
	wire		wD_RegSrc_CS_S;
	wire		wD_RegSrc_CS_A;
	wire		wD_Bubble_S;
	wire		wD_Bubble_A;
	wire		wD_dstR_CS;				// ->reg
	wire		wD_dstR_CS_C;			// imm->reg
	wire		wD_dstR_CS_S;			// reg->reg
	wire		wD_dstR_CS_E;			// alu->reg
	wire		wD_dstR_CS_M;			// M->reg
	wire		wD_dstM_CS;				// ->M
	wire		wD_dstM_CS_C;			// imm->M
	wire		wD_dstM_CS_S;			// reg->M
	wire [3:0]	wD_ALU_OPR;
	// ***** Stage E *****
	reg 		rE_valid;
	reg [13:0]	rE_valPC;
	reg  [7:0] 	rE_icode;
	reg  [2:0] 	rE_ifun;
	reg  [3:0]	rE_ALU_OPR;
	reg  [2:0] 	rE_src;
	reg  [2:0] 	rE_dst;
	reg  [4:0] 	rE_addrIO;
	// src
	reg [13:0]	rE_valP;
	reg  [7:0] 	rE_valC;				// imm
	reg  [7:0]	rE_valS;				// reg, input B of ALU
	reg  [7:0]	rE_valA;				// input A of ALU
	reg  [7:0]	rE_valH;
	reg  [7:0]	rE_valL;
	// control
	reg			rE_dstR_CS;				// ->reg
	reg			rE_dstR_CS_C;			// imm->reg
	reg			rE_dstR_CS_S;			// reg->reg
	reg			rE_dstR_CS_E;			// alu->reg
	reg			rE_dstR_CS_M;			// M->reg
	reg			rE_dstM_CS;				// ->M
	reg			rE_dstM_CS_C;			// imm->M
	reg			rE_dstM_CS_S;			// reg->M
	// ALU
	wire [7:0]	wE_ALU_E;
	wire		wE_ALU_OUT_CF;
	wire		wE_ALU_OUT_ZF;
	wire		wE_ALU_OUT_SF;
	wire		wE_ALU_OUT_PF;
	// ***** Stage M *****
	reg 		rM_valid;
	reg [13:0]	rM_valPC;
	reg  [7:0] 	rM_icode;
	reg  [2:0] 	rM_dst;
	reg [13:0] 	rM_valP;
	reg  [7:0] 	rM_valC;				// imm
	reg  [7:0] 	rM_valS;				// reg
	reg  [7:0] 	rM_valE;				// alu
	reg  [7:0]	rM_valH;
	reg  [7:0]	rM_valL;
	// control
	reg			rM_dstR_CS;
	reg			rM_dstR_CS_C;			// imm->reg
	reg			rM_dstR_CS_S;			// reg->reg
	reg			rM_dstR_CS_E;			// alu->reg
	reg			rM_dstR_CS_M;			// M->reg
	reg			rM_dstM_CS;				// ->M
	reg			rM_dstM_CS_C;			// imm->M
	reg			rM_dstM_CS_S;			// reg->M
	reg  [4:0] 	rM_addrIO;
	// ***** Stage W *****
	reg 		rW_valid;
	reg [13:0]	rW_valPC;
	reg  [7:0] 	rW_icode;
	reg  [2:0] 	rW_dst;
	reg [13:0] 	rW_valP;
	reg  [7:0] 	rW_valC;				// imm
	reg  [7:0] 	rW_valS;				// reg
	reg  [7:0] 	rW_valE;				// alu
	reg  [7:0] 	rW_valM;				// mem
	reg			rW_dstR_CS;				// ->reg
	reg			rW_dstR_CS_C;			// imm->reg
	reg			rW_dstR_CS_S;			// reg->reg
	reg			rW_dstR_CS_E;			// alu->reg
	reg			rW_dstR_CS_M;			// mem->reg
	wire [7:0]	wW_dstVal;
	// Stack
	reg [13:0] rStack[7:0];
	reg [2:0] rStack_ndx;
	// RegBank
	reg [7:0] rRegBank[7:0];
	reg [7:0] rTest;
	// Status Register
	reg [3:0] rStatus;			// P,S,Z,C
	
	wire wDoubleByte;
	wire wTripleByte;
	
	wire wINS_NOP;
	wire wCOND_JMP;
	wire wCOND_CAL;
	wire wCOND_RET;
	
	// **********
	// INSTANCE MODULE
	// **********
	assign I_ADDR_O = rStack[rStack_ndx];
	assign wDoubleByte = (~rF3_IR[7])&(~rF3_IR[6])&( rF3_IR[2])&(~rF3_IR[0]);
	assign wTripleByte = (~rF3_IR[7])&( rF3_IR[6])&(~rF3_IR[0]);
	assign wSingle = (~wDoubleByte) & (~wTripleByte);
	assign wINS_NOP = (~rF3_IR[7])&(~rF3_IR[6])&(~rF3_IR[5])&(~rF3_IR[4])&(~rF3_IR[3])&(~rF3_IR[2])&(~rF3_IR[1]);
	
	// **** Stage D ****
	// NOP
	assign wD_INS_NOP 	= ~(|rD_icode[7:1]); 
	// INC: 00DDD000
	assign wD_INS_INC 	= (~rD_icode[7]) & (~rD_icode[6]) & (~(|rD_icode[5:3])) & (~(&rD_icode[5:3])) & (~rD_icode[2]) & (~rD_icode[1]) & (~rD_icode[0]);
	// DCR: 00DDD001
	assign wD_INS_DCR 	= (~rD_icode[7]) & (~rD_icode[6]) & (~(|rD_icode[5:3])) & (~(&rD_icode[5:3])) & (~rD_icode[2]) & (~rD_icode[1]) & ( rD_icode[0]);
	// ALUR: 10xxxSSS
	assign wD_INS_ALUR 	= ( rD_icode[7]) & (~rD_icode[6]) & (~(&rD_icode[2:0]));
	// ALUI: 00xxx100
	assign wD_INS_ALUI 	= (~rD_icode[7]) & (~rD_icode[6]) & (~rD_icode[2]) & (~rD_icode[1]) & (~rD_icode[0]);
	// LRR: 11DDDSSS
	assign wD_INS_LRR 	= ( rD_icode[7]) & ( rD_icode[6]) & (~(&rD_icode[5:3])) & (~(&rD_icode[2:0]));
	// LRM: 11DDD111
	assign wD_INS_LRM	= ( rD_icode[7]) & ( rD_icode[6]) & (~(&rD_icode[5:3])) & (&rD_icode[2:0]);
	// LMR: 11111SSS
	assign wD_INS_LMR 	= ( rD_icode[7]) & ( rD_icode[6]) & (&rD_icode[5:3])    & (~(&rD_icode[2:0]));
	// LRI: 00DDD110
	assign wD_INS_LRI	= (~rD_icode[7]) & (~rD_icode[6]) & (~(&rD_icode[5:3])) & ( rD_icode[2]) & ( rD_icode[1]) & (~rD_icode[0]);
	// LMI: 00111110
	assign wD_INS_LMI	= (~rD_icode[7]) & (~rD_icode[6]) & (&rD_icode[5:3])    & ( rD_icode[2]) & ( rD_icode[1]) & (~rD_icode[0]);
	// ROT: 00xxx010
	assign wD_INS_ROT 	= (~rD_icode[7]) & (~rD_icode[6]) & (~rD_icode[2]) & ( rD_icode[1]) & (~rD_icode[0]);
	
	
	assign wD_RegSrc_CS_A = wD_INS_ALUR | wD_INS_ALUI;
	assign wD_RegSrc_CS_S = wD_INS_ALUR | wD_INS_LRR | wD_INS_LMR;
	assign wD_dstR_CS_C	= wD_INS_LRI;
	assign wD_dstR_CS_S	= wD_INS_LRR;
	assign wD_dstR_CS_E	= wD_INS_ALUR | wD_INS_ALUI | wD_INS_ROT;
	assign wD_dstR_CS_M	= wD_INS_LRM;
	assign wD_dstR_CS  	= wD_dstR_CS_C | wD_dstR_CS_S | wD_dstR_CS_E | wD_dstR_CS_M;
	assign wD_dstM_CS_C	= wD_INS_LMI;
	assign wD_dstM_CS_S	= wD_INS_LMR;
	assign wD_dstM_CS	= wD_dstM_CS_C | wD_dstR_CS_S;
	
	// ALU_OPR: {ALU, ROT, INC, DCR}
	assign wD_ALU_OPR	= { wD_INS_ALUR|wD_INS_ALUI, wD_INS_ROT, wD_INS_INC, wD_INS_DCR };
	
	// **** Stage E ****
	cpu_forward uForward_S(
		.REG_BANK_I(rRegBank[rD_src]), .REG_SRC_I(rD_src), .REG_SRC_CS_I(wD_RegSrc_CS_S),
		.E_VAL_C_I(rE_valC), .E_VAL_S_I(rE_valS),
		.M_VAL_C_I(rM_valC), .M_VAL_S_I(rM_valS), .M_VAL_E_I(rM_valE),
		.W_VAL_C_I(rW_valC), .W_VAL_S_I(rW_valS), .W_VAL_E_I(rW_valE), .W_VAL_M_I(rW_valM),
		.E_DSTR_I(rE_dst), .E_VALID_I(rE_valid), .E_DSTR_CS_I(rE_dstR_CS), .E_DSTR_CS_C_I(rE_dstR_CS_C), .E_DSTR_CS_S_I(rE_dstR_CS_S), .E_DSTR_CS_E_I(rE_dstR_CS_E), .E_DSTR_CS_M_I(rE_dstR_CS_M),
		.M_DSTR_I(rM_dst), .M_VALID_I(rM_valid), .M_DSTR_CS_I(rM_dstR_CS), .M_DSTR_CS_C_I(rM_dstR_CS_C), .M_DSTR_CS_S_I(rM_dstR_CS_S), .M_DSTR_CS_E_I(rM_dstR_CS_E), .M_DSTR_CS_M_I(rM_dstR_CS_M),
		.W_DSTR_I(rW_dst), .W_VALID_I(rW_valid), .W_DSTR_CS_I(rW_dstR_CS), .W_DSTR_CS_C_I(rW_dstR_CS_C), .W_DSTR_CS_S_I(rW_dstR_CS_S), .W_DSTR_CS_E_I(rW_dstR_CS_E), .W_DSTR_CS_M_I(rW_dstR_CS_M),
		.REG_BANK_O(wD_forward_S)
	);
	cpu_forward uForward_A(
		.REG_BANK_I(rRegBank[3'b000]), .REG_SRC_I(3'b000), .REG_SRC_CS_I(wD_RegSrc_CS_A),
		.E_VAL_C_I(rE_valC), .E_VAL_S_I(rE_valS),
		.M_VAL_C_I(rM_valC), .M_VAL_S_I(rM_valS), .M_VAL_E_I(rM_valE),
		.W_VAL_C_I(rW_valC), .W_VAL_S_I(rW_valS), .W_VAL_E_I(rW_valE), .W_VAL_M_I(rW_valM),
		.E_DSTR_I(rE_dst), .E_VALID_I(rE_valid), .E_DSTR_CS_I(rE_dstR_CS), .E_DSTR_CS_C_I(rE_dstR_CS_C), .E_DSTR_CS_S_I(rE_dstR_CS_S), .E_DSTR_CS_E_I(rE_dstR_CS_E), .E_DSTR_CS_M_I(rE_dstR_CS_M),
		.M_DSTR_I(rM_dst), .M_VALID_I(rM_valid), .M_DSTR_CS_I(rM_dstR_CS), .M_DSTR_CS_C_I(rM_dstR_CS_C), .M_DSTR_CS_S_I(rM_dstR_CS_S), .M_DSTR_CS_E_I(rM_dstR_CS_E), .M_DSTR_CS_M_I(rM_dstR_CS_M),
		.W_DSTR_I(rW_dst), .W_VALID_I(rW_valid), .W_DSTR_CS_I(rW_dstR_CS), .W_DSTR_CS_C_I(rW_dstR_CS_C), .W_DSTR_CS_S_I(rW_dstR_CS_S), .W_DSTR_CS_E_I(rW_dstR_CS_E), .W_DSTR_CS_M_I(rW_dstR_CS_M),
		.REG_BANK_O(wD_forward_A)
	);
	cpu_forward uForward_H(
		.REG_BANK_I(rRegBank[3'b101]), .REG_SRC_I(3'b101), .REG_SRC_CS_I(1'b1),
		.E_VAL_C_I(rE_valC), .E_VAL_S_I(rE_valS),
		.M_VAL_C_I(rM_valC), .M_VAL_S_I(rM_valS), .M_VAL_E_I(rM_valE),
		.W_VAL_C_I(rW_valC), .W_VAL_S_I(rW_valS), .W_VAL_E_I(rW_valE), .W_VAL_M_I(rW_valM),
		.E_DSTR_I(rE_dst), .E_VALID_I(rE_valid), .E_DSTR_CS_I(rE_dstR_CS), .E_DSTR_CS_C_I(rE_dstR_CS_C), .E_DSTR_CS_S_I(rE_dstR_CS_S), .E_DSTR_CS_E_I(rE_dstR_CS_E), .E_DSTR_CS_M_I(rE_dstR_CS_M),
		.M_DSTR_I(rM_dst), .M_VALID_I(rM_valid), .M_DSTR_CS_I(rM_dstR_CS), .M_DSTR_CS_C_I(rM_dstR_CS_C), .M_DSTR_CS_S_I(rM_dstR_CS_S), .M_DSTR_CS_E_I(rM_dstR_CS_E), .M_DSTR_CS_M_I(rM_dstR_CS_M),
		.W_DSTR_I(rW_dst), .W_VALID_I(rW_valid), .W_DSTR_CS_I(rW_dstR_CS), .W_DSTR_CS_C_I(rW_dstR_CS_C), .W_DSTR_CS_S_I(rW_dstR_CS_S), .W_DSTR_CS_E_I(rW_dstR_CS_E), .W_DSTR_CS_M_I(rW_dstR_CS_M),
		.REG_BANK_O(wD_forward_H)
	);
	cpu_forward uForward_L(
		.REG_BANK_I(rRegBank[3'b110]), .REG_SRC_I(3'b110), .REG_SRC_CS_I(1'b1),
		.E_VAL_C_I(rE_valC), .E_VAL_S_I(rE_valS),
		.M_VAL_C_I(rM_valC), .M_VAL_S_I(rM_valS), .M_VAL_E_I(rM_valE),
		.W_VAL_C_I(rW_valC), .W_VAL_S_I(rW_valS), .W_VAL_E_I(rW_valE), .W_VAL_M_I(rW_valM),
		.E_DSTR_I(rE_dst), .E_VALID_I(rE_valid), .E_DSTR_CS_I(rE_dstR_CS), .E_DSTR_CS_C_I(rE_dstR_CS_C), .E_DSTR_CS_S_I(rE_dstR_CS_S), .E_DSTR_CS_E_I(rE_dstR_CS_E), .E_DSTR_CS_M_I(rE_dstR_CS_M),
		.M_DSTR_I(rM_dst), .M_VALID_I(rM_valid), .M_DSTR_CS_I(rM_dstR_CS), .M_DSTR_CS_C_I(rM_dstR_CS_C), .M_DSTR_CS_S_I(rM_dstR_CS_S), .M_DSTR_CS_E_I(rM_dstR_CS_E), .M_DSTR_CS_M_I(rM_dstR_CS_M),
		.W_DSTR_I(rW_dst), .W_VALID_I(rW_valid), .W_DSTR_CS_I(rW_dstR_CS), .W_DSTR_CS_C_I(rW_dstR_CS_C), .W_DSTR_CS_S_I(rW_dstR_CS_S), .W_DSTR_CS_E_I(rW_dstR_CS_E), .W_DSTR_CS_M_I(rW_dstR_CS_M),
		.REG_BANK_O(wD_forward_L)
	);
	cpu_bubble_data uBubbleData_S(
		.REG_SRC_I(rD_src), .REG_SRC_CS_I(wD_RegSrc_CS_S),
		.M_DSTR_I(rM_dst), .M_VALID_I(rM_valid), .M_DSTR_CS_I(rM_dstR_CS), .M_DSTR_CS_C_I(rM_dstR_CS_C), .M_DSTR_CS_S_I(rM_dstR_CS_S), .M_DSTR_CS_E_I(rM_dstR_CS_E), .M_DSTR_CS_M_I(rM_dstR_CS_M),
		.W_DSTR_I(rW_dst), .W_VALID_I(rW_valid), .W_DSTR_CS_I(rW_dstR_CS), .W_DSTR_CS_C_I(rW_dstR_CS_C), .W_DSTR_CS_S_I(rW_dstR_CS_C), .W_DSTR_CS_E_I(rW_dstR_CS_E), .W_DSTR_CS_M_I(rW_dstR_CS_M),
		.BUBBLE_DATA_O(wD_Bubble_S)
	);
	cpu_bubble_data uBubbleData_A(
		.REG_SRC_I(3'b000), .REG_SRC_CS_I(wD_RegSrc_CS_A),
		.M_DSTR_I(rM_dst), .M_VALID_I(rM_valid), .M_DSTR_CS_I(rM_dstR_CS), .M_DSTR_CS_C_I(rM_dstR_CS_C), .M_DSTR_CS_S_I(rM_dstR_CS_S), .M_DSTR_CS_E_I(rM_dstR_CS_E), .M_DSTR_CS_M_I(rM_dstR_CS_M),
		.W_DSTR_I(rW_dst), .W_VALID_I(rW_valid), .W_DSTR_CS_I(rW_dstR_CS), .W_DSTR_CS_C_I(rW_dstR_CS_C), .W_DSTR_CS_S_I(rW_dstR_CS_C), .W_DSTR_CS_E_I(rW_dstR_CS_E), .W_DSTR_CS_M_I(rW_dstR_CS_M),
		.BUBBLE_DATA_O(wD_Bubble_A)
	);
	cpu_alu uALU(
		.OPR_SELECT(rE_ALU_OPR), .FUNC_I(rE_ifun),
		.ALU_A_I(rE_valA), .ALU_B_I(rE_valS), .ALU_CF_I(rStatus[0]),
		.ALU_E_O(wE_ALU_E), .ALU_CF_O(wE_ALU_OUT_CF), .ALU_ZF_O(wE_ALU_OUT_ZF), .ALU_SF_O(wE_ALU_OUT_SF), .ALU_PF_O(wE_ALU_OUT_PF)
	);
	cpu_cond_forward uCondForward(
		.D_OPCODE_I(rD_icode), 
		.E_OPCODE_I(rE_icode), .E_IFUN_I(rE_ifun),
		.E_ALU_STATUS_I({wE_ALU_OUT_PF, wE_ALU_OUT_SF, wE_ALU_OUT_SF, wE_ALU_OUT_CF}), .STATUS_I(rStatus),
		.COND_JMP_O(wCOND_JMP), .COND_CAL_O(wCOND_CAL), .COND_RET_O(wCOND_RET)
	);
	
	// LMI
	assign wE_dstM_CS_C = (~rE_icode[7])&(~rE_icode[6])&(&rE_icode[5:3])&( rE_icode[2])&( rE_icode[1])&(~rE_icode[0]);		// LMI
	// LMr
	assign wE_dstM_CS_S = ( rE_icode[7])&( rE_icode[6])&(&rE_icode[5:3])&(~(&rE_icode[2:0]));								// LMr
	// dst control
	assign wE_dstM_CS = wE_dstM_CS_C | wE_dstM_CS_S;
	
	// **** Stage W ****
	// src select
	
	// dstVal
	assign wW_dstVal = ( {8{rW_dstR_CS_C}} & rW_valC ) |
					   ( {8{rW_dstR_CS_S}} & rW_valS ) |
					   ( {8{rW_dstR_CS_M}} & rW_valM ) |
					   ( {8{rW_dstR_CS_E}} & rW_valE );
	
	// **********
	// MAIN CODE
	// **********
	// Stack Control
	always @(posedge CLK_I) begin
		if(~nRST_I) begin
			rStack[0] 	<= 14'b0;
			rStack[1] 	<= 14'b0;
			rStack[2] 	<= 14'b0;
			rStack[3] 	<= 14'b0;
			rStack[4] 	<= 14'b0;
			rStack[5] 	<= 14'b0;
			rStack[6] 	<= 14'b0;
			rStack[7] 	<= 14'b0;
			rStack_ndx 	<= 3'b0;
		end
		else begin
			if(wCOND_JMP) begin
				rStack[rStack_ndx] 		<= rD_valP;
			end
			else if(wCOND_CAL) begin
				rStack[rStack_ndx] 		<= rD_valPC + 2;
				rStack[rStack_ndx+1] 	<= rD_valP;
				rStack_ndx				<= rStack_ndx + 1;
			end
			else if(wCOND_RET) begin
				rStack_ndx				<= rStack_ndx - 1;
			end
			else begin
				rStack[rStack_ndx] <= rStack[rStack_ndx]+1;
			end
		end
	end
		
	// Fetch 2 (F1->F2)
	always @(posedge CLK_I) begin
		if(~nRST_I) begin
			rF2_valPC		<= 14'b0;
			rF2_IR 			<= 8'b0;
			rF2_IR_valid 	<= 1'b0;
		end
		else begin
			rF2_valPC		<= rF1_valPC;
			rF2_IR 			<= rF1_IR;
			if(wCOND_JMP | wCOND_CAL | wCOND_RET)
				rF2_IR_valid	<= 1'b0;
			else
				rF2_IR_valid 	<= rF1_IR_valid;
		end
	end
		
	// Fetch 3 (F2->F3)
	always @(posedge CLK_I) begin
		if(~nRST_I) begin
			rF3_valPC		<= 14'b0;
			rF3_IR 			<= 8'b0;
			rF3_IR_valid 	<= 8'b0;
		end
		else begin
			rF3_valPC		<= rF2_valPC;
			rF3_IR 			<= rF2_IR;
			if(wCOND_JMP | wCOND_CAL | wCOND_RET)
				rF3_IR_valid	<= 1'b0;
			else
				rF3_IR_valid 	<= rF2_IR_valid;
		end
	end
		
	// Fetch (F3->D)
	always @(posedge CLK_I) begin
		if(~nRST_I) begin
			rD_valid 		<= 1'b0;
			rD_valPC		<= 14'b0;
			rD_icode 		<= 8'b0;
			rD_ifun  		<= 3'b0;
			rD_src   		<= 3'b0;
			rD_dst   		<= 3'b0;
			rD_valP			<= 14'b0;
			rD_valC  		<= 8'b0;
			rD_count 		<= 2'b0;
		end
		else begin
			if((~rD_count[1])&(~rD_count[0])) begin
				if(wCOND_JMP | wCOND_CAL | wCOND_RET) begin
					rD_valPC	<= 14'b0;
					rD_icode 	<= 8'b0;
				end
				else begin
					rD_valPC	<= rF3_valPC;
					rD_icode 	<= rF3_IR;
				end
				
				rD_ifun  	<= rF3_IR[5:3];
				rD_src   	<= rF3_IR[2:0];
				rD_dst   	<= rF3_IR[5:3];
				rD_valC  	<= rF2_IR;
				rD_valP  	<= { rF1_IR[5:0], rF2_IR };
				rD_valid 	<= rF3_IR_valid & (~wINS_NOP);
				if(wDoubleByte)
					rD_count <= 1;
				else if(wTripleByte)
					rD_count <= 2;
				else
					rD_count <= 0;
			end
			else begin
				rD_count 	<= rD_count-1;
				rD_icode	<= 8'b0;
				rD_valid 	<= 1'b0;
			end
		end
	end
	
	// Decode (D->E)
	always @(posedge CLK_I) begin
		if(~nRST_I) begin
			rE_valid 		<= 1'b0;
			rE_valPC		<= 14'b0;
			rE_icode 		<= 8'b0;
			rE_ifun  		<= 3'b0;
			rE_ALU_OPR		<= 4'b0;
			rE_dst	 		<= 3'b0;
			rE_valP  		<= 14'b0;
			rE_valC  		<= 8'b0;
			rE_valH			<= 8'b0;
			rE_valL			<= 8'b0;
			rE_dstR_CS		<= 1'b0;
			rE_dstR_CS_C	<= 1'b0;
			rE_dstR_CS_S	<= 1'b0;
			rE_dstR_CS_E	<= 1'b0;
			rE_dstR_CS_M	<= 1'b0;
			rE_dstM_CS		<= 1'b0;
			rE_dstM_CS_C	<= 1'b0;
			rE_dstM_CS_S	<= 1'b0;
		end
		else begin
			rE_valid <= rD_valid;
			
			if(rD_valid) begin
				rE_icode 		<= rD_icode;
				rE_valPC		<= rD_valPC;
				rE_ifun  		<= rD_ifun;
				rE_ALU_OPR		<= wD_ALU_OPR;
				rE_dst  		<= rD_dst;
				rE_valP  		<= rD_valP;
				
				rE_dstR_CS		<= wD_dstR_CS;
				rE_dstR_CS_C	<= wD_dstR_CS_C;
				rE_dstR_CS_S	<= wD_dstR_CS_S;
				rE_dstR_CS_E	<= wD_dstR_CS_E;
				rE_dstR_CS_M	<= wD_dstR_CS_M;
				rE_dstM_CS		<= wD_dstM_CS;
				rE_dstM_CS_C	<= wD_dstM_CS_C;
				rE_dstM_CS_S	<= wD_dstM_CS_S;
				
				// valC
				rE_valC  <= rD_valC;
				
				// valA
				casex(rD_icode)
					8'b00xxx00x: begin			// INr, DCr
						if(~wD_INS_NOP)
							rE_valA <= wD_forward_S;
						end
					8'b000xx010: begin			// ROT
						rE_valA <= wD_forward_A;
						end
					8'b00xxx100: begin			// ALUI
						rE_valA <= wD_forward_A;
						end
					8'b10xxxxxx: begin			// ALUr
						rE_valA <= wD_forward_A;
						end
					endcase
				
				// valS
				casex(rD_icode)
					8'b00xxx000: begin
						rE_valS <= 8'b00000001;
					end
					8'b00xxx001: begin
						rE_valS <= 8'b11111111;
					end
					8'b00xxx100: begin
						rE_valS <= rD_valC;
					end
					8'b00xxx110: begin
						rE_valS <= rD_valC;
					end
					8'b10xxxxxx: begin
						rE_valS <= wD_forward_S;
					end
					8'b11xxxxxx: begin
						rE_valS <= wD_forward_S;
					end
					default: begin
						rE_valS <= 8'b0;
					end
				endcase
				// valH
				rE_valH <= wD_forward_H;
				// valL
				rE_valL <= wD_forward_L;
				// src select
			end
		end
	end
		
	// Execute (E->M)
	always @(posedge CLK_I) begin
		if(~nRST_I) begin
			rM_valid 		<= 1'b0;
			rM_valPC		<= 14'b0;
			rM_icode 		<= 8'b0;
			// src
			rM_valC			<= 8'b0;
			rM_valS			<= 8'b0;
			rM_valE			<= 8'b0;
			rM_dst			<= 8'b0;
			rStatus			<= 4'b0;
			end
		else begin
			rM_valid		<= rE_valid;
			if(rE_valid) begin
				rM_valPC		<= rE_valPC;
				rM_icode		<= rE_icode;
				rM_valC			<= rE_valC;
				rM_valS			<= rE_valS;
				rM_valH			<= rE_valH;
				rM_valL			<= rE_valL;
				rM_valE			<= wE_ALU_E;
				rM_dst			<= rE_dst;
				// src/dst control
				rM_dstR_CS		<= rE_dstR_CS;
				rM_dstR_CS_C	<= rE_dstR_CS_C;
				rM_dstR_CS_S	<= rE_dstR_CS_S;
				rM_dstR_CS_E	<= rE_dstR_CS_E;
				rM_dstR_CS_M	<= rE_dstR_CS_M;
				rM_dstM_CS		<= rE_dstM_CS;
				rM_dstM_CS_C	<= rE_dstM_CS_C;
				rM_dstM_CS_S	<= rE_dstM_CS_S;
				// ALU
				case(rE_ALU_OPR)
					// ALU
					4'b1000:	rStatus 	<= { wE_ALU_OUT_PF, wE_ALU_OUT_SF, wE_ALU_OUT_ZF, wE_ALU_OUT_CF };
					4'b0100:	rStatus[0]	<= wE_ALU_OUT_CF;
					default:;
				endcase
			end
		end
	end
		
	// Memory (M->W)
	always @(posedge CLK_I) begin
		if(~nRST_I) begin
			rW_valid		<= 1'b0;
			rW_valPC		<= 14'b0;
			rW_icode		<= 8'b0;
			// src
			rW_valC			<= 8'b0;
			rW_valS			<= 8'b0;
			rW_valE			<= 8'b0;
			rW_valM			<= 8'b0;
			rW_dst			<= 8'b0;
			end
		else begin
			rW_valid		<= rM_valid;
			if(rM_valid) begin
				rW_valPC	<= rM_valPC;
				rW_icode	<= rM_icode;
				rW_valC		<= rM_valC;
				rW_valS		<= rM_valS;
				rW_valE		<= rM_valE;
				rW_dst		<= rM_dst;
				// src/dst control
				rW_dstR_CS		<= rM_dstR_CS;
				rW_dstR_CS_C	<= rM_dstR_CS_C;
				rW_dstR_CS_S	<= rM_dstR_CS_S;
				rW_dstR_CS_E	<= rM_dstR_CS_E;
				rW_dstR_CS_M	<= rM_dstR_CS_M;
				end
			end
		end
	
	// WriteBack (ROM->F1)
	always @(posedge CLK_I) begin
		if(~nRST_I) begin
			rRegBank[0] 	<= 8'b0;
			rRegBank[1] 	<= 8'b0;
			rRegBank[2] 	<= 8'b0;
			rRegBank[3] 	<= 8'b0;
			rRegBank[4] 	<= 8'b0;
			rRegBank[5] 	<= 8'b0;
			rRegBank[6] 	<= 8'b0;
			rRegBank[7] 	<= 8'b0;
			rF1_valPC		<= 14'b0;
			rF1_IR 			<= 8'b0;
			rF1_IR_valid 	<=1'b0;
			end
		else begin
			
			if(wCOND_JMP | wCOND_CAL | wCOND_RET) begin
				rF1_IR_valid 	<= 1'b0;
				rF1_IR			<= 8'b0;
			end
			else begin
				rF1_IR_valid 	<= 1'b1;
				rF1_IR 			<= I_DAT_I;
			end
			rF1_valPC		<= I_ADDR_O;
			if(rW_valid) begin
				if(rW_dstR_CS) begin
					rRegBank[rW_dst] <= wW_dstVal;
					rTest <= wW_dstVal;
					end
				end
			end
		end
	
endmodule
