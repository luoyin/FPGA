all: bench_top.v bench_clock.v rom1.v rom2.v
	iverilog bench_top.v bench_clock.v rom1.v rom2.v -o bench_top

clean: bench_top dump.vcd
	rm -f bench_top dump.vcd
	
run: all
	vvp -n bench_top
	
view: run
	gtkwave dump.vcd
