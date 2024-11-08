

qrun:
	rm -rf work

	vlib work
	vmap work work
	vlog -sv -64 -timescale 1ns/1ps -mfcu +acc +nospecify -f filelist.f -csession=incr -statslog work/stats_log 
	vsim -64 -lib work -do "add wave -r /*; run -all" -statslog work/stats_log axis_align_tb -appendlog -l qrun.log -csession=incr
	
