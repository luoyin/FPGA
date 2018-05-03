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
	wire				wCLK, wnRST;
	wire	 [7:0]		wQ1;
	wire	 [7:0]		wQ2;
	reg		[13:0]		rAddr;

	// **********
	// INSTANCE MODULE
	// **********
	bench_clock uClock(
		.CLK_O(CLK), .nRST_O(wnRST)
	);
	rom1 uRom1(
		.ADDR_I(rAddr),
		.CLK_I(CLK), .CLK_EN_I(1'b1), .RST_I(~wnRST),
		.Q_O(wQ1)
	);
	rom2 uRom2(
		.ADDR_I(rAddr),
		.CLK_I(CLK), .CLK_EN_I(1'b1), .RST_I(~wnRST),
		.Q_O(wQ2)
	);

	// **********
	// MAIN CODE
	// **********
	always @(posedge CLK) begin
		if(~wnRST)			rAddr <= 14'b0;
		else				rAddr <= rAddr+1;
	end
	
	initial begin
		$dumpvars(0, uClock);
		$dumpvars(0, uRom1);
		$dumpvars(0, uRom2);
	end

endmodule
