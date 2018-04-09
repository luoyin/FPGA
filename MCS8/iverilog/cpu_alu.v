// **********
// COPYRIGHT(c) 2018, LUOYIN
// All rights reserved
// 
// IP LIB INDEX	:
// IP Name		: Intel8008
// File Name	: cpu_alu.v
// Module Name	: cpu_alu
// Full Name	: 
// 
// Author		: LUO YIN
// Email		: luoyin1986@gmail.com
// Data			: 2018/04/09
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
module cpu_alu(
	X_I, Y_I, C_I, OP_I,
	E_O, C_O, Z_O, S_O, P_O
);

	// **********
	// DEFINE PARAMETER
	// **********

	// **********
	// DEFINE INPUT
	// **********
	input wire [7:0] X_I;
	input wire [7:0] Y_I;
	input wire C_I;
	input wire [2:0] OP_I;

	// **********
	// DEFINE OUTPUT
	// **********
	output wor [7:0] E_O;
	output wire C_O, Z_O, S_O, P_O;

	// **********
	// ATRRIBUTE
	// **********
	// Adder
	wire [7:0] wAdderE;
	wire wAdderCin;
	wire rAdderCout;
	// Control
	wire wOP_AD, wOP_AC, wOP_SU, wOP_SB, wOP_ND, wOP_XR, wOP_OR, wOP_CP;

	// **********
	// INSTANCE MODULE
	// **********

	// **********
	// MAIN CODE
	// **********
	// Control
	assign wOP_AD = (~OP_I[2])&(~OP_I[1])&(~OP_I[0]);
	assign wOP_AC = (~OP_I[2])&(~OP_I[1])&( OP_I[0]);
	assign wOP_SU = (~OP_I[2])&( OP_I[1])&(~OP_I[0]);
	assign wOP_SB = (~OP_I[2])&( OP_I[1])&( OP_I[0]);
	assign wOP_ND = ( OP_I[2])&(~OP_I[1])&(~OP_I[0]);
	assign wOP_XR = ( OP_I[2])&(~OP_I[1])&( OP_I[0]);
	assign wOP_OR = ( OP_I[2])&( OP_I[1])&(~OP_I[0]);
	assign wOP_CP = ( OP_I[2])&( OP_I[1])&( OP_I[0]);
	
	// Adder
	assign wAdderCin = (wOP_AC|wOP_SB) & C_I;
	assign {wAdderCout, wAdderE} = X_I + (Y_I^{8{wOP_SU|wOP_SB|wOP_CP}}) + (wAdderCin^(wOP_SU|wOP_SB|wOP_CP));
	
	// Output
	assign E_O = ({8{wOP_AD|wOP_AC|wOP_SU|wOP_SB}}&wAdderE) |
				 ({8{wOP_ND}} & (X_I&Y_I)) |
				 ({8{wOP_XR}} & (X_I^Y_I)) |
				 ({8{wOP_OR}} & (X_I|Y_I)) |
				 ({8{wOP_CP}} & X_I);
	assign C_O = (wOP_AC & wAdderCout) | (wOP_SB & (~wAdderCout)) | (wOP_CP & (~wAdderCout));
	assign Z_O = ~(|wAdderE);
	assign S_O = E_O[7];
	assign P_O = ~E_O[0];

endmodule
