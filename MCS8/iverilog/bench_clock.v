`timescale 1us/100ns

module bench_clock(CLK_O, nRST_O);

	output reg CLK_O;
	output reg nRST_O;

	initial begin
		CLK_O=1'b0;
		nRST_O=1'b1;
		forever #5 CLK_O=~CLK_O;
	end
	
	initial begin
		#2000 $finish;
	end

endmodule
