#!/usr/bin/env python3
from sys import *
from subprocess import *
import os
import os.path

#TODO: create tmp folder
proc = Popen(["mkdir", "tmp"])
os.chdir("tmp")
#check if zip file exists
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
    print(["../smac/smac", "-c", "--multipleFiles=64", m + ".mtx", m + "/" + m + ".smac"])
    proc = Popen(["../smac/smac", "-c", "--multipleFiles=64", m + ".mtx", m + "/" + m + ".smac"])
    proc.wait()
    proc = Popen(["../smac/smac", "-d",  m + "/" + m + ".smac", m + "/" + m + ".mtx"])
    proc.wait()
    print("here0")
    proc = Popen(["export CNY_PERSONALITY_PATH=../../caeCnySpmv/personalities;", "echo hello world"], shell=True)
    proc.wait()
    print("here1")
    my_env = os.environ
    my_env["CNY_PERSONALITY_PATH"] = "../../caeCnySpmv/personalities"
    proc = Popen(["../../caeCnySpmv/appCnySpmv/CnySpmvApp.exe", m + "/" + m, "64"], env=my_env, stdout=PIPE)

    lines = proc.stdout.read().decode('UTF-8').split('\n')

#export CNY_PERSONALITY_PATH=../caeCnySpmv/personalities; ../caeCnySpmv/appCnySpmv/CnySpmvApp.exe tmp/cant/cant 64
    proc.wait()
    print("here2")
    print(lines)
    for line in lines:
        if(line.find(":") != -1):
            splitLine = line.split(':')
            if(splitLine[0].strip() == "performance"):
                fpgaPerformance.append(float(splitLine[1]))
print(matrices)
print(fpgaPerformance)

#TODO: run smac on each matrix
#TODO: run spmv on each matrix
#TODO: collect info
