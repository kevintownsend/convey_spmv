#!/usr/bin/env python3
import sys
from subprocess import *
import os
import os.path

#TODO: create tmp folder
proc = Popen(["mkdir", "tmp2"])
proc.wait()
os.chdir("tmp2")
#check if zip file exists
if(not os.path.isfile("save0")):
    matrices = ["dw8192", "t2d_q9", "epb1", "raefsky1", "psmigr_2", "torso2"]
    web = ["http://www.cise.ufl.edu/research/sparse/MM/Bai/dw8192.tar.gz", "http://www.cise.ufl.edu/research/sparse/MM/TKK/t2d_q9.tar.gz","http://www.cise.ufl.edu/research/sparse/MM/Averous/epb1.tar.gz","http://www.cise.ufl.edu/research/sparse/MM/Simon/raefsky1.tar.gz","http://www.cise.ufl.edu/research/sparse/MM/HB/psmigr_2.tar.gz","http://www.cise.ufl.edu/research/sparse/MM/Norris/torso2.tar.gz",]
    for i in range(len(matrices)):
        proc = Popen(["wget", web[i]])
        proc.wait()
        proc = Popen(["tar", "-xzf", matrices[i] + ".tar.gz"])
        proc.wait()
        proc = Popen(["mv", matrices[i] + "/" + matrices[i] + ".mtx", "."])
        proc.wait()

    fpgaPerformance = []
    for m in matrices:
        proc = Popen(["mkdir", m])
        proc.wait()
        proc = Popen(["../smac/smac", "-c", "--multipleFiles=64", m + ".mtx", m + "/" + m + ".smac"])
        proc.wait()
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
