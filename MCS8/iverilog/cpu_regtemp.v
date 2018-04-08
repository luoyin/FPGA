// **********
// COPYRIGHT(c) 2018, LUOYIN
// All rights reserved
// 
// IP LIB INDEX	:
// IP Name		: Intel8008
// File Name	: cpu_regtemp.v
// Module Name	: cpu_regtemp
// Full Name	: Temperate Register of Intel8008 (alpha and beta)
// 
// Author		: LUO YIN
// Email		: luoyin1986@gmail.com
// Data			: 2018/04/08
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
module cpu_regtemp(
	CLK1_I, CLK2_I, SYNC_I, nRST_I,
	CS_I, RD_I, WR_I,
	DAT_I, DAT_O, DAT_ALU_O
);

	// **********
	// DEFINE PARAMETER
	// **********

	// **********
	// DEFINE INPUT
	// **********
	input wire CLK1_I, CLK2_I, SYNC_I, nRST_I;
	input wire CS_I, RD_I, WR_I;
	input wire [7:0] DAT_I;

	// **********
	// DEFINE OUTPUT
	// **********
	output wire [7:0] DAT_O;
	output wire [7:0] DAT_ALU_O;

	// **********
	// ATRRIBUTE
	// **********

	// **********
	// INSTANCE MODULE
	// **********

	// **********
	// MAIN CODE
	// **********

endmodule
