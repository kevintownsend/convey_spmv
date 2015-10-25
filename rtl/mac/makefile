vsim_mac = work/mac
vsim_mac_tb = work/mac_tb
vsim_intermediator = work/intermediator
vsim_intermediator_tb = work/intermediator_tb
vsim_dual_port_xor_ram = work/dual_port_xor_ram
vsim_dual_port_block_ram = work/dual_port_block_ram
vsim_std_fifo = work/std_fifo

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

work:
	vlib work

sim: work $(vsim_mac) $(vsim_mac_tb) $(vsim_intermediator) $(vsim_dual_port_xor_ram) $(vsim_dual_port_block_ram)

sim_intermediator: work $(vsim_intermediator) $(vsim_intermediator_tb) $(vsim_dual_port_xor_ram) $(vsim_dual_port_block_ram) $(vsim_std_fifo)
	echo -e "vsim work.intermediator_tb\nrun -all" | vsim

vim :
	vim -p makefile mac.v mac_tb.v intermediator.v intermediator_tb.v ../ram/dual_port_xor_ram.v

clean:
	rm -rf work transcript
