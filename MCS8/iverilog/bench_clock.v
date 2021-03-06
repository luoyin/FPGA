// **********
// COPYRIGHT(c) 2018, LUOYIN
// All rights reserved
// 
// IP LIB INDEX	: 
// IP Name		: MCS8
// File Name	: bench_clock.v
// Module Name	: bench_clock
// Full Name	: clock generator
// 
// Author		: LUO YIN
// Email		: luoyin1986@gmail.com
// Data			: 2018/04/03
// Version		: 1.0
//
// Abstract		: 
// Called By	: bench_top
// 
// Modification Histroy
// 
// **********
`timescale 1us/100ns

// **********
// DEFINE MODEL PORT
// **********
//
module bench_clock(CLK_O, nRST_O);

	// **********
	// DEFINE PARAMETER
	// **********
	parameter HALF_CYCLE=10;

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
		#200 nRST_O=1'b1;
	end
	
	initial begin
		#2000 $finish;
	end

endmodule

