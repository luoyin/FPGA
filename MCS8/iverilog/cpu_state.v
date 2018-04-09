// **********
// COPYRIGHT(c) 2018, LUOYIN
// All rights reserved
// 
// IP LIB INDEX	:
// IP Name		: MCS8
// File Name	: cpu_state.v
// Module Name	: cpu_state
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
// 2018/04/09 	State Transition Test
//					Passed: LRR
// **********

// **********
// DEFINE MODEL PORT
// **********
//
module cpu_state(
	CLK1_I, CLK2_I, SYNC_I,
	nRST_I,
	READY_I, INT_I,
	COND_I,
	D_NOP_I, D_HLT_I,
	D_INC_I, D_DCR_I, D_ROT_I, D_RETC_I, D_ALUI_I, D_RST_I, D_LRI_I, D_LMI_I, D_RET_I,
	D_JMPC_I, D_CALC_I, D_JMP_I, D_CAL_I, D_INP_I, D_OUT_I,
	D_ALUR_I, D_ALUM_I,
	D_LRR_I, D_LRM_I, D_LMR_I,
	STATE_O, CYCLE_O
);

	// **********
	// DEFINE PARAMETER
	// **********

	// **********
	// DEFINE INPUT
	// **********
	input wire CLK1_I, CLK2_I, SYNC_I;
	input wire nRST_I;
	input wire READY_I, INT_I;
	input wire COND_I;
	input wire D_NOP_I, D_HLT_I;
	input wire D_INC_I, D_DCR_I, D_ROT_I, D_RETC_I, D_ALUI_I, D_RST_I, D_LRI_I, D_LMI_I, D_RET_I;
	input wire D_JMPC_I, D_CALC_I, D_JMP_I, D_CAL_I, D_INP_I, D_OUT_I;
	input wire D_ALUR_I, D_ALUM_I;
	input wire D_LRR_I, D_LRM_I, D_LMR_I;

	// **********
	// DEFINE OUTPUT
	// **********
	output wire [2:0] STATE_O;
	output wire [1:0] CYCLE_O;

	// **********
	// ATRRIBUTE
	// **********
	localparam S_STOP		= 5'b00011;
	localparam S_T1I		= 5'b00110;
	localparam S_C1_T1		= 5'b00010;
	localparam S_C2_T1		= 5'b01010;
	localparam S_C3_T1		= 5'b10010;
	localparam S_C1_T2		= 5'b00100;
	localparam S_C2_T2		= 5'b01100;
	localparam S_C3_T2		= 5'b10100;
	localparam S_C1_T3		= 5'b00001;
	localparam S_C2_T3		= 5'b01001;
	localparam S_C3_T3		= 5'b10001;
	localparam S_C1_T4		= 5'b00111;
	localparam S_C2_T4		= 5'b01111;
	localparam S_C3_T4		= 5'b10111;
	localparam S_C1_T5		= 5'b00101;
	localparam S_C2_T5		= 5'b01101;
	localparam S_C3_T5		= 5'b10101;
	localparam S_C1_WAIT	= 5'b00000;
	localparam S_C2_WAIT	= 5'b01000;
	localparam S_C3_WAIT	= 5'b10000;
	localparam S_INIT		= 5'b11111;
	
	reg [4:0] rState;
	
	// **********
	// INSTANCE MODULE
	// **********
	assign STATE_O = rState[2:0];
	assign CYCLE_O = rState[4:3];

	// **********
	// MAIN CODE
	// **********
	// State Machine
	always @(posedge CLK1_I) begin
		if(~nRST_I)
			rState<=S_INIT;
		else if(SYNC_I) begin
			case(rState)
				S_INIT: 	begin
									rState<=S_C1_T1;
					end
				S_C1_T1:	begin
									rState<=S_C1_T2;
					end
				S_C1_T2: 	begin
					if(READY_I)		rState<=S_C1_T3;
					else			rState<=S_C1_WAIT;
					end
				S_C1_T3: 	begin
					// HLT
					if(D_HLT_I)		
									rState<=S_STOP;
					// NOP
					else if(D_NOP_I)
									rState<=S_C1_T1;
					// INr/DCr/ROT/RST		-> C1_T4
					else if( D_INC_I | D_DCR_I | D_ROT_I | D_RST_I )
									rState<=S_C1_T4;
					// L?r/ALUr				-> C1_T4
					else if( D_LRR_I | D_LMR_I | D_ALUR_I )
									rState<=S_C1_T4;
					// RET (true)
					else if( D_RET_I | (D_RETC_I & COND_I) )
									rState<=S_C1_T4;
					// RET (false)
					else if( D_RETC_I & (~COND_I) )
									rState<=S_C1_T1;
					else
									rState<=S_C2_T1;
					end
				S_C1_T4:	begin
					// LMr
					if( D_LMR_I )
									rState<=S_C2_T1;
					else
									rState<=S_C1_T5;
					end
				S_C1_T5:	begin
									rState<=INT_Test(INT_I);
					end
				S_C1_WAIT: 	begin
					if(READY_I)		rState<=S_C1_T3;
					else 			rState<=S_C1_WAIT;
					end
				S_C2_T1:	begin
									rState<=S_C2_T2;
					end
				S_C2_T2:	begin
									rState<=WAIT_Test(READY_I, S_C2_T3, S_C2_WAIT);
					end
				S_C2_T3:	begin
					// JUMP/CALL			-> C3_T1
					if( D_JMP_I | D_JMPC_I | D_CAL_I | D_CALC_I )
									rState<=S_C3_T1;
					// LMI					-> C3_T1
					else if( D_LMI_I )
									rState<=S_C3_T1;
					// OUT
					else if( D_OUT_I | D_LMR_I )
									rState<=INT_Test(INT_I);
					else
									rState<=S_C2_T4;
					end
				S_C2_T4:	begin
									rState<=S_C2_T5;
					end
				S_C2_T5:	begin
									rState<=INT_Test(INT_I);
					end
				S_C2_WAIT:	begin
									rState<=WAIT_Test(READY_I, S_C2_T3, S_C2_WAIT);
					end
				S_C3_T1:	begin
									rState<=S_C3_T2;
					end
				S_C3_T2:	begin
									rState<=WAIT_Test(READY_I, S_C3_T3, S_C3_WAIT);
					end
				S_C3_T3:	begin
					// JUMP/CALL (true)
					if( D_JMP_I | D_CAL_I | ( D_JMPC_I & COND_I) | ( D_CALC_I & COND_I) )
									rState<=S_C3_T4;
					else
									rState<=INT_Test(INT_I);
					end
				S_C3_T4:	begin
									rState<=S_C3_T5;
					end
				S_C3_T5:	begin
									rState<=INT_Test(INT_I);
					end
				S_C3_WAIT:	begin
									rState<=WAIT_Test(READY_I, S_C3_T3, S_C3_WAIT);
					end
				S_T1I:		begin
									rState<=S_C1_T2;
					end
				S_STOP: 	begin
					if(INT_I)		rState<=S_T1I;
					else			rState<=S_STOP;
					end
				default: rState<=S_INIT;
			endcase
		end
	end
	
	function [4:0] INT_Test;
		input INT;
		begin
			if(INT)					INT_Test=S_T1I;
			else					INT_Test=S_C1_T1;
		end
	endfunction
	
	function [4:0] WAIT_Test;
		input READY;
		input [4:0] StateNext, StateWait;
		if(READY)					WAIT_Test=StateNext;
		else						WAIT_Test=StateWait;
	endfunction
	
endmodule
