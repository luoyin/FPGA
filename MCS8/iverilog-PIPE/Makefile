all: bench_top.v bench_clock.v cpu.v rom.v
	iverilog bench_top.v bench_clock.v cpu.v rom.v -o bench_top

clean: bench_top dump.vcd
	rm -f bench_top dump.vcd

run: all
	vvp -n bench_top

view: run
	gtkwave dump.vcd
