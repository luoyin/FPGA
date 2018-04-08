`timescale 1us/100ns

module bench_top;

	wire CLK, nRST, CLK1, CLK2, SYNC;

	bench_clock #(.HALF_CYCLE(5)) uClockGen(.CLK_O(CLK), .nRST_O(nRST));
	clock uClock(.CLK_I(CLK), .CLK1_O(CLK1), .CLK2_O(CLK2));
	cpu uCPU(.CLK1_I(CLK1), .CLK2_I(CLK2), .nRST_I(nRST), .SYNC_O(SYNC));
	
	initial begin
		$dumpvars(0, uClockGen);
		$dumpvars(0, uClock);
		$dumpvars(0, uCPU);
	end

endmodule
