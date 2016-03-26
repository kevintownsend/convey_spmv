#!/usr/bin/env python3
from sys import *
from subprocess import *
import os
import os.path

#TODO: create tmp folder
proc = Popen(["mkdir", "tmp3"])
proc.wait()
os.chdir("tmp3")
#check if zip file exists
if(not os.path.isfile("save0")):
    #matrices = ["hollywood-2009", "Flan_1565", "HV15R", "kron_g500-logn21", "indochina-2004"]
    #web = ["http://www.cise.ufl.edu/research/sparse/MM/LAW/hollywood-2009.tar.gz", "http://www.cise.ufl.edu/research/sparse/MM/Janna/Flan_1565.tar.gz", "http://www.cise.ufl.edu/research/sparse/MM/Fluorem/HV15R.tar.gz"]
    matrices = ["wikipedia-20061104", "spal_004", "ldoor", "nlpkkt120", "boneS10", "cage15", "nlpkkt160", "nlpkkt200"]
    web = ["http://www.cise.ufl.edu/research/sparse/MM/Gleich/wikipedia-20061104.tar.gz", "http://www.cise.ufl.edu/research/sparse/MM/Mittelmann/spal_004.tar.gz", "http://www.cise.ufl.edu/research/sparse/MM/GHS_psdef/ldoor.tar.gz", "http://www.cise.ufl.edu/research/sparse/MM/Schenk/nlpkkt120.tar.gz", "http://www.cise.ufl.edu/research/sparse/MM/Oberwolfach/boneS10.tar.gz", "http://www.cise.ufl.edu/research/sparse/MM/vanHeukelum/cage15.tar.gz", "http://www.cise.ufl.edu/research/sparse/MM/Schenk/nlpkkt160.tar.gz", "http://www.cise.ufl.edu/research/sparse/MM/Schenk/nlpkkt200.tar.gz"]

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
#TODO: cpu performance
#TODO: gpu performance
#TODO: M, N, nnz info
