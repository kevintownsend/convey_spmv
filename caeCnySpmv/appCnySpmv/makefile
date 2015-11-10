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
	run ../../src/smac/example

vsimrun: $(EXEC)
	run -vsim ../../src/smac/example > vsimRunOutput
	grep @verilog vsimRunOutput > grepedOutput

runcp: example.smac $(EXEC)
	runcp ../../src/smac/example

vim:
	vim -p makefile CnySpmvApp.cpp cpCnySpmv.s

example.smac:
	cp ../../src/smac/example.smac .
