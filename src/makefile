all: example.hex exampleResult.hex

vim:
	vim -p makefile getBenchmarkResults.py decomposeMtx.cpp binToHex.cpp

binToHex: binToHex.cpp
	g++ -o binToHex binToHex.cpp

spmvResult: spmvResult.cpp
	g++ -o spmvResult spmvResult.cpp

example.hex: binToHex smac/example.smac
	binToHex smac/example.smac example.hex

exampleResult.bin: spmvResult
	spmvResult smac/example.mtx exampleResult.bin

exampleResult.hex: binToHex exampleResult.bin
	binToHex exampleResult.bin exampleResult.hex

decomposeMtx: decomposeMtx.cpp
	g++ -O3 -o decomposeMtx decomposeMtx.cpp

run: decomposeMtx
	decomposeMtx smac/example.mtx exampleVal.hex
