
TOP=axis_align_tb

qrun:
	rm -rf build; \
	mkdir -p build; \
	cd build; \
	vlib work; \
	vmap work work; \
	vlog -sv -64 -timescale 1ns/1ps -mfcu +acc +nospecify +incdir+../../ ../$(TOP).sv -csession=incr -statslog work/stats_log; \
	vsim -batch -64 -lib work -do "../wave.do" -do "assertion fail -r / -action break; run -all; quit" -statslog work/stats_log $(TOP) -appendlog -l qrun.log -csession=incr;
	
iverilog:
	rm -rf build
	mkdir -p build
	iverilog -g2012 -o a.out ../$(TOP).sv
	vvp a.out
	gtkwave config.gtkw  -f wave.vcd