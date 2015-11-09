//TODO: add header information
#include <convey/usr/cny_comp.h>
#include <iostream>
#include <stdlib.h>
#include <stdio.h>

#undef DEBUG

using namespace std;

//typedef unsigned long long uint64;

//TODO: replace with new assembly function
extern "C" void cpTalk();
extern "C" void cpInstructionAE0();

typedef unsigned long long ull;

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


void loadRegister(int ae, int pe, int registerAddress, ull value);
void loadDeltas(int ae, int pe, ull deltas);
void loadFzipCodes(int ae, int pe, ull fzipCodes);
void loadCommonCodes(int ae, int pe, ull commonCodes);
void steady(int ae, int pe);

cny_image_t        sig2;
cny_image_t        sig;
int main(int argc, char *argv[])
{
    cerr << "staring program" << endl;
  // check command line args
//TODO: change number of arguments accepted and add usage message
  if (argc != 2)
      return 1;

  // Get personality signature
  // The "pdk" personality is the PDK sample vadd personality
  int stat;
  if (cny_get_signature)
    cny_get_signature((char*)"CnySpmv", &sig, &sig2, &stat);
  else
    fprintf(stderr,"ERROR:  cny_get_signature not found\n");

  if (stat) {
    printf("***ERROR: cny_get_signature() Failure: %d\n", stat);
    exit(1);
  }
    cerr << "after signiture" << endl;

  // check interleave
  // this example requires binary interleave
  if (cny_cp_interleave() == CNY_MI_3131) {
    printf("ERROR - interleave set to 3131, this personality requires binary interleave\n");
    exit (1);
  }

//TODO: replace with own cp call
    cerr << "@user:calling coprocessor" << endl;
    copcall_fmt(sig, cpTalk, "");
    cerr << "@user:returned from coprocessor" << endl;

    //TODO: read file(s)
    FILE* smacFile = fopen(argv[1], "r");
    SmacHeader header;
    fread(&header, 8, 32, smacFile);
    fseek(smacFile, 0, SEEK_END);
    ull size2 = ftell(smacFile);
    cerr << "size2: " << size2 << endl;
    rewind(smacFile);
    ull size = header.size;
    cerr << "size: " << size << endl;
    void* buffer = malloc(size);
    fread(buffer, 1, size, smacFile);

    //TODO: move data to coprocessor
    void* cnyBuffer = cny_cp_malloc(size);
    cerr << "cnyBuffer: " << hex << ((ull)cnyBuffer) << endl;
    cerr << dec;
    cny_cp_memcpy(cnyBuffer, buffer, size);
    double* yVector = (double*)cny_cp_malloc(sizeof(ull) * header.height);
    //loadRegister(0, 0, 0, (ull)yVector);
    return 0;

    cerr << "loading deltas" << endl;
    loadDeltas(0, 0, (((ull)cnyBuffer)) + header.spmCodesPtr);
    cerr << "done loading deltas" << endl;
    cerr << "loading fzip codes" << endl;
    loadFzipCodes(0, 0, (((ull)cnyBuffer)) + header.fzipCodesPtr);
    cerr << "done loading fzip codes" << endl;
    cerr << "loading commons" << endl;
    loadCommonCodes(0, 0, (((ull)cnyBuffer)) + header.commonDoublesPtr);
    cerr << "done loading commons" << endl;
    return 0;

    //TODO: load registers
    //TODO: run

    free(buffer);
    free(cnyBuffer);
    free(yVector);
    return 0;
}

struct Instruction{
    enum operation {
        NOP, RST, LD, LD_DELTA_CODES, LD_PREFIX_CODES, LD_COMMON_CODES, STEADY
    }op: 3;
    ull pe : 5;
    ull arg1 : 4;
    ull arg2 : 52;
    Instruction(){}
    Instruction(operation op, ull pe, ull arg1, ull arg2){
        this->op = op;
        this->pe = pe;
        this->arg1 = arg1;
        this->arg2 = arg2;
    }
    Instruction(operation op, ull pe){
        this->op = op;
        this->pe = pe;
        this->arg1 = 0;
        this->arg2 = 0;
    }
    /*
    Instruction(ull raw){
        *this = *(*Instruction)&raw;
    }
    */
};
void sendInstruction(int ae, Instruction i){
    copcall_fmt(sig, cpInstructionAE0, "A", *(ull*)&i);
}

void loadRegister(int ae, int pe, int registerAddress, void* value){
    loadRegister(ae, pe, registerAddress, *(ull*)&value);
}
void loadRegister(int ae, int pe, int registerAddress, int value){
    loadRegister(ae, pe, registerAddress, (ull)value);
}
void loadDeltas(int ae, int pe, ull deltas){
    loadRegister(ae, pe, 4, deltas);
    loadRegister(ae, pe, 8, (ull)deltas + (ull)(8*pow((double)2, (double)7)));
    loadRegister(ae, pe, 5, 0);
    loadRegister(ae, pe, 9, (ull)(8*pow((double)2, (double)7)));
    sendInstruction(ae, Instruction(Instruction::LD_DELTA_CODES, pe));
}
void loadFzipCodes(int ae, int pe, ull fzipCodes){
    loadRegister(ae, pe, 4, fzipCodes);
    loadRegister(ae, pe, 8, (ull)fzipCodes + (ull)(2*8*pow((double)2, (double)9)));
    loadRegister(ae, pe, 5, 0);
    loadRegister(ae, pe, 9, (ull)(2*8*pow((double)2, (double)9)));
    sendInstruction(ae, Instruction(Instruction::LD_PREFIX_CODES, pe));
}
void loadCommonCodes(int ae, int pe, ull commonCodes){
    loadRegister(ae, pe, 4, commonCodes);
    loadRegister(ae, pe, 8, (ull)commonCodes + (ull)(8*pow((double)2, (double)13)));
    loadRegister(ae, pe, 5, 0);
    loadRegister(ae, pe, 9, (ull)(8*pow((double)2, (double)13)));
    sendInstruction(ae, Instruction(Instruction::LD_COMMON_CODES, pe));
}
void steady(int ae, int pe){
}

void loadRegister(int ae, int pe, int registerAddress, ull value){
    cerr << "loading " << value << " to register " << registerAddress << " on pe " << pe << " on ae " << ae << endl;
    Instruction tmp;
    tmp.op = Instruction::LD;
    tmp.pe = pe;
    tmp.arg1 = registerAddress;
    tmp.arg2 = value;

    sendInstruction(ae, tmp);
}
