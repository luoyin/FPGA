// **********
// COPYRIGHT(c) 2018, LUOYIN
// All rights reserved
// 
// IP LIB INDEX	:
// IP Name		: clock
// File Name	: clock.v
// Module Name	: clock
// Full Name	: clock generator for clk1 and clk2
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
module clock(CLK_I, CLK1_O, CLK2_O);

	// **********
	// DEFINE PARAMETER
	// **********

	// **********
	// DEFINE INPUT
	// **********
	input wire CLK_I;

	// **********
	// DEFINE OUTPUT
	// **********
	output wire CLK1_O;
	output wire CLK2_O;

	// **********
	// ATRRIBUTE
	// **********
	reg [1:0] rCount;

	// **********
	// INSTANCE MODULE
	// **********
	assign CLK1_O=(~rCount[1])&( rCount[0]);
	assign CLK2_O=( rCount[1])&( rCount[0]);

	// **********
	// MAIN CODE
	// **********
	initial begin
		rCount<=2'b00;
	end

	always @(posedge CLK_I) begin
		rCount<=rCount+1;
	end
	
endmodule
