#include <iostream>
#include <stdio.h>
#include <stdlib.h>
#include <string>
#include <vector>

using namespace std;

char line[1001];

typedef unsigned long long ull;

int main(int argc, char* argv[]){
    if(argc != 3){
        cerr << "Usage: wrong" << endl;
        exit(1);
    }

    FILE* inputFile = fopen(argv[1], "r");
    fgets(line, 1000, inputFile);
    ull M, N, nnz;
    fscanf(inputFile, "%lld%lld%lld", &M, &N, &nnz);
    vector<double> val;
    for(int i = 0; i < nnz; ++i){
        ull tmp1, tmp2;
        double tmp3;
        fscanf(inputFile, "%lld%lld%lf", &tmp1, &tmp2, &tmp3);
        tmp1--; tmp2--;
        val.push_back(tmp3);
    }
    fclose(inputFile);

    FILE* valHexFile = fopen(argv[2], "w");
    for(int i = 0; i < val.size(); ++i){
        fprintf(valHexFile, "%016llX\n", *((ull*)&val[i]));
    }
    //TODO: read matrix
    //TODO: output value hex file
}
