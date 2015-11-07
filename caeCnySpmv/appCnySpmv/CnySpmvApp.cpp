//TODO: add header information
#include <convey/usr/cny_comp.h>
#include <iostream>
#include <stdlib.h>
#include <stdio.h>

#undef DEBUG

using namespace std;

//typedef unsigned long long uint64;

struct SmacHeader{
    ull r0;
    ull width;
    ull height;
    ull nnz;
    ull spmCodeStreamBitLength;
    ull spmArgumentStreamBitLength;
    ull fzipCodeStreamBitLength;
    ull fzipArgumentStreamBitLength;
    ull r1[8];
    ull spmCodesPtr;
    ull fzipCodesPtr;
    ull commonDoublesPtr;
    ull spmCodeStreamPtr;
    ull spmArgumentStreamPtr;
    ull fzipCodeStreamPtr;
    ull fzipArgumentStreamPtr;
    ull size;
    ull r2[8];
};

//TODO: replace with new assembly function
extern "C" void cpTalk();
extern "C" void cpInstructionAE0();

typedef unsigned long long ull;

void loadRegister(int ae, int pe, int registerAddress, ull value);
int main(int argc, char *argv[])
{
  // check command line args
//TODO: change number of arguments accepted and add usage message
  if (argc != 2)
      return 1;

  // Get personality signature
  // The "pdk" personality is the PDK sample vadd personality
  cny_image_t        sig2;
  cny_image_t        sig;
  int stat;
  if (cny_get_signature)
    cny_get_signature((char*)"CnySpmv", &sig, &sig2, &stat);
  else
    fprintf(stderr,"ERROR:  cny_get_signature not found\n");

  if (stat) {
    printf("***ERROR: cny_get_signature() Failure: %d\n", stat);
    exit(1);
  }

  // check interleave
  // this example requires binary interleave
  if (cny_cp_interleave() == CNY_MI_3131) {
    printf("ERROR - interleave set to 3131, this personality requires binary interleave\n");
    exit (1);
  }

//TODO: replace with own cp call
    cout << "@user:calling coprocessor" << endl;
    copcall_fmt(sig, cpTalk, "");
    cout << "@user:returned from coprocessor" << endl;

    //TODO: read file(s)
    FILE* smacFile = fopen(argv[1], "r");
    ull header[32];
    fread(&header, 8, 32, smacFile);
    fseek(smacFile, 0, SEEK_END);
    ull size2 = ftell(smacFile);
    cerr << "size2: " << size2 << endl;
    rewind(smacFile);
    ull size = header[23];
    cerr << "size: " << size << endl;
    ull* buffer = (ull*)malloc(size);
    fread(buffer, 1, size, smacFile);

    //TODO: move data to coprocessor
    ull* cnyBuffer = (ull*)cny_cp_malloc(size);
    cny_cp_memcpy(cnyBuffer, buffer, size);
    //TODO: load registers
    //TODO: run

    free(buffer);
    return 0;
}

void loadRegister(int ae, int pe, int registerAddress, ull value){
    cerr << "loading " << value << " to register " << registerAddress << " on pe " << pe << " on ae " << ae << endl;
}
