module wor_test(KEY1, KEY2, KEY3, KEY4, LED1);
	input wire KEY1, KEY2, KEY3, KEY4;
	output wire LED1;
	
	wor BUS;
	assign BUS=KEY1;
	assign BUS=KEY2;
	assign BUS=KEY3;
	assign BUS=KEY4;
	
	assign LED1=~BUS;

endmodule
