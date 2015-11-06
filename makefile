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

copy_rtl: $(std_fifo)

$(vhdl):
	mkdir caeCnySpmv/vhdl

$(std_fifo):
	cp rtl/std_fifo/std_fifo.v caeCnySpmv/verilog/.
