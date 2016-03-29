vsim_x_vector_cache = work/x_vector_cache
vsim_x_vector_cache_tb = work/x_vector_cache_tb
vsim_spmv_pe = work/spmv_pe
vsim_spmv_pe_tb = work/spmv_pe_tb

vsim_variable_length_decoder=work/variable_length_decoder
vsim_argument_decoder=work/argument_decoder
vsim_asymmetric_fifo = work/asymmetric_fifo
vsim_asymmetric_distributed_ram = work/asymmetric_distributed_ram
vsim_stream_decoder = work/stream_decoder
vsim_sparse_matrix_decoder = work/sparse_matrix_decoder
vsim_linked_list_fifo = work/linked_list_fifo
vsim_std_fifo = work/std_fifo

vsim_mac = work/mac
vsim_intermediator = work/intermediator
vsim_dual_port_xor_ram = work/dual_port_xor_ram
vsim_dual_port_block_ram = work/dual_port_block_ram
vsim_adder_pipe = work/adder_pipe
vsim_multiplier_pipe = work/multiplier_pipe
vsim_ieee_to_flopoco = work/ieee_to_flopoco
vsim_flopoco_to_ieee = work/flopoco_to_ieee
vsim_InputIEEE_11_52_to_11_52 = work/InputIEEE_11_52_to_11_52
vsim_OutputIEEE_11_52_to_11_52 = work/OutputIEEE_11_52_to_11
vsim_FPMultiplier_11_52_11_52_11_52_uid2 = work/FPMultiplier_11_52_11_52_11_52_uid2
vsim_FPAdder_11_52_uid2 = work/FPAdder_11_52_uid2
vsim_in_flight_tracker = work/in_flight_tracker

$(vsim_x_vector_cache): work x_vector_cache.v
	vlog x_vector_cache.v +incdir+../common

$(vsim_x_vector_cache_tb): work x_vector_cache_tb.v
	vlog x_vector_cache_tb.v +incdir+../common

$(vsim_spmv_pe): work spmv_pe.v
	vlog spmv_pe.v +incdir+../common +incdir+../decoders

$(vsim_spmv_pe_tb): work spmv_pe_tb.v
	vlog spmv_pe_tb.v +incdir+../common +incdir+../decoders

$(vsim_std_fifo): work ../std_fifo/std_fifo.v
	vlog ../std_fifo/std_fifo.v +incdir+../common

$(vsim_variable_length_decoder): ../decoders/variable_length_decoder.v
	vlog ../decoders/variable_length_decoder.v +incdir+../common

$(vsim_argument_decoder): ../decoders/argument_decoder.v work
	vlog ../decoders/argument_decoder.v +incdir+../common

$(vsim_asymmetric_fifo): work ../asymmetric_fifo/asymmetric_fifo.v
	vlog ../asymmetric_fifo/asymmetric_fifo.v +incdir+../common

$(vsim_asymmetric_distributed_ram): work ../ram/asymmetric_distributed_ram.v
	vlog ../ram/asymmetric_distributed_ram.v +incdir+../common

$(vsim_stream_decoder): work ../decoders/stream_decoder.v
	vlog ../decoders/stream_decoder.v +incdir+../common

$(vsim_sparse_matrix_decoder): work ../decoders/sparse_matrix_decoder.v
	vlog ../decoders/sparse_matrix_decoder.v +incdir+../common +incdir+../decoders

$(vsim_linked_list_fifo): work ../linked_list_fifo/linked_list_fifo.v
	vlog ../linked_list_fifo/linked_list_fifo.v +incdir+../common

$(vsim_mac) : ../mac/mac.v work
	vlog ../mac/mac.v +incdir+../common

$(vsim_intermediator) : ../mac/intermediator.v work
	vlog ../mac/intermediator.v +incdir+../common

$(vsim_dual_port_xor_ram): ../ram/dual_port_xor_ram.v work
	vlog ../ram/dual_port_xor_ram.v +incdir+../common

$(vsim_dual_port_block_ram): ../ram/dual_port_block_ram.v work
	vlog ../ram/dual_port_block_ram.v +incdir+../common

$(vsim_FPMultiplier_11_52_11_52_11_52_uid2) : ../mac/FPMultiplier_11_52_11_52_11_52_uid2.vhdl work
	vcom ../mac/FPMultiplier_11_52_11_52_11_52_uid2.vhdl

$(vsim_FPAdder_11_52_uid2): ../mac/FPAdder_11_52_uid2.vhdl work
	vcom ../mac/FPAdder_11_52_uid2.vhdl

$(vsim_InputIEEE_11_52_to_11_52): ../mac/InputIEEE_11_52_to_11_52.vhdl work
	vcom ../mac/InputIEEE_11_52_to_11_52.vhdl

$(vsim_OutputIEEE_11_52_to_11_52): ../mac/OutputIEEE_11_52_to_11_52.vhdl work
	vcom ../mac/OutputIEEE_11_52_to_11_52.vhdl

$(vsim_adder_pipe): ../mac/adder_pipe.v work
	vlog ../mac/adder_pipe.v +incdir+../common

$(vsim_multiplier_pipe): ../mac/multiplier_pipe.v work
	vlog ../mac/multiplier_pipe.v +incdir+../common

$(vsim_ieee_to_flopoco): ../mac/ieee_to_flopoco.v work
	vlog ../mac/ieee_to_flopoco.v +incdir+../common

$(vsim_flopoco_to_ieee): ../mac/flopoco_to_ieee.v work
	vlog ../mac/flopoco_to_ieee.v +incdir+../common

$(vsim_in_flight_tracker): ../decoders/in_flight_tracker.v work
	vlog ../decoders/in_flight_tracker.v +incdir+../common

work:
	vlib work

sim_x_vector: work $(vsim_x_vector_cache) $(vsim_x_vector_cache_tb) $(vsim_std_fifo)
	echo -e "vsim work.x_vector_cache_tb\nrun -all" | vsim

sim_spmv_pe: work $(vsim_spmv_pe) $(vsim_spmv_pe_tb) $(vsim_x_vector_cache) $(vsim_std_fifo) $(vsim_variable_length_decoder) $(vsim_argument_decoder) $(vsim_asymmetric_fifo) $(vsim_asymmetric_distributed_ram) $(vsim_stream_decoder) $(vsim_sparse_matrix_decoder) $(vsim_linked_list_fifo) $(vsim_mac) $(vsim_intermediator) $(vsim_dual_port_xor_ram) $(vsim_dual_port_block_ram) $(vsim_FPMultiplier_11_52_11_52_11_52_uid2) $(vsim_FPAdder_11_52_uid2) $(vsim_InputIEEE_11_52_to_11_52) $(vsim_OutputIEEE_11_52_to_11_52) $(vsim_adder_pipe) $(vsim_multiplier_pipe) $(vsim_ieee_to_flopoco) $(vsim_flopoco_to_ieee) $(vsim_in_flight_tracker) example.hex exampleResult.hex
	echo -e "vsim work.spmv_pe_tb\nset StdArithNoWarnings 1\nset NumericStdNoWarnings 1\nrun -all" | vsim

example.hex: ../../src/example.hex
	cp ../../src/example.hex .

exampleResult.hex: ../../src/exampleResult.hex
	cp ../../src/exampleResult.hex .

sim: sim_spmv_pe

vim :
	vim -p makefile spmv_pe.v spmv_pe_tb.v ../decoders/sparse_matrix_decoder.v ../decoders/spmv_opcodes.vh x_vector_cache.v x_vector_cache_tb.v ../mac/mac.v

clean:
	rm -rf work transcript

x_vector_cache.prj:
	echo -e "verilog work x_vector_cache.v\nverilog work ../std_fifo/std_fifo.v" > x_vector_cache.prj

x_vector_cache_xst : x_vector_cache.prj
	echo "run -ifn x_vector_cache.prj -ifmt mixed -top x_vector_cache -ofn x_vector_cache.ngc -ofmt NGC -p xc5vlx330-2FF1760 -opt_mode Speed -opt_level 1 -vlgincdir ../common" | xst

x_vector_cache_post_par.par: x_vector_cache_xst
	ngdbuild x_vector_cache
	map x_vector_cache
	par x_vector_cache x_vector_cache_post_par

cache_xst: x_vector_cache_post_par.par

spmv_pe.prj:
	echo -e "verilog work spmv_pe.v\nverilog work ../std_fifo/std_fifo.v\nverilog work x_vector_cache.v\nverilog work ../decoders/variable_length_decoder.v\nverilog work ../decoders/argument_decoder.v\nverilog work ../asymmetric_fifo/asymmetric_fifo.v\nverilog work ../ram/asymmetric_distributed_ram.v\nverilog work ../decoders/stream_decoder.v\nverilog work ../decoders/sparse_matrix_decoder.v\nverilog work ../linked_list_fifo/linked_list_fifo.v\nverilog work ../mac/mac.v\nverilog work ../mac/intermediator.v\nverilog work ../ram/dual_port_xor_ram.v\nverilog work ../ram/dual_port_block_ram.v\nvhdl work ../mac/FPMultiplier_11_52_11_52_11_52_uid2.vhdl\nvhdl work ../mac/FPAdder_11_52_uid2.vhdl\nvhdl work ../mac/InputIEEE_11_52_to_11_52.vhdl\nvhdl work ../mac/OutputIEEE_11_52_to_11_52.vhdl\nverilog work ../mac/adder_pipe.v\nverilog work ../mac/multiplier_pipe.v\nverilog work ../mac/ieee_to_flopoco.v\nverilog work ../mac/flopoco_to_ieee.v\nverilog work ../decoders/in_flight_tracker.v" > spmv_pe.prj

spmv_pe_xst : spmv_pe.prj
	echo "run -ifn spmv_pe.prj -ifmt mixed -top spmv_pe -ofn spmv_pe.ngc -ofmt NGC -p xc5vlx330-2FF1760 -opt_mode Speed -opt_level 1 -vlgincdir ../common" | xst

spmv_pe_post_par.par: spmv_pe_xst
	ngdbuild spmv_pe
	map -w spmv_pe
	par -w spmv_pe spmv_pe_post_par
	trce -a -v -l 100 -n spmv_pe_post_par

pe_xst: spmv_pe_post_par.par



