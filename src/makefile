all: example.hex

vim:
	vim -p makefile getBenchmarkResults.py binToHex.cpp

binToHex: binToHex.cpp
	g++ -o binToHex binToHex.cpp

spmvResult: spmvResult.cpp
	g++ -o spmvResult spmvResult.cpp

example.hex: binToHex smac/example.smac
	binToHex smac/example.smac example.hex

run:
	getBenchmarkResults.py
