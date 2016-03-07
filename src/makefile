all: example.hex exampleResult.hex

vim:
<<<<<<< HEAD
	vim -p makefile getBenchmarkResults.py binToHex.cpp
=======
	vim -p makefile getBenchmarkResults.py decomposeMtx.cpp binToHex.cpp
>>>>>>> fab19ee7a5be516a6b021c08415ec8c173644f47

binToHex: binToHex.cpp
	g++ -o binToHex binToHex.cpp

spmvResult: spmvResult.cpp
	g++ -o spmvResult spmvResult.cpp

example.hex: binToHex smac/example.smac
	binToHex smac/example.smac example.hex

<<<<<<< HEAD
run:
=======
exampleResult.bin: spmvResult
	spmvResult smac/example.mtx exampleResult.bin

exampleResult.hex: binToHex exampleResult.bin
	binToHex exampleResult.bin exampleResult.hex

decomposeMtx: decomposeMtx.cpp
	g++ -O3 -o decomposeMtx decomposeMtx.cpp

run: getBenchmarkResults.py
>>>>>>> fab19ee7a5be516a6b021c08415ec8c173644f47
	getBenchmarkResults.py
