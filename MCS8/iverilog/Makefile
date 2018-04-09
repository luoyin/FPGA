all: bench_top

bench_top: bench_top.v bench_clock.v clock.v cpu.v cpu_decode.v cpu_state2.v cpu_regbank.v cpu_regtemp.v cpu_stack.v cpu_alu.v rom.v
	iverilog bench_top.v bench_clock.v clock.v cpu.v cpu_decode.v cpu_state2.v cpu_regbank.v cpu_regtemp.v cpu_stack.v cpu_alu.v rom.v -o bench_top
	
run: bench_top
	vvp -n bench_top
	
view: bench_top
	vvp -n bench_top
	gtkwave dump.vcd

clean: bench_top
	rm bench_top dump.vcd
