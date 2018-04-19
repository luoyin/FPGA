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
	reg        	rD_valid;
	reg  [7:0] 	rD_icode;
	reg  [3:0] 	rD_ifun;
	reg  [2:0] 	rD_src;
	reg  [2:0] 	rD_dst;
	reg  [7:0] 	rD_valC;				// imm
	reg [13:0] 	rD_valP;
	reg  [1:0] 	rD_count;
	// ***** Stage E
	reg 		rE_valid;
	reg  [7:0] 	rE_icode;
	reg  [3:0] 	rE_ifun;
	reg  [2:0] 	rE_src;
	reg  [2:0] 	rE_dst;
	reg [13:0] 	rE_valP;
	reg [13:0] 	rE_addrM;
	reg  [4:0] 	rE_addrIO;
	// src
	reg  [7:0] 	rE_valC;				// imm
	reg  [7:0]	rE_valS;				// reg, input B of ALU
	reg  [7:0]	rE_valA;				// input A of ALU
	// ***** Stage M *****
	reg 		rM_valid;
	reg  [7:0] 	rM_icode;
	reg  [2:0] 	rM_dstR;
	reg  [7:0] 	rM_valC;				// imm
	reg  [7:0] 	rM_valS;				// reg
	reg  [7:0] 	rM_valE;				// alu
	wire		wM_dstM_CS;				// ->M
	wire		wM_dstM_CS_C;			// imm->M
	wire		wM_dstM_CS_S;			// reg->M
	reg [13:0] 	rM_valP;
	reg [13:0] 	rM_addrM;
	reg  [4:0] 	rM_addrIO;
	// Stage W
	reg 		rW_valid;
	reg  [7:0] 	rW_icode;
	reg  [2:0] 	rW_dstR;
	reg  [7:0] 	rW_valC;				// imm
	reg  [7:0] 	rW_valS;				// reg
	reg  [7:0] 	rW_valE;				// alu
	reg  [7:0] 	rW_valM;				// mem
	wire		wW_dstR_CS;				// ->reg
	wire		wW_dstR_CS_C;			// imm->reg
	wire		wW_dstR_CS_S;			// reg->reg
	wire		wW_dstR_CS_E;			// alu->reg
	wire		wW_dstR_CS_M;			// mem->reg
	reg [13:0] 	rW_valP;
	// Stack
	reg [13:0] rStack[7:0];
	reg [2:0] rStack_ndx;
	// RegBank
	reg [7:0] rRegBank[7:0];
	
	wire wDoubleByte;
	wire wTripleByte;
	
	wire wINS_NOP;
	
	// **********
	// INSTANCE MODULE
	// **********
	assign I_ADDR_O = rStack[rStack_ndx];
	assign wDoubleByte = (~rF3_IR[7])&(~rF3_IR[6])&( rF3_IR[2])&(~rF3_IR[0]);
	assign wTripleByte = (~rF3_IR[7])&( rF3_IR[6])&(~rF3_IR[0]);
	assign wSingle = (~wDoubleByte) & (~wTripleByte);
	assign wINS_NOP = (~rF3_IR[7])&(~rF3_IR[6])&(~rF3_IR[5])&(~rF3_IR[4])&(~rF3_IR[3])&(~rF3_IR[2])&(~rF3_IR[1]);
	
	// **** Stage M ****
	// src select
	// LMI
	assign wM_dstM_CS_C = (~rM_icode[7])&(~rM_icode[6])&(&rM_icode[5:3])&( rM_icode[2])&( rM_icode[1])&(~rM_icode[0]);		// LMI
	// LMr
	assign wM_dstM_CS_S = ( rM_icode[7])&( rM_icode[6])&(&rM_icode[5:3])&(~(&rM_icode[2:0]));								// LMr
	// dst control
	assign wM_dstM_CS = wM_dstM_CS_C | wM_dstM_CS_S;
	
	// **** Stage W ****
	// src select
	// LrI: 00DDD110
	assign wW_dstR_CS_C = (~rW_icode[7])&(~rW_icode[6])&(~(&rW_icode[5:3]))&( rW_icode[2])&( rW_icode[1])&(~rW_icode[0]);	// LrI
	// Lrr: 11DDDSSS
	assign wW_dstR_CS_S = ( rW_icode[7])&( rW_icode[6])&(~(&rW_icode[5:3]))&(~(&rW_icode[2:0]));							// Lrr
	// LrM: 11DDD111
	assign wW_dstR_CS_M = ( rW_icode[7])&( rW_icode[6])&(~(&rW_icode[5:3]))&(&rW_icode[2:0]);								// Lrr
	// INr/DCr/ALUr/ALUI/ROT
	// INr/DCr: 00DDD00x
	assign wW_dstR_CS_E = ( (~rW_icode[7]) & (~rW_icode[6]) & (~(&rW_icode[5:3])) & (~(|rW_icode[5:3])) & (~rW_icode[2]) & (~rW_icode[1]) ) |		// INr/DCr: 00DDD00x
						  ( ( rW_icode[7]) & (~rW_icode[6]) & (~(&rW_icode[2:0])) ) | 																// ALUr: 10PPPSSS
						  ( (~rW_icode[7]) & (~rW_icode[6]) & ( rW_icode[2]) & (~rW_icode[1]) & (~rW_icode[0]) ) |									// ALUI: 00PPP100
						  ( (~rW_icode[7]) & (~rW_icode[6]) & (~rW_icode[5]) & (~rW_icode[2]) & ( rW_icode[1]) & (~rW_icode[0]) );					// ROT:  000RR010
	// dst control
	assign wW_dstR_CS = wW_dstR_CS_C | wW_dstR_CS_S | wW_dstR_CS_M | wW_dstR_CS_E;
	
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
			rD_icode <= 8'b0;
			rD_ifun  <= 4'b0;
			rD_src   <= 3'b0;
			rD_dst   <= 3'b0;
			rD_valC  <= 8'b0;
			rD_valP  <= 14'b0;
			rD_count <= 2'b0;
			end
		else begin
			if((~rD_count[1])&(~rD_count[0])) begin
				rD_icode <= rF3_IR;
				rD_ifun  <= { (~rF3_IR[2])&( rF3_IR[1])&(~rF3_IR[0]), rF3_IR[5], rF3_IR[4], rF3_IR[3] };
				rD_src   <= rF3_IR[2:0];
				rD_dst   <= rF3_IR[5:3];
				rD_valC  <= rF2_IR;
				rD_valP  <= { rF1_IR[5:0], rF2_IR };
				rD_valid <= rF3_IR_valid & (~wINS_NOP);
				if(wDoubleByte)
					rD_count <= 1;
				else if(wTripleByte)
					rD_count <= 2;
				else
					rD_count <= 0;
				end
			else begin
				rD_count <= rD_count-1;
				rD_valid <= 1'b0;
				end
			end
		end
	
	// Decode (D->E)
	always @(posedge CLK_I) begin
		if(~nRST_I) begin
			rE_valid 		<= 1'b0;
			rE_icode 		<= 8'b0;
			rE_ifun  		<= 4'b0;
			rE_dst	 		<= 3'b0;
			rE_valP  		<= 14'b0;
			rE_valC  		<= 8'b0;
			end
		else begin
			rE_valid <= rD_valid;
			
			if(rD_valid) begin
				rE_icode 	<= rD_icode;
				rE_ifun  	<= rD_ifun;
				rE_src		<= rD_src;
				rE_dst  	<= rD_dst;
				rE_valP  	<= rD_valP;
				
				// valC
				rE_valC  <= rD_valC;
				
				// valA
				casex(rD_icode)
					5'b0000x: begin			// INr, DCr
						rE_valA <= rRegBank[rD_dst];
						end
					5'b00010: begin			// ROT
						rE_valA <= rRegBank[3'b000];
						end
					5'b00100: begin			// ALUI
						rE_valA <= rRegBank[3'b000];
						end
					5'b10xxx: begin			// ALUr
						rE_valA <= rRegBank[rD_src];
						end
					endcase
				
				// valS
				casex(rD_icode)
					5'b00000: begin
						rE_valS <= 8'b00000001;
						end
					5'b00001: begin
						rE_valS <= 8'b11111111;
						end
					5'b00100: begin
						rE_valS <= rD_valC;
						end
					5'b00110: begin
						rE_valS <= rD_valC;
						end
					default: begin
						rE_valS <= 8'b0;
						end
					endcase
				end
				
				// src select
				
			end
		end
		
	// Execute (E->M)
	always @(posedge CLK_I) begin
		if(~nRST_I) begin
			rM_valid 		<= 1'b0;
			rM_icode 		<= 8'b0;
			// src
			rM_valC			<= 8'b0;
			rM_valS			<= 8'b0;
			rM_valE			<= 8'b0;
			end
		else begin
			rM_valid		<= rE_valid;
			if(rE_valid) begin
				rM_icode	<= rE_icode;
				rM_valC		<= rE_valC;
				// dst control
				
				end
			end
		end
		
	// Memory (M->W)
	always @(posedge CLK_I) begin
		if(~nRST_I) begin
			rW_valid		<= 1'b0;
			rW_icode		<= 8'b0;
			// src
			rW_valC			<= 8'b0;
			rW_valS			<= 8'b0;
			rW_valE			<= 8'b0;
			rW_valM			<= 8'b0;
			end
		else begin
			rW_valid		<= rM_valid;
			if(rM_valid) begin
				rW_icode	<= rM_icode;
				end
			end
		end
	
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
