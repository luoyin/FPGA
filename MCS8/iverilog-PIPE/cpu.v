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
// Description
// F1->F2->F3->D->E->M->W
// **********

// **********
// DEFINE MODEL PORT
// **********
module cpu(
	// Clock
	CLK_I, nRST_I,
	// ICode
	I_DAT_I, I_ADDR_O,
	// DCode
	D_DAT_I, D_DAT_O, D_ADDR_O,
	// IO
	IO_DAT_I, IO_DAT_O, IO_ADDR_O
);

	// **********
	// DEFINE PARAMETER
	// **********

	// **********
	// DEFINE INPUT
	// **********
	// Clock
	input wire CLK_I, nRST_I;
	// ICode
	input wire [7:0] I_DAT_I;
	// DCode
	input wire [7:0] D_DAT_I;
	// IO
	input wire [7:0] IO_DAT_I;

	// **********
	// DEFINE OUTPUT
	// **********
	// ICode
	output wire [13:0] I_ADDR_O;
	// DCode
	output wire [7:0]  D_DAT_O;
	output wire [13:0] D_ADDR_O;
	// IO
	output wire [7:0]  IO_DAT_O;
	output wire [4:0]  IO_ADDR_O;
	
	// **********
	// ATRRIBUTE
	// **********
	// Stage F1
	reg [7:0] rF1_IR;
	reg rF1_IR_valid;
	// Stage F2
	reg [7:0] rF2_IR;
	reg rF2_IR_valid;
	// Stage F3
	reg [7:0] rF3_IR;
	reg rF3_IR_valid;
	// State D
	reg rD_valid;
	reg [4:0]  rD_icode;
	reg [3:0]  rD_ifun;
	reg [2:0]  rD_srcR;
	reg [2:0]  rD_dstR;
	reg [7:0]  rD_valC;
	reg [13:0] rD_valP;
	// Stage E
	reg rE_valid;
	reg [4:0]  rE_icode;
	reg [3:0]  rE_ifun;
	reg [2:0]  rE_srcR;
	reg [2:0]  rE_dstR;
	reg [7:0]  rE_valC;
	reg [13:0] rE_valP;
	reg [7:0]  rE_valS;
	reg [7:0]  rE_valH;
	reg [7:0]  rE_valL;
	// Stage M
	reg rM_valid;
	reg [4:0]  rM_icode;
	reg [2:0]  rM_dstR;
	reg [7:0]  rM_valE;
	// Stage W
	
	// Stack
	reg [13:0] rStack[7:0];
	reg [2:0] rStack_ndx;
	// RegBank
	reg [7:0] rRegBank[7:0];
	
	// **********
	// INSTANCE MODULE
	// **********
	assign I_ADDR_O = rStack[rStack_ndx];

	// **********
	// MAIN CODE
	// **********
	// Stack Control
	always @(posedge CLK_I) begin
		if(~nRST_I) begin
			rStack[0] <= 14'b0;
			rStack[1] <= 14'b0;
			rStack[2] <= 14'b0;
			rStack[3] <= 14'b0;
			rStack[4] <= 14'b0;
			rStack[5] <= 14'b0;
			rStack[6] <= 14'b0;
			rStack[7] <= 14'b0;
			rStack_ndx <= 3'b0;
			end
		else begin
			rStack[rStack_ndx] <= rStack[rStack_ndx]+1;
			end
		end
		
	// Fetch 2 (F1->F2)
	always @(posedge CLK_I) begin
		if(~nRST_I) begin
			rF2_IR <= 8'b0;
			rF2_IR_valid <= 1'b0;
			end
		else begin
			rF2_IR <= rF1_IR;
			rF2_IR_valid <= rF1_IR_valid;
			end
		end
		
	// Fetch 3 (F2->F3)
	always @(posedge CLK_I) begin
		if(~nRST_I) begin
			rF3_IR <= 8'b0;
			rF3_IR_valid <= 8'b0;
			end
		else begin
			rF3_IR <= rF2_IR;
			rF3_IR_valid <= rF2_IR_valid;
			end
		end
		
	// Fetch (F3->D)
	always @(posedge CLK_I) begin
		if(~nRST_I) begin
			rD_valid <= 1'b0;
			rD_icode <= 5'b0;
			rD_ifun  <= 4'b0;
			rD_srcR  <= 3'b0;
			rD_dstR  <= 3'b0;
			rD_valC  <= 8'b0;
			rD_valP  <= 14'b0;
			end
		else begin
			if(rF3_IR_valid) begin
				rD_icode <= { rF3_IR[7], rF3_IR[6], rF3_IR[2], rF3_IR[1], rF3_IR[0] };
				rD_ifun <= { rF3_IR[5], rF3_IR[4], rF3_IR[3] };
				rD_srcR <= rF1_IR[2:0];
				rD_dstR <= rF1_IR[5:3];
				rD_valC <= rF2_IR;
				rD_valP <= { rF1_IR[5:0], rF2_IR };
				end
			end
		end
	
	// Decode (D->E)
	always @(posedge CLK_I) begin
		if(~nRST_I) begin
			rE_valid <= 1'b0;
			rE_icode <= 5'b0;
			rE_ifun  <= 4'b0;
			rE_srcR  <= 3'b0;
			rE_dstR  <= 3'b0;
			rE_valC  <= 8'b0;
			rE_valP  <= 14'b0;
			end
		else begin
			rE_icode <= rD_icode;
			rE_ifun  <= rD_ifun;
			rE_srcR  <= rD_srcR;
			rE_dstR  <= rD_dstR;
			rE_valC  <= rD_valC;
			rE_valP  <= rD_valP;
			end
		end
		
	// Execute (E->M)
	always @(posedge CLK_I) begin
		if(~nRST_I) begin
			rM_icode <= 5'b0;
			
			end
		else begin
			
			end
		end
		
	// Memory (M->W)
	
	// WriteBack (ROM->F1)
	always @(posedge CLK_I) begin
		if(~nRST_I) begin
			rRegBank[0] <= 8'b0;
			rRegBank[1] <= 8'b0;
			rRegBank[2] <= 8'b0;
			rRegBank[3] <= 8'b0;
			rRegBank[4] <= 8'b0;
			rRegBank[5] <= 8'b0;
			rRegBank[6] <= 8'b0;
			rRegBank[7] <= 8'b0;
			rF1_IR <= 8'b0;
			rF1_IR_valid <=1'b0;
			end
		else begin
			rF1_IR <= I_DAT_I;
			rF1_IR_valid <= 1'b1;
			end
		end
	
endmodule
