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
proc = Popen(["mkdir", "tmp5"])
proc.wait()
os.chdir("tmp5")
#check if zip file exists
if(not os.path.isfile("save0") or force):
    matrices = ["uk-2005", "webbase-2001", "it-2004", "sk-2005"]
    web = ["http://www.cise.ufl.edu/research/sparse/MM/LAW/uk-2005.tar.gz", "http://www.cise.ufl.edu/research/sparse/MM/LAW/webbase-2001.tar.gz", "http://www.cise.ufl.edu/research/sparse/MM/LAW/it-2004.tar.gz", "http://www.cise.ufl.edu/research/sparse/MM/LAW/sk-2005.tar.gz"]

    fpgaPerformance = []
    for i in range(len(matrices)):
        if(not os.path.isfile(web[i].split("/")[-1])):
            proc = Popen(["wget", web[i]])
            proc.wait()
        proc = Popen(["tar", "-xzf", matrices[i] + ".tar.gz"])
        proc.wait()
        proc = Popen(["mv", matrices[i] + "/" + matrices[i] + ".mtx", "."])
        proc.wait()

        m = matrices[i]
        proc = Popen(["mkdir", m])
        proc.wait()
        proc = Popen(["../smac/smac", "-c", "--multipleFiles=64", m + ".mtx", m + "/" + m + ".smac"])
        rc = proc.wait()
        if(rc == 2):
            print("smac returned an error")
            save0File = open("save0","w")
            save0File.write(str(matrices) + "\n")
            save0File.write(str(fpgaPerformance) + "\n")
            save0File.close()
            exit(1)
        #proc = Popen(["../smac/smac", "-d",  m + "/" + m + ".smac", m + "/" + m + ".mtx"])
        #proc.wait()
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
        if(clean):
            proc = Popen(["rm", "-rf", m])
            proc.wait()
            proc = Popen(["rm", m + ".mtx"])
            proc.wait()
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
#TODO: cpu performance
#TODO: gpu performance
#TODO: M, N, nnz info
