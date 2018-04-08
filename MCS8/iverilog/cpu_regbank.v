// **********
// COPYRIGHT(c) 2018, LUOYIN
// All rights reserved
// 
// IP LIB INDEX	:
// IP Name		: Intel8008
// File Name	: cpu_regbank.v
// Module Name	: cpu_regbank
// Full Name	: RegBank of Intel8008 CPU
// 
// Author		: LUO YIN
// Email		: luoyin1986@gmail.com
// Data			: 2018/04/08
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
module cpu_regbank(
	CLK1_I, CLK2_I, SYNC_I, nRST_I,
	CS_I, RD_I, WR_I, INC_I, DCR_I,
	ADDR_I, DAT_I, DAT_O
);

	// **********
	// DEFINE PARAMETER
	// **********

	// **********
	// DEFINE INPUT
	// **********
	input wire CLK1_I, CLK2_I, SYNC_I, nRST_I;
	input wire CS_I, RD_I, WR_I, INC_I, DCR_I;
	input wire [2:0] ADDR_I;
	input wire [7:0] DAT_I;

	// **********
	// DEFINE OUTPUT
	// **********
	output wire [7:0] DAT_O;

	// **********
	// ATRRIBUTE
	// **********
	reg [7:0] rBank [7:0];
	wire [7:0] wCS;

	// **********
	// INSTANCE MODULE
	// **********
	assign wCS = {CS_I, CS_I, CS_I, CS_I, CS_I, CS_I, CS_I, CS_I};
	assign DAT_O = wCS & RD_I & rBank[ADDR_I];

	// **********
	// MAIN CODE
	// **********
	always @(posedge CLK2_I) begin
		if (~nRST_I) begin
			rBank[0]<=8'b0;
			rBank[1]<=8'b0;
			rBank[2]<=8'b0;
			rBank[3]<=8'b0;
			rBank[4]<=8'b0;
			rBank[5]<=8'b0;
			rBank[6]<=8'b0;
			rBank[7]<=8'b0;
			end
		else if (CS_I & (~SYNC_I) & WR_I) begin
			rBank[ADDR_I]<=DAT_I;
			end
		else if (CS_I & (~SYNC_I) & INC_I) begin
			rBank[ADDR_I]<=rBank[ADDR_I]+1;
			end
		else if (CS_I & (~SYNC_I) & DCR_I) begin
			rBank[ADDR_I]<=rBank[ADDR_I]-1;
			end
		else begin
			end
	end

endmodule
