all: example.hex

vim:
	vim -p makefile binToHex.cpp

binToHex: binToHex.cpp
	g++ -o binToHex binToHex.cpp

example.hex: binToHex smac/example.smac
	binToHex smac/example.smac example.hex
