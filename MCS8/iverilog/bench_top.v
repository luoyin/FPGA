`timescale 1us/100ns

module bench_top;

	wire CLK, nRST, CLK1, CLK2, SYNC, READY, INT;
	wor [7:0] DAT_CPU_I;
	wire [7:0] DAT_CPU_O;
	wire [2:0] STATE;
	reg [13:0] ADDR;
	reg [1:0] CYC_CTRL;
	
	// State
	wire wStateT1, wStateT2, wStateT3, wStateT4, wStateT5;
	// Cycle
	wire wCyclePCI, wCyclePCC, wCyclePCR, wCyclePCW;
	// ROM Control
	wire wROM_CS, wROM_RD;
	
	bench_clock #(.HALF_CYCLE(5)) uClockGen(.CLK_O(CLK), .nRST_O(nRST));
	clock uClock(.CLK_I(CLK), .CLK1_O(CLK1), .CLK2_O(CLK2));
	cpu uCPU(
		.CLK1_I(CLK1), .CLK2_I(CLK2), .nRST_I(nRST), 
		.SYNC_O(SYNC),
		.READY_I(1'b1), .INT_I(1'b0),
		.STATE_O(STATE),
		.DAT_I(DAT_CPU_I), .DAT_O(DAT_CPU_O)
	);
	// rom
	rom uROM(
		.CS_I(wROM_CS), .RD_I(wROM_RD),
		.ADDR_I(ADDR[12:0]),
		.DAT_O(DAT_CPU_I)
	);
	
	// State
	// T1: 010
	assign wStateT1=(~STATE[2])&( STATE[1])&(~STATE[0]);
	// T2: 100
	assign wStateT2=( STATE[2])&(~STATE[1])&(~STATE[0]);
	// T3: 001
	assign wStateT3=(~STATE[2])&(~STATE[1])&( STATE[0]);
	// T4: 111
	assign wStateT4=( STATE[2])&( STATE[1])&( STATE[0]);
	// T5: 101
	assign wStateT5=( STATE[2])&(~STATE[1])&( STATE[0]);
	
	// Cycle
	assign wCyclePCI=(~CYC_CTRL[1])&(~CYC_CTRL[0]);
	assign wCyclePCC=(~CYC_CTRL[1])&( CYC_CTRL[0]);
	assign wCyclePCR=( CYC_CTRL[1])&(~CYC_CTRL[0]);
	assign wCyclePCW=( CYC_CTRL[1])&( CYC_CTRL[0]);
	
	// Address Latch
	always @(posedge CLK2) begin
		if(~nRST) begin
			ADDR 		<= 14'b0;
			CYC_CTRL 	<= 2'b0;
			end
		else if(wStateT1 & SYNC) begin
			ADDR[7:0] 	<= DAT_CPU_O;
			end
		else if(wStateT2 & SYNC) begin
			ADDR[13:8] 	<= DAT_CPU_O[5:0];
			CYC_CTRL   	<= DAT_CPU_O[7:6];
			end
		end
	
	assign wROM_CS = (~ADDR[13]);
	assign wROM_RD = wCyclePCI | wCyclePCR;
	
	// Debug
	initial begin
		$dumpvars(0, uClockGen);
		$dumpvars(0, uClock);
		$dumpvars(0, uCPU);
		$dumpvars(0, uROM);
	end
	
endmodule
