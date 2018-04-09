// **********
// COPYRIGHT(c) 2018, LUOYIN
// All rights reserved
// 
// IP LIB INDEX	:
// IP Name		: MCS8
// File Name	: cpu.v
// Module Name	: cpu
// Full Name	: Intel8008 CPU
// 
// Author		: LUO YIN
// Email		: luoyin1986@gmail.com
// Data			: 2018/04/03
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
module cpu(
	CLK1_I, CLK2_I, nRST_I,
	SYNC_O,
	READY_I, INT_I,
	STATE_O,
	DAT_I,
	DAT_O
);

	// **********
	// DEFINE PARAMETER
	// **********
	localparam CYCLE_PCI		= 2'b00;
	localparam CYCLE_PCC		= 2'b01;
	localparam CYCLE_PCR		= 2'b10;
	localparam CYCLE_PCW		= 2'b11;

	// **********
	// DEFINE INPUT
	// **********
	input wire CLK1_I, CLK2_I, nRST_I;
	input wire READY_I, INT_I;
	input wire [7:0] DAT_I;

	// **********
	// DEFINE OUTPUT
	// **********
	output reg SYNC_O;
	output wire [2:0] STATE_O;
	output wire [7:0] DAT_O;

	// **********
	// ATRRIBUTE
	// **********
	// BUS
	wor [7:0] rBusOut;
	
	// Decode Signal
	wire wD_NOP, wD_HLT;
	wire wD_INC, wD_DCR, wD_ROT, wD_RETC, wD_ALUI, wD_RST, wD_LRI, wD_LMI, wD_RET;
	wire wD_JMPC, wD_CALC, wD_JMP, wD_CAL, wD_INP, wD_OUT;
	wire wD_ALUR, wD_ALUM;
	wire wD_LRR, wD_LRM, wD_LMR;
	wire wD_JMP_CAL;
	// Condition Signal
	wire wCond;
	// BUS Out Control
	wire wCSI_BusOut_PCL, wCSI_BusOut_PCH;
	wire wCSI_BusOut_RegL, wCSI_BusOut_RegH;
	wire wCSI_BusOut_RegAlpha, wCSI_BusOut_RegBeta;
	wire wCSI_BusOut_Cond;
	// State Control
	wire [2:0] wState;
	wire [1:0] wCycle;
	// Cycle Control
	wor [1:0] wCycleCtrl;
	wire wCycleC1, wCycleC2, wCycleC3;
	wire wCycleCtrl_PCI, wCycleCtrl_PCC, wCycleCtrl_PCR, wCycleCtrl_PCW;
	// State Control
	wire wStateT1, wStateT2, wStateT3, wStateT4, wStateT5, wStateT1I, wStateSTOP, wStateWAIT;
	// BUS internal
	wor [7:0] wBUS;
	wire wBUS_In, wBUS_Out;
	
	// BusControl
	// BUS
	wire wBusOut, wBusIn;
	// RegAlpha Control
	wire wRegAlpha_RD, wRegAlpha_WR;
	wire [7:0] wRegAlpha_Raw;
	// RegBeta Control
	wire wRegBeta_RD, wRegBeta_WR;
	wire [7:0] wRegBeta_Raw;
	// RegIR Control
	wire wRegID_RD, wRegID_WR;
	wire [7:0] wIR;
	// Stack Control
	wire wStack_RD, wStack_WR, wStack_HA, wStacK_INCR, wStack_PUSH, wStacK_POP;
	// RegBank Control
	wire wRegBank_RD, wRegBank_WR, wRegBank_INC, wRegBank_DCR;
	wire [2:0] wRegBank_ADDR;
	wire wRegBank_Src, wRegBank_Dst, wRegBank_DstA;
	// ALU
	wire [7:0] wALU_E;
	wire [2:0] wALU_OP;
	wire wALU_C, wALU_Z, wALU_S, wALU_P;
	// Rotate
	wire [7:0] wROT_E;
	wire [1:0] wROT_OP;
	wire wROT_C, wROT_Z, wROT_S, wROT_P;
	// Status Register
	wire wStatus_C, wStatus_P, wStatus_Z, wStatus_S;
	wire wStatus_WR;

	// **********
	// INSTANCE MODULE
	// **********
	cpu_decode uDecode(
		.IR_I(wIR),
		.D_NOP_O(wD_NOP), .D_HLT_O(wD_HLT),
		.D_INC_O(wD_INC), .D_DCR_O(wD_DCR), .D_ROT_O(wD_ROT), .D_RETC_O(wD_RETC), .D_ALUI_O(wD_ALUI), .D_RST_O(wD_RST), .D_LRI_O(wD_LRI), .D_LMI_O(wD_LMI), .D_RET_O(wD_RET),
		.D_JMPC_O(wD_JMPC), .D_CALC_O(wD_CALC), .D_JMP_O(wD_JMP), .D_CAL_O(wD_CAL), .D_INP_O(wD_INP), .D_OUT_O(wD_OUT),
		.D_ALUR_O(wD_ALUR), .D_ALUM_O(wD_ALUM),
		.D_LRR_O(wD_LRR), .D_LRM_O(wD_LRM), .D_LMR_O(wD_LMR)
	);
	
	cpu_state uState(
		.CLK1_I(CLK1_I), .CLK2_I(CLK2_I), .SYNC_I(SYNC_O),
		.nRST_I(nRST_I),
		.READY_I(READY_I), .INT_I(INT_I),
		.COND_I(wCond),
		.D_NOP_I(wD_NOP), .D_HLT_I(wD_HLT),
		.D_INC_I(wD_INC), .D_DCR_I(wD_DCR), .D_ROT_I(wD_ROT), .D_RETC_I(wD_RETC), .D_ALUI_I(wD_ALUI), .D_RST_I(wD_RST), .D_LRI_I(wD_LRI), .D_LMI_I(wD_LMI), .D_RET_I(wD_RET),
		.D_JMPC_I(wD_JMPC), .D_CALC_I(wD_CALC), .D_JMP_I(wD_JMP), .D_CAL_I(wD_CAL), .D_INP_I(wD_INP), .D_OUT_I(wD_OUT),
		.D_ALUR_I(wD_ALUR), .D_ALUM_I(wD_ALUM),
		.D_LRR_I(wD_LRR), .D_LRM_I(wD_LRM), .D_LMR_I(wD_LMR),
		.STATE_O(wState), .CYCLE_O(wCycle)
	);
	// Stack
	cpu_stack uStack(
		.CLK1_I(CLK1_I), .CLK2_I(CLK2_I), .SYNC_I(SYNC_O), .nRST_I(nRST_I),
		.RD_I(wStack_RD), .WR_I(wStack_WR), .HA_I(wStack_HA), .INCR_I(wStack_INCR),
		.PUSH_I(wStack_PUSH), .POP_I(wStack_POP),
		.DAT_I(wBUS), .DAT_O(wBUS)
	);
	// RegBank
	cpu_regbank uRegBank(
		.CLK1_I(CLK1_I), .CLK2_I(CLK2_I), .SYNC_I(SYNC_O), .nRST_I(nRST_I),
		.RD_I(wRegBank_RD), .WR_I(wRegBank_WR), .INC_I(wRegBank_INC), .DCR_I(wRegBank_DCR),
		.ADDR_I(wRegBank_ADDR), .DAT_I(wBUS), .DAT_O(wBUS)
	);
	// RegAlpha
	cpu_regtemp uRegAlpha(
		.CLK1_I(CLK1_I), .CLK2_I(CLK2_I), .SYNC_I(SYNC_O), .nRST_I(nRST_I),
		.RD_I(wRegAlpha_RD), .WR_I(wRegAlpha_WR),
		.DAT_I(wBUS), .DAT_O(wBUS), .DAT_RAW_O(wRegAlpha_Raw)
	);
	// RegBeta
	cpu_regtemp uRegBeta(
		.CLK1_I(CLK1_I), .CLK2_I(CLK2_I), .SYNC_I(SYNC_O), .nRST_I(nRST_I),
		.RD_I(wRegBeta_RD), .WR_I(wRegBeta_WR),
		.DAT_I(wBUS), .DAT_O(wBUS), .DAT_RAW_O(wRegBeta_Raw)
	);
	// IR
	cpu_regtemp uRegIR(
		.CLK1_I(CLK1_I), .CLK2_I(CLK2_I), .SYNC_I(SYNC_O), .nRST_I(nRST_I),
		.RD_I(wRegIR_RD), .WR_I(wRegIR_WR),
		.DAT_I(wBUS), .DAT_O(), .DAT_RAW_O(wIR)
	);
	// ALU
	cpu_alu uALU(
		.X_I(wRegAlpha_Raw), .Y_I(wRegBeta_Raw), .C_I(wStatus_C), .OP_I(wALU_OP),
		.E_O(wALU_E), .C_O(wALU_C), .Z_O(wALU_Z), .S_O(wALU_S), .P_O(wALU_P)
	);
	// Rotate
	cpu_rotate uRotate(
		.X_I(wRegAlpha_Raw), .C_I(wStatus_C), .Z_I(wStatus_Z), .S_I(wStatus_S), .P_I(wStatus_P), .OP_I(wROT_OP),
		.E_O(wROT_E), .C_O(wROT_C), .Z_O(wROT_Z), .S_O(wROT_S), .P_O(wROT_P)
	);
	// Status Register
	cpu_status uStatus(
		.CLK1_I(CLK1_I), .CLK2_I(CLK2_I), .SYNC_I(SYNC_O), .nRST_I(nRST_I),
		.RD_I(wSEL_BusOut_Cond), .WR_I(wStatus_WR),
		.CF_I(wALU_C), .PF_I(wALU_P), .ZF_I(wALU_Z), .SF_I(wALU_S),
		.CF_O(wStatus_C), .PF_O(wStatus_P), .ZF_O(wStatus_Z), .SF_O(wStatus_S), .BUS_O(wBUS)
	);

	// **********
	// MAIN CODE
	// **********
	// SYNC_O
	always @(negedge CLK2_I) begin
		if(~nRST_I) begin
			SYNC_O<=1'b0;
			end
		else
			SYNC_O<=~SYNC_O;
	end
	
	// Decode
	assign wD_JMP_CAL = wD_JMP | wD_JMPC | wD_CAL | wD_CALC;
	
	// Cycle Control
	assign wCycleC1 = (~wCycle[1])&(~wCycle[0]);
	assign wCycleC2 = (~wCycle[1])&( wCycle[0]);
	assign wCycleC3 = ( wCycle[1])&(~wCycle[0]);
	// PCI (Cycle1
	assign wCycleCtrl_PCI = wCycleC1;
	// PCC (Cycle2&IO)
	assign wCycleCtrl_PCC = wCycleC2 & ( wD_INP | wD_OUT );
	// PCR
	assign wCycleCtrl_PCR = ( wCycleC2 & ( wD_JMP | wD_JMPC | wD_CAL | wD_CALC | wD_LRM | wD_LRI | wD_ALUI ) ) |
								( wCycleC3 & ( wD_JMP | wD_JMPC | wD_CAL | wD_CALC) );
	// PCW
	assign wCycleCtrl_PCW = ( wCycleC2 & ( wD_ALUM | wD_LMR) ) | (wCycleC3 & wD_LMI);
	assign wCycleCtrl = wCycleCtrl_PCI & CYCLE_PCI;
	assign wCycleCtrl = wCycleCtrl_PCC & CYCLE_PCC;
	assign wCycleCtrl = wCycleCtrl_PCR & CYCLE_PCR;
	assign wCycleCtrl = wCycleCtrl_PCW & CYCLE_PCW;
	
	// State Control
	// T1: 010
	assign wStateT1 = (~wState[2])&( wState[1])&(~wState[0]);
	// T2: 100
	assign wStateT2 = ( wState[2])&(~wState[1])&(~wState[0]);
	// T3: 001
	assign wStateT3 = (~wState[2])&(~wState[1])&( wState[0]);
	// T4: 111
	assign wStateT4 = ( wState[2])&( wState[1])&( wState[0]);
	// T5: 101
	assign wStateT5 = ( wState[2])&(~wState[1])&( wState[0]);
	// T1I: 110
	assign wStateT1I = ( wState[2])&( wState[1])&(~wState[0]);
	// STOP: 011
	assign wStateSTOP = (~wState[2])&( wState[1])&( wState[0]);
	// WAIT: 000
	assign wStateWAIT = (~wState[2])&(~wState[1])&(~wState[0]);
	
	// BUS Control
	// PCL/PCH, RegL/RegH, RegAlpha, RegBeta, COND
	assign wCSI_BusOut_PCL = (wCycleC1 & wStateT1) |
							 (wCycleC2 & wStateT1 & (wD_JMP_CAL | wD_ALUI | wD_LRI | wD_LMI)) |
							 (wCycleC3 & wStateT1 & wD_JMP_CAL);
	assign wCSI_BusOut_PCH = (wCycleC1 & wStateT2) |
							 (wCycleC2 & wStateT2 & (wD_JMP_CAL | wD_ALUI | wD_LRI | wD_LMI)) |
							 (wCycleC3 & wStateT2 & wD_JMP_CAL);
	assign wCSI_BusOut_RegL = (wCycleC2 & wStateT1 & (wD_ALUM | wD_LMR | wD_LRM)) |
							  (wCycleC3 & wStateT1 & wD_LMI);
	assign wCSI_BusOut_RegH = (wCycleC2 & wStateT2 & (wD_ALUM | wD_LMR | wD_LRM)) |
							  (wCycleC3 & wStateT2 & wD_LMI);
	assign wCSI_BusOut_RegAlpha = (wCycleC2 & wStateT1 & (wD_INP | wD_OUT));
	assign wCSI_BusOut_RegBeta  = (wCycleC2 & wStateT2 & (wD_INP | wD_OUT));
	assign wCSI_BusOut_Cond = (wCycleC2 & wStateT3 & wD_INP);
	
	assign wBUS = 8'b0;
	assign wBusOut = wCSI_BusOut_PCL | wCSI_BusOut_PCH | wCSI_BusOut_RegL | wCSI_BusOut_RegH | wCSI_BusOut_RegAlpha | wCSI_BusOut_RegBeta | wCSI_BusOut_Cond;
	assign wBusIn = wStateT3;
	assign wBUS = { 8{wBusIn} } & DAT_I;
	assign DAT_O = { 8{wBusOut} } & wBUS;
	
	// Stack Signal
	assign wStack_RD = wCSI_BusOut_PCL | wCSI_BusOut_PCH;
	assign wStack_HA = wCSI_BusOut_PCH;
	assign wStack_INCR = wCSI_BusOut_PCH & (~SYNC_O);
	
	// RegBank Control
	assign wRegBank_Src = wStateT4 & (wD_LRR | wD_LMR | wD_ALUR);
	assign wRegBank_Dst = wStateT5 & (wD_LRR | wD_LRI | wD_LRM | wD_INC | wD_DCR);
	assign wRegBank_DstA = wStateT5 & (wD_ALUR | wD_ALUM | wD_ALUI);
	assign wRegBank_ADDR = ({ wCSI_BusOut_RegH, wCSI_BusOut_RegH, wCSI_BusOut_RegH } & 3'b101) |
						   ({ wCSI_BusOut_RegL, wCSI_BusOut_RegL, wCSI_BusOut_RegL } & 3'b110) |
						   ({ wRegBank_Src, wRegBank_Src, wRegBank_Src } & wIR[2:0] ) |
						   ({ wRegBank_Dst, wRegBank_Dst, wRegBank_Dst } & wIR[5:3] ) |
						   ({ wRegBank_DstA, wRegBank_DstA, wRegBank_DstA } & 3'b000 );
	assign wRegBank_RD = wCSI_BusOut_RegL | wCSI_BusOut_RegH | wRegBank_Src;
	assign wRegBank_WR = wRegBank_Dst | wRegBank_DstA;
	
	// RegIR Control
	assign wRegIR_RD = 1'b0;
	assign wRegIR_WR = wCycleC1 & wStateT3;
	
	// RegAlpha Control
	assign wRegAlpha_WR = ( wStateT5 & (wRegBank_DstA | (wRegBank_Dst&(~(|wRegBank_ADDR)))) ) |
						  ( wCycleC3 & wStateT3 & SYNC_O );
	
	// RegBeta Control
	assign wRegBeta_RD = (wStateT4 & wRegBank_Src) |
						 (wStateT4 & (wD_LMI | wD_LRI | wD_LMI));
	assign wRegBeta_WR = (wStateT4 & wRegBank_Src & SYNC_O) |
						 (wCycleC1 & wStateT3 & SYNC_O) |
						 (wCycleC2 & wStateT3 & SYNC_O & (~wD_OUT));
	
	// ALU Control
	assign wALU_OP = {3{wD_ALUR|wD_ALUM|wD_ALUI}} & wIR[5:3];
	
	// Rotate Control
	assign wROT_OP = {2{wD_ROT}} & wIR[1:0];
	
	// Status Control
	assign wStatus_WR = wD_ALUR | wD_ALUM | wD_ALUI | wD_ROT;
	
	// Condition Control
	assign wCond=( wIR[2] ) | 											// JMP/CAL
		( (~wIR[5]) ^ ( (~wIR[4]) & (~wIR[3]) & wStatus_C ) ) |			// Carry
		( (~wIR[5]) ^ ( (~wIR[4]) & ( wIR[3]) & wStatus_Z ) ) |			// Zero
		( (~wIR[5]) ^ ( ( wIR[4]) & (~wIR[3]) & wStatus_S ) ) |			// Sign
		( (~wIR[5]) ^ ( ( wIR[4]) & ( wIR[3]) & wStatus_P ) );			// Parity
	
	assign STATE_O = wState;
	
endmodule
