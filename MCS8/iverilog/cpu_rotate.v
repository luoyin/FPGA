// **********
// COPYRIGHT(c) 2018, LUOYIN
// All rights reserved
// 
// IP LIB INDEX	:
// IP Name		: Intel8008
// File Name	: cpu_rotate.v
// Module Name	: cpu_rotate
// Full Name	: CPU Rotator
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
module cpu_rotate(
	X_I, C_I, Z_I, S_I, P_I, OP_I,
	E_O, C_O, Z_O, S_O, P_O
);

	// **********
	// DEFINE PARAMETER
	// **********

	// **********
	// DEFINE INPUT
	// **********
	input wire [7:0] X_I;
	input wire C_I, Z_I, S_I, P_I;
	input wire [1:0] OP_I;

	// **********
	// DEFINE OUTPUT
	// **********
	output reg [7:0] E_O;
	output reg C_O;
	output wire Z_O, S_O, P_O;

	// **********
	// ATRRIBUTE
	// **********

	// **********
	// INSTANCE MODULE
	// **********

	// **********
	// MAIN CODE
	// **********
	assign Z_O=Z_I;
	assign S_O=S_I;
	assign P_O=P_I;
	
	always @(X_I, C_I, OP_I) begin
		case (OP_I)
			2'b00: begin
				E_O <= {X_I[6:0], X_I[7]};
				C_O <= X_I[7];
				end
			2'b01: begin
				E_O <= {X_I[0], X_I[7:1]};
				C_O <= X_I[0];
				end
			2'b10: begin
				{C_O, E_O} <= {X_I, C_I};
				end
			2'b11: begin
				{E_O, C_O} <= {C_I, X_I};
				end
			default: begin
				E_O <= X_I;
				C_O <= C_I;
				end
			endcase
		end

endmodule
