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
	RD_I, WR_I, CLR_I,
	DAT_I, DAT_O, DAT_RAW_O
);

	// **********
	// DEFINE PARAMETER
	// **********

	// **********
	// DEFINE INPUT
	// **********
	input wire CLK1_I, CLK2_I, SYNC_I, nRST_I;
	input wire RD_I, WR_I, CLR_I;
	input wire [7:0] DAT_I;

	// **********
	// DEFINE OUTPUT
	// **********
	output wire [7:0] DAT_O;
	output wire [7:0] DAT_RAW_O;

	// **********
	// ATRRIBUTE
	// **********
	reg [7:0] rTemp;

	// **********
	// INSTANCE MODULE
	// **********

	// **********
	// MAIN CODE
	// **********
	assign DAT_RAW_O = rTemp;
	assign DAT_O = {8{RD_I}} & rTemp;
	
	always @(posedge CLK2_I) begin
		if( (~nRST_I) | (CLR_I) )
			rTemp <= 8'b0;
		else if(WR_I)
			rTemp <= DAT_I;
		end

endmodule
