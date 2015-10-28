vsim_mac = work/mac
vsim_mac_tb = work/mac_tb
vsim_intermediator = work/intermediator
vsim_intermediator_tb = work/intermediator_tb
vsim_dual_port_xor_ram = work/dual_port_xor_ram
vsim_dual_port_block_ram = work/dual_port_block_ram
vsim_std_fifo = work/std_fifo
vsim_adder_pipe = work/adder_pipe
vsim_multiplier_pipe = work/multiplier_pipe
vsim_ieee_to_flopoco = work/ieee_to_flopoco
vsim_flopoco_to_ieee = work/flopoco_to_ieee
vsim_InputIEEE_11_52_to_11_52 = work/InputIEEE_11_52_to_11_52
vsim_OutputIEEE_11_52_to_11_52 = work/OutputIEEE_11_52_to_11
vsim_FPMultiplier_11_52_11_52_11_52_uid2 = work/FPMultiplier_11_52_11_52_11_52_uid2
vsim_FPAdder_11_52_uid2 = work/FPAdder_11_52_uid2

run: sim_intermediator

$(vsim_mac) : mac.v work
	vlog mac.v +incdir+../common

$(vsim_mac_tb) : mac_tb.v work
	vlog mac_tb.v +incdir+../common

$(vsim_intermediator) : intermediator.v work
	vlog intermediator.v +incdir+../common

$(vsim_intermediator_tb) : intermediator_tb.v work
	vlog intermediator_tb.v +incdir+../common

$(vsim_dual_port_xor_ram): ../ram/dual_port_xor_ram.v work
	vlog ../ram/dual_port_xor_ram.v +incdir+../common

$(vsim_dual_port_block_ram): ../ram/dual_port_block_ram.v work
	vlog ../ram/dual_port_block_ram.v +incdir+../common

$(vsim_std_fifo) : ../std_fifo/std_fifo.v work
	vlog ../std_fifo/std_fifo.v +incdir+../common

$(vsim_FPMultiplier_11_52_11_52_11_52_uid2) : FPMultiplier_11_52_11_52_11_52_uid2.vhdl work
	vcom FPMultiplier_11_52_11_52_11_52_uid2.vhdl

$(vsim_FPAdder_11_52_uid2): FPAdder_11_52_uid2.vhdl work
	vcom FPAdder_11_52_uid2.vhdl

$(vsim_InputIEEE_11_52_to_11_52): InputIEEE_11_52_to_11_52.vhdl work
	vcom InputIEEE_11_52_to_11_52.vhdl

$(vsim_OutputIEEE_11_52_to_11_52): OutputIEEE_11_52_to_11_52.vhdl work
	vcom OutputIEEE_11_52_to_11_52.vhdl

$(vsim_adder_pipe): adder_pipe.v work
	vlog adder_pipe.v +incdir+../common

$(vsim_multiplier_pipe): multiplier_pipe.v work
	vlog multiplier_pipe.v +incdir+../common

$(vsim_ieee_to_flopoco): ieee_to_flopoco.v work
	vlog ieee_to_flopoco.v +incdir+../common

$(vsim_flopoco_to_ieee): flopoco_to_ieee.v work
	vlog flopoco_to_ieee.v +incdir+../common

work:
	vlib work

sim: work $(vsim_mac) $(vsim_mac_tb) $(vsim_intermediator) $(vsim_dual_port_xor_ram) $(vsim_dual_port_block_ram) $(vsim_std_fifo) $(vsim_adder_pipe) $(vsim_multiplier_pipe) $(vsim_ieee_to_flopoco) $(vsim_flopoco_to_ieee) $(vsim_InputIEEE_11_52_to_11_52) $(vsim_OutputIEEE_11_52_to_11_52) $(vsim_FPMultiplier_11_52_11_52_11_52_uid2) $(vsim_FPAdder_11_52_uid2)
	echo -e "vsim work.mac_tb\nset StdArithNoWarnings 1\nset NumericStdNoWarnings 1\nrun -all" | vsim

sim_intermediator: work $(vsim_intermediator) $(vsim_intermediator_tb) $(vsim_dual_port_xor_ram) $(vsim_dual_port_block_ram) $(vsim_std_fifo)
	echo -e "vsim work.intermediator_tb\nrun -all" | vsim

vim :
	vim -p makefile mac.v mac_tb.v intermediator.v intermediator_tb.v ../ram/dual_port_xor_ram.v ../std_fifo/makefile

clean:
	rm -rf work transcript xst *.prj *.xprt *.ngc _xmsgs *.lso

intermediator.prj:
	echo -e "verilog work intermediator.v\nverilog work ../std_fifo/std_fifo.v\nverilog work ../ram/dual_port_xor_ram.v\nverilog work ../ram/dual_port_block_ram.v" > intermediator.prj

mac.prj:
	echo -e "verilog work intermediator.v\nverilog work ../std_fifo/std_fifo.v\nverilog work ../ram/dual_port_xor_ram.v\nverilog work ../ram/dual_port_block_ram.v\nvhdl work FPAdder_11_52_uid2.vhdl\nvhdl work FPMultiplier_11_52_11_52_11_52_uid2.vhdl\nvhdl work InputIEEE_11_52_to_11_52.vhdl\nvhdl work OutputIEEE_11_52_to_11_52.vhdl\nverilog work flopoco_to_ieee.v\nverilog work ieee_to_flopoco.v\nverilog work multiplier_pipe.v\nverilog work adder_pipe.v\nverilog work mac.v" > mac.prj

xst_mac: mac.prj
	echo "run -ifn mac.prj -ifmt mixed -top mac -ofn mac.ngc -ofmt NGC -p xc5vlx330-2 -opt_mode Speed -opt_level 1 -vlgincdir ../common" | xst

xst: xst_mac

xst_intermediator: intermediator.prj
	echo "run -ifn intermediator.prj -ifmt mixed -top intermediator -ofn intermediator.ngc -ofmt NGC -p xc5vlx330-2 -opt_mode Speed -opt_level 1 -vlgincdir ../common" | xst
