#!/usr/bin/env python3
from sys import *
from subprocess import *
import os
import os.path

#TODO: create tmp folder
proc = Popen(["mkdir", "tmp"])
proc.wait()
os.chdir("tmp")
#check if zip file exists

if(not os.path.isfile("save0")):
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
#TODO: cpu performance
#TODO: gpu performance
#TODO: M, N, nnz info
