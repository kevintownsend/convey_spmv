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
