#include <stdio.h>
#include <stdlib.h>
#include <iostream>

using namespace std;

int main(int argc, char* argv[]){
    if(argc != 3){
        cerr << "error in useage" << endl;
        return 1;
    }
    FILE* inputFile = fopen(argv[1], "rb");
    FILE* outputFile = fopen(argv[2], "w");
    for(;;){
        long long int tmp;
        int ret = fread(&tmp, 1, 8, inputFile);
        if(ret != 8)
            break;
        fprintf(outputFile, "%016llX\n", tmp);
    }
    return 0;
}
