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

// **********
// DEFINE MODEL PORT
// **********
//
module bench_cpu_alu();

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
	reg [7:0] X;
	reg [7:0] Y;
	reg Cin;
	reg [2:0] OP;
	wire [7:0] E;
	wire C, Z, S, P;

	// **********
	// INSTANCE MODULE
	// **********
	cpu_alu uALU(
		.X_I(X), .Y_I(Y), .C_I(Cin), .OP_I(OP),
		.E_O(E), .C_O(C), .Z_O(Z), .S_O(S), .P_O(P)
	);

	// **********
	// MAIN CODE
	// **********
	initial begin
		X <= 8'b10110011;
		Y <= 8'b01101100;
		Cin <= 1'b0;
		OP <= 3'b000;
		#10 OP <= 3'b001;
		#10 OP <= 3'b010;
		#10 OP <= 3'b011;
		#10 OP <= 3'b100;
		#10 OP <= 3'b101;
		#10 OP <= 3'b110;
		#10 OP <= 3'b111;
		#10 $finish;
		end
		
	initial begin
		$dumpvars(0, uALU);
		end

endmodule
