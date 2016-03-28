#!/usr/bin/env python3
from sys import *
from subprocess import *
import os
import os.path

force = False
clean = False

print(argv)
for currArg in argv:
    if(currArg[0:2] == "--"):
        if(currArg[2:] == "force"):
            force = True
        if(currArg[2:] == "clean"):
            clean = True

#TODO: create tmp folder
proc = Popen(["mkdir", "tmp"])
proc.wait()
os.chdir("tmp")
#check if zip file exists

if(not os.path.isfile("mac_save0") or force):
    if(not os.path.isfile("matrices.zip")):
        proc = Popen(["wget", "http://www.nvidia.com/content/NV_Research/matrices.zip"])
        proc.wait()
#get list of matrices
    proc = Popen(["unzip", "-l", "-qq", "matrices.zip"], stdout=PIPE)
    line = proc.stdout.read().decode('UTF-8')
    proc.wait()
    splitLine = line.split()

    proc = Popen(["unzip", "-qq", "-o", "matrices.zip"])
    proc.wait()
    matrices = []
    for i in range(len(splitLine)):
        if(i % 4 == 3):
            filename = splitLine[i]
            if(filename.endswith(".mtx")):
                matrices.append(filename[:-4])
    print(matrices)
    macStall = []
    nnzValues = []
    for m in matrices:
        proc = Popen(["mkdir", m])
        proc.wait()
        proc = Popen(["../smac/smac", "-c", "--multipleFiles=64", m + ".mtx", m + "/" + m + ".smac"])
        rc = proc.wait()
        if(rc == 2):
            print("smac returned an error")
            exit(1)
        proc = Popen(["../smac/smac", "-d",  m + "/" + m + ".smac", m + "/" + m + ".mtx"])
        proc.wait()

        os.chdir("../../rtl/mac")
        proc0 = Popen(["echo", "-e", "vsim -gMATRIX_FILENAME=\"../../src/tmp/" + m + "/" + m + ".mtx\" work.mac_tb\nset StdArithNoWarnings 1\nset NumericStdNoWarnings 1\nrun -all"], stdout=PIPE)
        proc1 = Popen(["vsim"], stdin=proc0.stdout , stdout=PIPE)
        lines = proc1.stdout.read().decode('UTF-8').split('\n')
        proc1.wait()
        os.chdir("../../src/tmp")

        for line in lines:
            print(line)
            if "@verilog:stall_count" in line:
                line = line.split(":")
                macStall.append(int(line[2]))
                nnzValues.append(int(line[3]))
    save0File = open("mac_save0","w")
    save0File.write(str(matrices) + "\n")
    save0File.write(str(macStall) + "\n")
    save0File.write(str(nnzValues) + "\n")
    save0File.close()
#TODO: collect info
save0File = open("mac_save0", "r")
matrices=eval(save0File.readline())
macStall=eval(save0File.readline())
nnzValues=eval(save0File.readline())
print(matrices)
print(macStall)
print(nnzValues)

if(clean):
    for m in matrices:
        proc = Popen(["rm", "-rf", m])
        proc.wait()
        proc = Popen(["rm", m + ".mtx"])
        proc.wait()


#TODO: cpu performance
#TODO: gpu performance
#TODO: M, N, nnz info
