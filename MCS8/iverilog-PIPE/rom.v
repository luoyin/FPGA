// **********
// COPYRIGHT(c) 2018, LUOYIN
// All rights reserved
// 
// IP LIB INDEX	: 
// IP Name		: BASIC
// File Name	: rom.v
// Module Name	: rom
// Full Name	: ROM
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
module rom(
	ADDR_I,
	DAT_O
);

	// **********
	// DEFINE PARAMETER
	// **********

	// **********
	// DEFINE INPUT
	// **********
	input wire [13:0] ADDR_I;

	// **********
	// DEFINE OUTPUT
	// **********
	output reg [7:0] DAT_O;

	// **********
	// ATRRIBUTE
	// **********
	reg [7:0] mem[0:16383];

	// **********
	// INSTANCE MODULE
	// **********

	// **********
	// MAIN CODE
	// **********
	initial begin
		// $readmemh("rom.dat", mem);
		$readmemb("rom_bin.dat", mem);
		end
	
	always @(ADDR_I) begin
		DAT_O <= mem[ADDR_I];
		end

endmodule
