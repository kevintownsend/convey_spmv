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
proc = Popen(["mkdir", "tmp4"])
proc.wait()
os.chdir("tmp4")
#check if zip file exists
if(not os.path.isfile("save0") or force):
    matrices = ["asia_osm", "hugetrace-00010", "road_central", "hugetrace-00020", "hugebubbles-00000", "hugebubbles-00010", "hugebubbles-00020", "road_usa"]
    web = ["http://www.cise.ufl.edu/research/sparse/MM/DIMACS10/asia_osm.tar.gz", "http://www.cise.ufl.edu/research/sparse/MM/DIMACS10/hugetrace-00010.tar.gz", "http://www.cise.ufl.edu/research/sparse/MM/DIMACS10/road_central.tar.gz", "http://www.cise.ufl.edu/research/sparse/MM/DIMACS10/hugetrace-00020.tar.gz", "http://www.cise.ufl.edu/research/sparse/MM/DIMACS10/hugebubbles-00000.tar.gz", "http://www.cise.ufl.edu/research/sparse/MM/DIMACS10/hugebubbles-00010.tar.gz", "http://www.cise.ufl.edu/research/sparse/MM/DIMACS10/hugebubbles-00020.tar.gz", "http://www.cise.ufl.edu/research/sparse/MM/DIMACS10/road_usa.tar.gz"]

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
matrices = ['asia_osm', 'hugetrace-00010', 'road_central', 'hugetrace-00020', 'hugebubbles-00000', 'hugebubbles-00010', 'hugebubbles-00020', 'road_usa']
fpgaPerformance = [9.21535, 7.64019, 6.58708, 7.47223, 7.54086, 7.21172, 7.20562, 7.56024]
#TODO: cpu performance
#TODO: gpu performance
#TODO: M, N, nnz info
