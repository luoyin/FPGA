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

`timescale 1us/100ns
`include "define.v"

// **********
// DEFINE MODEL PORT
// **********
//
module cpu(
	// Clock
	CLK_I, nRST_I,
	// ROM interface
	ROM_ADDR_O, ROM_DATA_I,
	// RAM interface
	RAM_ADDR_O, RAM_DATA_I, RAM_DATA_O, RAM_CS_O, RAM_WR_O,
	// IO interface
	IO_ADDR_O, IO_DATA_I, IO_DATA_O, IO_CS_O, IO_WR_O
);

	// **********
	// DEFINE PARAMETER
	// **********

	// **********
	// DEFINE INPUT
	// **********
	// Clock
	input wire					CLK_I;
	input wire					nRST_I;
	// ROM
	input wire		 [7:0]		ROM_DATA_I;
	// RAM
	input wire		 [7:0]		RAM_DATA_I;
	// IO
	input wire		 [7:0]		IO_DATA_I;

	// **********
	// DEFINE OUTPUT
	// **********
	// ROM
	output wire		[13:0]		ROM_ADDR_O;
	// RAM
	output wire		[13:0]		RAM_ADDR_O;
	output wire		 [7:0]		RAM_DATA_O;
	output wire					RAM_CS_O;
	output wire					RAM_WR_O;
	// IO
	output wire		 [4:0]		IO_ADDR_O;
	output wire		 [7:0]		IO_DATA_O;
	output wire					IO_CS_O;
	output wire					IO_WR_O;

	// **********
	// ATRRIBUTE
	// **********
	// Stage F1
	reg							rF1_valid;
	reg				 [7:0]		rF1_code;
	wire						wF1_Pause;
	// Stage F2
	reg							rF2_valid;
	reg				 [7:0]		rF2_code;
	wire						wF2_Pause;
	// Stage F3
	reg							rF3_valid;
	reg				 [7:0]		rF3_code;
	wire						wF3_Pause;
	// Stage D
	reg							rD_valid;
	reg				 [7:0]		rD_icode;
	wire			 [5:0]		wD_DSTR_CTRL;
	wire						wD_Pause;
	// Stage E
	reg							rE_valid;
	reg				 [7:0]		rE_icode;
	reg				 [5:0]		rE_DSTR_CTRL;
	wire						wE_Pause;
	// Stage M/IO
	reg							rM_valid;
	reg				 [7:0]		rM_icode;
	reg				 [5:0]		rM_DSTR_CTRL;
	wire						wM_Pause;
	// Stage W
	reg							rW_valid;
	reg				 [7:0]		rW_icode;
	reg				 [5:0]		rW_DSTR_CTRL;
	wire						wW_Pause;

	// **********
	// INSTANCE MODULE
	// **********

	// **********
	// MAIN CODE
	// **********
	// F1->F2
	always @(posedge CLK_I) begin
		if(~nRST_I) begin
			rF2_valid 			<= 1'b0;
			rF2_code			<= 8'b0;
		end
		else begin
			if(~wF2_Pause) begin
				rF2_code		<= rF1_code;
			end
		end
	end
	
	// F2->F3
	always @(posedge CLK_I) begin
		if(~nRST_I) begin
			rF3_valid 			<= 1'b0;
			rF3_code			<= 8'b0;
		end
		else begin
			if(~wF3_Pause) begin
				rF3_code		<= rF2_code;
			end
		end
	end
	
	// F3->D
	always @(posedge CLK_I) begin
		if(~nRST_I) begin
			rD_valid 			<= 1'b0;
			rD_icode			<= 8'b0;
		end
		else begin
			if(~wD_Pause) begin
				rD_icode		<= rF3_code;
			end
		end
	end
	
	

endmodule
