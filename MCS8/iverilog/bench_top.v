`timescale 1us/100ns

module bench_top;

	wire CLK, nRST, CLK1, CLK2;

	bench_clock #(.HALF_CYCLE(5)) uClockGen(.CLK_O(CLK), .nRST_O(nRST));
	clock uClock(.CLK_I(CLK), .nRST_I(nRST), .CLK1_O(CLK1), .CLK2_O(CLK2));
	
	initial begin
		$dumpvars(0, uClockGen);
		$dumpvars(0, uClock);
	end

endmodule
