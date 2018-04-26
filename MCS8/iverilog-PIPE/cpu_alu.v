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
module cpu_alu(
	OPR_SELECT, FUNC_I,
	ALU_A_I, ALU_B_I, ALU_CF_I,
	ALU_E_O, ALU_CF_O, ALU_ZF_O, ALU_SF_O, ALU_PF_O
);

	// **********
	// DEFINE PARAMETER
	// **********

	// **********
	// DEFINE INPUT
	// **********
	input wire [3:0]	OPR_SELECT;			// 1000: ALU  0100: ROT  0010: INC  0001: DCR
	input wire [2:0]	FUNC_I;
	input wire [7:0]	ALU_A_I;
	input wire [7:0]	ALU_B_I;
	input wire			ALU_CF_I;

	// **********
	// DEFINE OUTPUT
	// **********
	output reg [7:0]	ALU_E_O;
	output reg			ALU_CF_O;
	output wire			ALU_ZF_O;
	output wire			ALU_SF_O;
	output wire			ALU_PF_O;

	// **********
	// ATRRIBUTE
	// **********

	// **********
	// INSTANCE MODULE
	// **********
	assign ALU_ZF_O = ~(|ALU_E_O);
	assign ALU_SF_O = ALU_E_O[7];
	assign ALU_PF_O = ~ALU_E_O[0];

	// **********
	// MAIN CODE
	// **********
	always @(ALU_A_I, ALU_B_I, ALU_CF_I, OPR_SELECT, FUNC_I) begin
		case(OPR_SELECT)
			4'b1000:
				case(FUNC_I) 
					3'b000: 	{ALU_CF_O, ALU_E_O} <= ALU_A_I + ALU_B_I;
					3'b001: 	{ALU_CF_O, ALU_E_O} <= ALU_A_I + ALU_B_I + ALU_CF_I;
					3'b010: 	{ALU_CF_O, ALU_E_O} <= 9'b10000000 ^ (ALU_A_I + (~ALU_B_I) + 1'b1);
					3'b011: 	{ALU_CF_O, ALU_E_O} <= 9'b10000000 ^ (ALU_A_I + (~ALU_B_I) + (1'b1^ALU_CF_I) );
					3'b100: 	{ALU_CF_O, ALU_E_O} <= { 1'b0, ALU_A_I & ALU_B_I };
					3'b101: 	{ALU_CF_O, ALU_E_O} <= { 1'b0, ALU_A_I ^ ALU_B_I };
					3'b110: 	{ALU_CF_O, ALU_E_O} <= { 1'b0, ALU_A_I | ALU_B_I };
					3'b111: 	{ALU_CF_O, ALU_E_O} <= (9'b10000000 & (9'b10000000 ^ (ALU_A_I + (~ALU_B_I) + 1'b1) ) ) | ALU_A_I;
					default: 	{ALU_CF_O, ALU_E_O} <= { ALU_CF_I, ALU_A_I };
				endcase
			4'b0100:
				case(FUNC_I)
					3'b000: 	{ALU_CF_O, ALU_E_O} <= { ALU_A_I[7], ALU_A_I[6:0], ALU_A_I[7] };
					3'b001: 	{ALU_CF_O, ALU_E_O} <= { ALU_A_I[0], ALU_A_I[0], ALU_A_I[7:1] };
					3'b010: 	{ALU_CF_O, ALU_E_O} <= { ALU_A_I, ALU_CF_I };
					3'b011: 	{ALU_E_O, ALU_CF_O} <= { ALU_CF_I, ALU_A_I };
					default: 	{ALU_CF_O, ALU_E_O} <= { ALU_CF_I, ALU_A_I };
				endcase
			4'b0010: ALU_E_O <= 8'b00000001 + ALU_B_I;
			4'b0001: ALU_E_O <= 8'b11111111 + ALU_B_I;
			default: {ALU_CF_O, ALU_E_O} <= { ALU_CF_I, ALU_A_I };
		endcase
	end

endmodule
