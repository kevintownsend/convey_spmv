#include <iostream>
#include <stdio.h>
#include <stdlib.h>
#include <vector>

using namespace std;
typedef unsigned long long ull;

vector<double> check(string mtxFilename, double* xVector);

int main(int argc, char* argv[]){
    if(argc != 3){
        cerr << "used wrong" << endl;
        exit(1);
    }
    vector<double> x;
    x.resize(1000 * 1000);
    for(int i = 0; i < 1000 * 1000; ++i)
        x[i] = i + 1;
    vector<double> y = check(argv[1], &x[0]);
    FILE* resultFile = fopen(argv[2], "w");
    fwrite(&y[0], 8, y.size(), resultFile);
    fclose(resultFile);
}

vector<double> check(string mtxFilename, double* xVector){
    FILE* mtxFile = fopen(mtxFilename.c_str(), "r");
    char line[1000];
    fgets(line, 1000, mtxFile);
    ull M, N, nnz;
    fscanf(mtxFile, "%lld %lld %lld", &M, &N, &nnz);
    cerr << "dim: " << M << ", " << N << endl;
    vector<double> ret;
    ret.resize(M);
    for(ull i = 0; i < nnz; ++i){
        ull row, col;
        double val;
        fscanf(mtxFile, "%lld %lld %lf", &row, &col, &val);
        row--; col--;
        ret[row] += xVector[col] * val;
    }
    fclose(mtxFile);
    return ret;
}
