#TODO: copy rtl
vhdl = caeCnySpmv/vhdl

std_fifo = caeCnySpmv/verilog/std_fifo.v

spmv_pe = caeCnySpmv/verilog/spmv_pe.v
x_vector_cache = caeCnySpmv/verilog/x_vector_cache.v
sparse_matrix_decoder = caeCnySpmv/verilog/sparse_matrix_decoder.v
linked_list_fifo = caeCnySpmv/verilog/linked_list_fifo.v
argument_decoder = caeCnySpmv/verilog/argument_decoder.v
stream_decoder = caeCnySpmv/verilog/stream_decoder.v
variable_length_decoder = caeCnySpmv/verilog/variable_length_decoder.v
mac = caeCnySpmv/verilog/mac.v
multiplier_pipe = caeCnySpmv/verilog/multiplier_pipe.v
adder_pipe = caeCnySpmv/verilog/adder_pipe.v
intermediator = caeCnySpmv/verilog/intermediator.v
FPAdder_11_52_uid2 = caeCnySpmv/vhdl/FPAdder_11_52_uid2.vhdl
FPMultiplier_11_52_11_52_11_52_uid2 = caeCnySpmv/vhdl/FPMultiplier_11_52_11_52_11_52_uid2.vhdl
InputIEEE_11_52_to_11_52 = caeCnySpmv/vhdl/InputIEEE_11_52_to_11_52.vhdl
OutputIEEE_11_52_to_11_52 = caeCnySpmv/vhdl/OutputIEEE_11_52_to_11_52.vhdl
flopoco_to_ieee = caeCnySpmv/verilog/flopoco_to_ieee.v
ieee_to_flopoco = caeCnySpmv/verilog/ieee_to_flopoco.v
dual_port_block_ram = caeCnySpmv/verilog/dual_port_block_ram.v
dual_port_xor_ram = caeCnySpmv/verilog/dual_port_xor_ram.v
asymmetric_fifo = caeCnySpmv/verilog/asymmetric_fifo.v
asymmetric_distributed_ram = caeCnySpmv/verilog/asymmetric_distributed_ram.v
abs = caeCnySpmv/verilog/abs.vh
log2 = caeCnySpmv/verilog/log2.vh
common = caeCnySpmv/verilog/common.vh
scratch_pad = caeCnySpmv/verilog/scratch_pad.v
omega_network_ff = caeCnySpmv/verilog/omega_network_ff.v
basic_switch_ff = caeCnySpmv/verilog/basic_switch_ff.v
linked_fifo = caeCnySpmv/verilog/linked_fifo.v
reorder_queue = caeCnySpmv/verilog/reorder_queue.v
spmv_opcodes = caeCnySpmv/verilog/spmv_opcodes.vh
constants = caeCnySpmv/verilog/constants.vh
simple_ram = caeCnySpmv/verilog/simple_ram.v

copy_rtl: $(std_fifo) $(spmv_pe) $(x_vector_cache) $(sparse_matrix_decoder) $(linked_list_fifo) $(argument_decoder) $(stream_decoder) $(variable_length_decoder) $(mac) $(multiplier_pipe) $(adder_pipe) $(intermediator) $(FPAdder_11_52_uid2) $(FPMultiplier_11_52_11_52_11_52_uid2) $(InputIEEE_11_52_to_11_52) $(OutputIEEE_11_52_to_11_52) $(flopoco_to_ieee) $(ieee_to_flopoco) $(dual_port_block_ram) $(dual_port_xor_ram) $(asymmetric_fifo) $(asymmetric_distributed_ram) $(abs) $(log2) $(common) $(scratch_pad) $(omega_network_ff) $(basic_switch_ff) $(linked_fifo) $(reorder_queue) $(spmv_opcodes) $(constants) $(simple_ram)

$(vhdl):
	mkdir caeCnySpmv/vhdl

$(std_fifo): rtl/std_fifo/std_fifo.v
	cp rtl/std_fifo/std_fifo.v caeCnySpmv/verilog/.

$(spmv_pe): rtl/pe/spmv_pe.v
	cp rtl/pe/spmv_pe.v caeCnySpmv/verilog/.

$(x_vector_cache):
	cp rtl/pe/x_vector_cache.v caeCnySpmv/verilog/.

$(sparse_matrix_decoder): rtl/decoders/sparse_matrix_decoder.v
	cp rtl/decoders/sparse_matrix_decoder.v caeCnySpmv/verilog/.

$(linked_list_fifo): rtl/linked_list_fifo/linked_list_fifo.v
	cp rtl/linked_list_fifo/linked_list_fifo.v caeCnySpmv/verilog/.

$(argument_decoder):
	cp rtl/decoders/argument_decoder.v caeCnySpmv/verilog/.

$(stream_decoder): rtl/decoders/stream_decoder.v
	cp rtl/decoders/stream_decoder.v caeCnySpmv/verilog/.

$(variable_length_decoder):
	cp rtl/decoders/variable_length_decoder.v caeCnySpmv/verilog/.

$(mac):
	cp rtl/mac/mac.v caeCnySpmv/verilog/.

$(multiplier_pipe):
	cp rtl/mac/multiplier_pipe.v caeCnySpmv/verilog/.

$(adder_pipe):
	cp rtl/mac/adder_pipe.v caeCnySpmv/verilog/.

$(intermediator):
	cp rtl/mac/intermediator.v caeCnySpmv/verilog/.

$(FPAdder_11_52_uid2): $(vhdl)
	cp rtl/mac/FPAdder_11_52_uid2.vhdl caeCnySpmv/vhdl/.

$(FPMultiplier_11_52_11_52_11_52_uid2): $(vhdl)
	cp rtl/mac/FPMultiplier_11_52_11_52_11_52_uid2.vhdl caeCnySpmv/vhdl/.

$(InputIEEE_11_52_to_11_52): $(vhdl)
	cp rtl/mac/InputIEEE_11_52_to_11_52.vhdl caeCnySpmv/vhdl/.

$(OutputIEEE_11_52_to_11_52): $(vhdl)
	cp rtl/mac/OutputIEEE_11_52_to_11_52.vhdl caeCnySpmv/vhdl/.

$(flopoco_to_ieee):
	cp rtl/mac/flopoco_to_ieee.v caeCnySpmv/verilog/.

$(ieee_to_flopoco):
	cp rtl/mac/ieee_to_flopoco.v caeCnySpmv/verilog/.

$(dual_port_block_ram):
	cp rtl/ram/dual_port_block_ram.v caeCnySpmv/verilog/.

$(dual_port_xor_ram):
	cp rtl/ram/dual_port_xor_ram.v caeCnySpmv/verilog/.

$(asymmetric_fifo): rtl/asymmetric_fifo/asymmetric_fifo.v
	cp rtl/asymmetric_fifo/asymmetric_fifo.v caeCnySpmv/verilog/.

$(asymmetric_distributed_ram): rtl/ram/asymmetric_distributed_ram.v
	cp rtl/ram/asymmetric_distributed_ram.v caeCnySpmv/verilog/.

$(abs):
	cp rtl/common/abs.vh caeCnySpmv/verilog/.

$(log2):
	cp rtl/common/log2.vh caeCnySpmv/verilog/.

$(common):
	cp rtl/common/common.vh caeCnySpmv/verilog/.

$(scratch_pad):
	cp rtl/inara-hdl-libraries/scratch_pad_b/scratch_pad.v caeCnySpmv/verilog/.

$(omega_network_ff):
	cp rtl/inara-hdl-libraries/multistage_interconnect_network/omega_network_ff.v caeCnySpmv/verilog/.

$(basic_switch_ff):
	cp rtl/inara-hdl-libraries/multistage_interconnect_network/basic_switch_ff.v caeCnySpmv/verilog/.

$(linked_fifo):
	cp rtl/inara-hdl-libraries/linked_fifo/linked_fifo.v caeCnySpmv/verilog/.

$(reorder_queue):
	cp rtl/inara-hdl-libraries/reorder_queue/reorder_queue.v caeCnySpmv/verilog/.

$(spmv_opcodes):
	cp rtl/decoders/spmv_opcodes.vh caeCnySpmv/verilog/.

$(constants):
	cp rtl/inara-hdl-libraries/scratch_pad_b/constants.vh caeCnySpmv/verilog/.

$(simple_ram): rtl/inara-hdl-libraries/common/simple_ram.v
	cp rtl/inara-hdl-libraries/common/simple_ram.v caeCnySpmv/verilog/.

vim:
	vim -p makefile rtl/linked_list_fifo/linked_list_fifo.v caeCnySpmv/sim/CaeIsaCnySpmv.cpp caeCnySpmv/appCnySpmv/CnySpmvApp.cpp caeCnySpmv/verilog/cae_pers.v rtl/std_fifo/std_fifo.v rtl/asymmetric_fifo/asymmetric_fifo.v rtl/ram/asymmetric_distributed_ram.v rtl/decoders/stream_decoder.v rtl/linked_list_fifo/linked_list_fifo.v rtl/pe/spmv_pe.v rtl/decoders/sparse_matrix_decoder.v
