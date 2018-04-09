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
	CS_I, RD_I,
	ADDR_I,
	DAT_O
);

	// **********
	// DEFINE PARAMETER
	// **********

	// **********
	// DEFINE INPUT
	// **********
	input wire CS_I, RD_I;
	input wire [12:0] ADDR_I;

	// **********
	// DEFINE OUTPUT
	// **********
	output wire [7:0] DAT_O;

	// **********
	// ATRRIBUTE
	// **********
	reg [7:0] mem[0:8191];
	wire [7:0] wCS;

	// **********
	// INSTANCE MODULE
	// **********

	// **********
	// MAIN CODE
	// **********
	assign wCS = { CS_I&RD_I, CS_I&RD_I, CS_I&RD_I, CS_I&RD_I, CS_I&RD_I, CS_I&RD_I, CS_I&RD_I, CS_I&RD_I };
	assign DAT_O = wCS & mem[ADDR_I];
	
	initial begin
		$readmemh("rom.dat", mem);
		end

endmodule
