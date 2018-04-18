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
module bench_top();

	// **********
	// DEFINE PARAMETER
	// **********

	// **********
	// DEFINE INPUT
	// **********

	// **********
	// DEFINE OUTPUT
	// **********

	// **********
	// ATRRIBUTE
	// **********
	wire wCLK, wnRST;
	// ICODE
	wire [13:0] wI_ADDR;
	wire [7:0] wI_DAT;

	// **********
	// INSTANCE MODULE
	// **********
	bench_clock uClock(
		.CLK_O(wCLK), .nRST_O(wnRST)
	);
	cpu uCPU(
		.CLK_I(wCLK), .nRST_I(wnRST),
		.I_DAT_I(wI_DAT), .I_ADDR_O(wI_ADDR)
	);
	rom uRom(
		.ADDR_I(wI_ADDR),
		.DAT_O(wI_DAT)
	);

	// **********
	// MAIN CODE
	// **********
	initial begin
		$dumpvars(0, uClock);
		$dumpvars(0, uCPU);
		$dumpvars(0, uRom);
		end
	
endmodule
