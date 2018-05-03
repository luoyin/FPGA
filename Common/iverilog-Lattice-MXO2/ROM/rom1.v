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
module rom1(
	ADDR_I,
	CLK_I, CLK_EN_I, RST_I,
	Q_O
);

	// **********
	// DEFINE PARAMETER
	// **********

	// **********
	// DEFINE INPUT
	// **********
	input wire	[13:0]		ADDR_I;
	input wire				CLK_I;
	input wire				CLK_EN_I;
	input wire				RST_I;

	// **********
	// DEFINE OUTPUT
	// **********
	output wire	 [7:0]		Q_O;

	// **********
	// ATRRIBUTE
	// **********
	reg			 [7:0]		mem [0:16383];
	reg			[13:0]		rAddr;

	// **********
	// INSTANCE MODULE
	// **********
	assign Q_O = mem[rAddr];

	// **********
	// MAIN CODE
	// **********
	initial begin
		$readmemb("rom.bin", mem);
	end
	
	always @(posedge CLK_I) begin
		if(RST_I) begin
			#10		rAddr <= 14'b0;
		end
		else begin
			#10		rAddr <= ADDR_I;
		end
	end

endmodule
