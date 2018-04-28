all: bench_top.v bench_clock.v cpu.v cpu_forward.v cpu_bubble_data.v cpu_alu.v cpu_cond_forward.v rom.v
	iverilog bench_top.v bench_clock.v cpu.v cpu_forward.v cpu_bubble_data.v cpu_alu.v cpu_cond_forward.v rom.v -o bench_top

clean: bench_top dump.vcd
	rm -f bench_top dump.vcd

run: all
	vvp -n bench_top

view: run
	gtkwave dump.vcd
