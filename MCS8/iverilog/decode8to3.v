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
module decode8to3(
	In0, In1, In2, In3, In4, In5, In6, In7,
	Out, Out0, Out1, Out2
);

	// **********
	// DEFINE PARAMETER
	// **********

	// **********
	// DEFINE INPUT
	// **********
	input wire In0, In1, In2, In3, In4, In5, In6, In7;

	// **********
	// DEFINE OUTPUT
	// **********
	output reg [3:0] Out;
	output wire Out0, Out1, Out2;

	// **********
	// ATRRIBUTE
	// **********
	wire [7:0] wIn;

	// **********
	// INSTANCE MODULE
	// **********
	assign wIn={In7, In6, In5, In4, In3, In2, In1, In0};
	assign Out2=Out[2];
	assign Out1=Out[1];
	assign Out0=Out[0];

	// **********
	// MAIN CODE
	// **********
	always @(wIn) begin
		case(wIn)
			8'b00000001:	Out=3'b000;
			8'b00000010:	Out=3'b001;
			8'b00000100:	Out=3'b010;
			8'b00001000:	Out=3'b011;
			8'b00010000:	Out=3'b100;
			8'b00100000:	Out=3'b101;
			8'b01000000:	Out=3'b110;
			8'b10000000:	Out=3'b111;
			default:		Out=3'b000;
		endcase
	end
	
endmodule
