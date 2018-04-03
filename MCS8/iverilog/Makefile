all: bench_top

bench_top: bench_top.v bench_clock.v
	iverilog bench_top.v bench_clock.v clock.v -o bench_top
	
run: bench_top
	vvp -n bench_top
	
view: bench_top
	vvp -n bench_top
	gtkwave dump.vcd
