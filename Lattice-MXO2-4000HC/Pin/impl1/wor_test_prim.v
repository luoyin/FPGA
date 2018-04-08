// Verilog netlist produced by program LSE :  version Diamond (64-bit) 3.10.0.111.2
// Netlist written on Sat Apr  7 10:27:47 2018
//
// Verilog Description of module wor_test
//

module wor_test (KEY1, KEY2, KEY3, KEY4, LED1) /* synthesis syn_module_defined=1 */ ;   // /disk1/projects/FPGA/Lattice-MXO2-4000HC/Pin/wor_test.v(1[8:16])
    input KEY1;   // /disk1/projects/FPGA/Lattice-MXO2-4000HC/Pin/wor_test.v(2[13:17])
    input KEY2;   // /disk1/projects/FPGA/Lattice-MXO2-4000HC/Pin/wor_test.v(2[19:23])
    input KEY3;   // /disk1/projects/FPGA/Lattice-MXO2-4000HC/Pin/wor_test.v(2[25:29])
    input KEY4;   // /disk1/projects/FPGA/Lattice-MXO2-4000HC/Pin/wor_test.v(2[31:35])
    output LED1;   // /disk1/projects/FPGA/Lattice-MXO2-4000HC/Pin/wor_test.v(3[14:18])
    
    
    wire KEY1_c, KEY2_c, KEY3_c, KEY4_c, BUS, GND_net, VCC_net;
    
    OB LED1_pad (.I(BUS), .O(LED1));   // /disk1/projects/FPGA/Lattice-MXO2-4000HC/Pin/wor_test.v(3[14:18])
    VLO i33 (.Z(GND_net));
    PUR PUR_INST (.PUR(VCC_net));
    defparam PUR_INST.RST_PULSE = 1;
    TSALL TSALL_INST (.TSALL(GND_net));
    IB KEY1_pad (.I(KEY1), .O(KEY1_c));   // /disk1/projects/FPGA/Lattice-MXO2-4000HC/Pin/wor_test.v(2[13:17])
    IB KEY2_pad (.I(KEY2), .O(KEY2_c));   // /disk1/projects/FPGA/Lattice-MXO2-4000HC/Pin/wor_test.v(2[19:23])
    IB KEY3_pad (.I(KEY3), .O(KEY3_c));   // /disk1/projects/FPGA/Lattice-MXO2-4000HC/Pin/wor_test.v(2[25:29])
    IB KEY4_pad (.I(KEY4), .O(KEY4_c));   // /disk1/projects/FPGA/Lattice-MXO2-4000HC/Pin/wor_test.v(2[31:35])
    GSR GSR_INST (.GSR(VCC_net));
    LUT4 i32_4_lut (.A(KEY4_c), .B(KEY2_c), .C(KEY3_c), .D(KEY1_c), 
         .Z(BUS)) /* synthesis lut_function=(!(A+(B+(C+(D))))) */ ;   // /disk1/projects/FPGA/Lattice-MXO2-4000HC/Pin/wor_test.v(11[14:18])
    defparam i32_4_lut.init = 16'h0001;
    VHI i34 (.Z(VCC_net));
    
endmodule
//
// Verilog Description of module PUR
// module not written out since it is a black-box. 
//

//
// Verilog Description of module TSALL
// module not written out since it is a black-box. 
//

