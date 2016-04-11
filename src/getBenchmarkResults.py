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

if(not os.path.isfile("save0") or force):
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
    fpgaPerformance = []
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
        proc = Popen(["export CNY_PERSONALITY_PATH=../../caeCnySpmv/personalities;", "echo hello world"], shell=True)
        proc.wait()
        my_env = os.environ
        my_env["CNY_PERSONALITY_PATH"] = "../../caeCnySpmv/personalities"
        proc = Popen(["../../caeCnySpmv/appCnySpmv/CnySpmvApp.exe", m + "/" + m, "64"], env=my_env, stdout=PIPE)

        lines = proc.stdout.read().decode('UTF-8').split('\n')
        proc.wait()
        for line in lines:
            if(line.find(":") != -1):
                splitLine = line.split(':')
                if(splitLine[0].strip() == "performance"):
                    fpgaPerformance.append(float(splitLine[1]))
    save0File = open("save0","w")
    save0File.write(str(matrices) + "\n")
    save0File.write(str(fpgaPerformance) + "\n")
    save0File.close()
#TODO: collect info
save0File = open("save0", "r")
matrices=eval(save0File.readline())
fpgaPerformance=eval(save0File.readline())
print(matrices)
print(fpgaPerformance)

if(clean):
    for m in matrices:
        proc = Popen(["rm", "-rf", m])
        proc.wait()
        proc = Popen(["rm", m + ".mtx"])
        proc.wait()


matrices = ['cant', 'consph', 'cop20k_A', 'dense2', 'mac_econ_fwd500', 'mc2depi', 'pdb1HYS', 'pwtk', 'qcd5_4', 'rail4284', 'rma10', 'scircuit', 'shipsec1', 'webbase-1M']
fpgaPerformance = [15.4685, 11.0508, 7.16309, 13.1724, 8.95098, 8.88138, 7.21356, 11.2453, 13.8175, 15.3648, 13.9297, 6.925, 16.3397, 8.37901]
#TODO: cpu performance
#TODO: gpu performance
#TODO: M, N, nnz info
gtx680 = [15.1, 12.6, 5.1, -1, 5.1, 10.9, 12.5, 11.4, 21.2, 6.2, 8.2, 4.7, 10.4, 4.6]

intel = [11.3, 7.7, 9.9, -1, 7.0, 6.0, 11.7, 7.5, 11.0, 7.2, 12.4, 4.5, 10.0, 4.0]

nnz = [4007383, 6010480, 2624331, 4000000, 1273389, 2100225, 4344765, 11634424, 1916928, 11284032, 2374001, 958936, 3977139, 3105536]

table = [matrices, nnz, gtx680, intel, fpgaPerformance]

#TODO: remove dense matrix
table = []
for i in range(len(matrices)):
    if(matrices[i] != "dense2"):
        table.append([matrices[i], nnz[i], intel[i], gtx680[i], fpgaPerformance[i]])

table.sort(key=lambda a: a[1])


print(table)

#TODO: sort 
