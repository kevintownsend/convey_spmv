# Makefile $Header: /cvs/cae_vadd/phys/Makefile,v 1.6 2010/12/15 20:27:48 gedwards Exp $


CNY_PDK_PHYS_DIR ?= ../phys_constraints
NICE		?= nice -n0

XILINX_MAP_OPTIONS += -register_duplication on -lc off -logic_opt on -global_opt speed
XILINX_THREADS += 4

####################################################################
# Include Convey Makefile Template
####################################################################
include ../Makefile.include

SILENT ?= .SILENT   # Allow Override of Silent

$(SILENT):
