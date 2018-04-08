all: bench_top

bench_top: bench_top.v bench_clock.v clock.v cpu.v cpu_decode2.v cpu_state2.v
	iverilog bench_top.v bench_clock.v clock.v cpu.v cpu_decode2.v cpu_state2.v -o bench_top
	
run: bench_top
	vvp -n bench_top
	
view: bench_top
	vvp -n bench_top
	gtkwave dump.vcd

clean: bench_top
	rm bench_top dump.vcd
