`timescale 1us/100ns

module bench_top;

	wire CLK, nRST;

	bench_clock uClock(.CLK_O(CLK), .nRST_O(nRST));
	
	initial begin
		$dumpvars(0, uClock);
	end

endmodule
