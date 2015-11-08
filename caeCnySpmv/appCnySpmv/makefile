EXEC = CnySpmvApp.exe
SWMODEL = ../sim/CaeSimPers

all:	$(EXEC) $(SWMODEL)

clean:
	rm -f $(EXEC)
	make --directory=../sim clean

$(EXEC):	CnySpmvApp.cpp cpCnySpmv.s
	cnyCC -g CnySpmvApp.cpp cpCnySpmv.s -o CnySpmvApp.exe

$(SWMODEL): ../Makefile.include ../sim/CaeIsaCnySpmv.cpp
	make -C ../sim

run: example.smac $(EXEC)
	run example.smac

vsimrun: $(EXEC)
	run -vsim example.smac > vsimRunOutput
	grep @verilog vsimRunOutput > grepedOutput

vim:
	vim -p makefile CnySpmvApp.cpp cpCnySpmv.s

example.smac:
	cp ../../src/smac/example.smac .
