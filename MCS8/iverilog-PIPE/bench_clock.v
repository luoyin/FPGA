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
module bench_clock(
	CLK_O,
	nRST_O
);

	// **********
	// DEFINE PARAMETER
	// **********

	// **********
	// DEFINE INPUT
	// **********

	// **********
	// DEFINE OUTPUT
	// **********
	output reg CLK_O;
	output reg nRST_O;
	
	// **********
	// ATRRIBUTE
	// **********

	// **********
	// INSTANCE MODULE
	// **********

	// **********
	// MAIN CODE
	// **********
	initial begin
		CLK_O=1'b0;
		nRST_O=1'b1;
		forever #5 CLK_O=~CLK_O;
		end
		
	initial begin
		#100 nRST_O=1'b0;
		#100 nRST_O=1'b1;
		end
	
	initial begin
		#600 $finish;
		end
	
endmodule
