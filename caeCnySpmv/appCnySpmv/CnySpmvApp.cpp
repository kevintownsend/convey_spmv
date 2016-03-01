//TODO: add header information
#include <convey/usr/cny_comp.h>
#include <iostream>
#include <stdlib.h>
#include <stdio.h>
#include <vector>
#include "tardis/tardis.h"

#undef DEBUG

using namespace std;

//typedef unsigned long long uint64;
typedef unsigned long long ull;
typedef long long ll;

//TODO: replace with new assembly function
extern "C" void cpTalk();
extern "C" long cpInstructionAE0();
extern "C" long cpInstructionAE1();
extern "C" long cpInstructionAE2();
extern "C" long cpInstructionAE3();
extern "C" long cpInstructionAEall();

const string registerNames[] = {"y vector address begin", "y vector address end", "x vector start", "mac nnz count down", "index opcodes steam", "index arguments stream", "fzip opocdes stream" , "fzip arguments stream", "index opcodes end address", "index arguments end address", "fzip opcodes end address", "fzip arguments end address", "index nnz count down", "fzip nnz count down"};

const string debugRegisterNames[] = {"flags", "MAC stalls", "matrix value hold up", "x values hold up", "row indices hold up", "RESERVED", "RESERVED", "RESERVED"};

    //0: index opcodes stream
    //1: index argument stream
    //2: fzip opcode stream
    //3: fzip argument stream
    //4: index opcodes end
    //5: index argument end
    //6: fzip opcode end
    //7: fzip argument end
    //8: index nnz count down
    //9: fzip nnz count down
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
vector<double> check(string mtxFilename, double* xVector);
void steadyPart1(int ae, int pe, ull matrixData, SmacHeader matrixHeader, ull xPtr, ull yPtr);
void steadyPart2(int ae, int pe);
void reset(int ae, int pe);
void resetAll();
ull readRegister(int ae, int pe, int registerAddress);
vector<ull> printRegisters(int ae, int pe);
vector<vector<ull> > printRegisters();
vector<vector<ull> > printRegisters(int count);
void discoverProblemPEs(vector<vector<ull> > PEs);
vector<vector<ull> > getDebugRegisters(int count);
void printDebugInfo(vector<vector<ull> > debugRegisters);

char charBuffer[100];

cny_image_t        sig2;
cny_image_t        sig;
int main(int argc, char *argv[])
{
    cerr << "staring program" << endl;
  // check command line args
//TODO: change number of arguments accepted and add usage message
  if (argc < 2)
      return 1;
  string argument(argv[1]);
  cerr << argument << endl;
  cerr << (argument + ".smac") << endl;

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
    //reset
    //reset(0,0);
    resetAll();

    //TODO: read file(s)
    FILE* smacFile = fopen((argument + ".smac").c_str(), "r");
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
    fclose(smacFile);

    //TODO: move data to coprocessor
    void* cnyBuffer = cny_cp_malloc(size);
    cerr << "cnyBuffer: " << hex << ((ull)cnyBuffer) << endl;
    cerr << dec;
    cny_cp_memcpy(cnyBuffer, buffer, size);
    double* yVector = (double*)cny_cp_malloc(sizeof(ull) * header.height);
    double* xVector = (double*)cny_cp_malloc(sizeof(ull) * header.width);
    for(ull i = 0; i < header.width; ++i)
        xVector[i] = 1.0;
    //loadRegister(0, 0, 0, (ull)yVector);
    double processingTime = 0;
    ull nnz = header.nnz;
    if(argc < 3){
        cerr << "loading deltas" << endl;
        loadDeltas(0, 0, (((ull)cnyBuffer)) + header.spmCodesPtr);
        cerr << "done loading deltas" << endl;
        cerr << "loading fzip codes" << endl;
        loadFzipCodes(0, 0, (((ull)cnyBuffer)) + header.fzipCodesPtr);
        cerr << "done loading fzip codes" << endl;
        cerr << "loading commons" << endl;
        loadCommonCodes(0, 0, (((ull)cnyBuffer)) + header.commonDoublesPtr);
        cerr << "done loading commons" << endl;
        cerr << "first part of steady" << endl;
        steadyPart1(0, 0, (ull)cnyBuffer, header, (ull)xVector, (ull)yVector);
        cerr << "done first part of steady" << endl;
        cerr << "data begin: " << hex << ((ull)cnyBuffer) << " end: " << ((ull)cnyBuffer + header.size) << " x: " << ((ull)xVector) << endl;
        cerr << dec;
        cerr << "second part of steady" << endl;
        stealTardis();
        steadyPart2(0, 0);
        processingTime = returnTardis();
        cerr << "done second part of steady" << endl;
        cerr << "registers: " << endl;
        for(int i = 0; i < 12; i++){
            cerr << "register" << i << " (" << registerNames[i] << "): " << readRegister(0, 0, i) << endl;
        }
        for(int i = 12; i < 14; i++){
            cerr << "register" << i << " (" << registerNames[i] << "): " << ((int)readRegister(0, 0, i)) << endl;
        }
        cerr << "debug register: " << readRegister(0,0,14) << endl;
        //cerr << "y: " << endl;

    }
    SmacHeader globalHeader = header;

    free(buffer);
    cny_cp_free(cnyBuffer);


    if(argc > 2){
        int number = atoi(argv[2]);
        vector<void *> cnyBufferVector;
        vector<void *> bufferVector;
        bufferVector.resize(number);
        cnyBufferVector.resize(number);
        ull yStart = 0;

        cerr << "second arg" << number << endl;
        for(int i = 0; i < number; ++i){
            sprintf(charBuffer, "%s%d.smac", argument.c_str(), i);
            cerr << "opening : " << string(charBuffer) << endl;
            smacFile = fopen(charBuffer, "r");
            header;
            fread(&header, 8, 32, smacFile);
            fseek(smacFile, 0, SEEK_END);
            size2 = ftell(smacFile);
            cerr << "size2: " << size2 << endl;
            rewind(smacFile);
            size = header.size;
            cerr << "size: " << size << endl;
            buffer = malloc(size);
            bufferVector[i] = buffer;
            fread(buffer, 1, size, smacFile);
            fclose(smacFile);
            cnyBuffer = cny_cp_malloc(size);
            cnyBufferVector[i] = cnyBuffer;
            cerr << "cnyBuffer: " << hex << ((ull)cnyBuffer) << endl;
            cerr << dec;
            cny_cp_memcpy(cnyBuffer, buffer, size);

            cerr << "loading deltas" << endl;
            loadDeltas(i / 16, i % 16, (((ull)cnyBuffer)) + header.spmCodesPtr);
            cerr << "done loading deltas" << endl;
            cerr << "loading fzip codes" << endl;
            loadFzipCodes(i / 16, i % 16, (((ull)cnyBuffer)) + header.fzipCodesPtr);
            cerr << "done loading fzip codes" << endl;
            cerr << "loading commons" << endl;
            loadCommonCodes(i / 16, i % 16, (((ull)cnyBuffer)) + header.commonDoublesPtr);
            cerr << "done loading commons" << endl;
            cerr << "first part of steady" << endl;
            steadyPart1(i / 16, i % 16, (ull)cnyBuffer, header, (ull)xVector, (ull)yVector + yStart * 8);
            cerr << "done first part of steady" << endl;
            cerr << "data begin: " << hex << ((ull)cnyBuffer) << " end: " << ((ull)cnyBuffer + header.size) << " x: " << ((ull)xVector) << endl;
            cerr << dec;
            //free(buffer);
            //cny_cp_free(cnyBuffer);
            yStart + header.height;
        }
        stealTardis();
        cerr << "second part of steady" << endl;
        //steadyPart2(4, 16);
        steadyPart2(4, 16);
        cerr << "done second part of steady" << endl;
        processingTime = returnTardis();

        for(int i = 0; i < number; ++i){
            free(bufferVector[i]);
            cny_cp_free(cnyBufferVector[i]);
        }
    }

    /*
    cerr << "checking" << endl;
    vector<double> goldY = check(argument + "After.mtx", xVector);
    ull mismatches = 0;
    for(ull i= 0; i < globalHeader.height; ++i){
        if(yVector[i] + 0.001 < goldY[i] || yVector[i] - 0.001 > goldY[i]){
            cerr << "error mismatch gold: " << goldY[i] << " actual: " << yVector[i] << endl;
            mismatches++;
        }
    }
    cerr << "total mismatches: " << mismatches << " percent: " << endl;
    */

    if(argc > 2){
        vector<vector<ull> > registers = printRegisters(atoi(argv[2]));
        discoverProblemPEs(registers);
        vector<vector<ull> > debugRegisters = getDebugRegisters(atoi(argv[2]));
        printDebugInfo(debugRegisters);
    }

    double flops = nnz * 2.0 / processingTime;
    double gflops = flops / 1000 / 1000 / 1000;
    cerr << "performance GFlops: " << gflops << endl;
    cerr << "nnz: " << nnz << endl;
    cerr << "time: " << processingTime << endl;
    cny_cp_free(yVector);
    cny_cp_free(xVector);
    return 0;
}

vector<double> check(string mtxFilename, double* xVector){
    FILE* mtxFile = fopen(mtxFilename.c_str(), "r");
    char line[1000];
    cerr << "wtf mate" << endl;
    fgets(line, 1000, mtxFile);
    cerr << "wtf mate" << endl;
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

#define INSTRUCTION_OPCODE_WIDTH 4
#define INSTRUCTION_PE_ADDR_WIDTH 5
#define INSTRUCTION_ARG1_WIDTH 5
#define INSTRUCTION_ARG2_WIDTH 48

struct Instruction{
    enum operation {
        NOP, RST, LD, LD_DELTA_CODES, LD_PREFIX_CODES, LD_COMMON_CODES, STEADY, READ, RETURN
    }op: INSTRUCTION_OPCODE_WIDTH;
    ull pe : INSTRUCTION_PE_ADDR_WIDTH;
    ull arg1 : INSTRUCTION_ARG1_WIDTH;
    ull arg2 : INSTRUCTION_ARG2_WIDTH;
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
    Instruction(ull raw){
        this->op = raw;
        this->pe = raw >> INSTRUCTION_OPCODE_WIDTH;
        this->arg1 = raw >> INSTRUCTION_OPCODE_WIDTH+INSTRUCTION_PE_ADDR_WIDTH;
        this->arg2 = raw >> INSTRUCTION_OPCODE_WIDTH+INSTRUCTION_PE_ADDR_WIDTH+INSTRUCTION_ARG1_WIDTH;
    }
};
ull sendInstruction(int ae, Instruction i){
    //cerr << "sending instruction " << i.op << " to ae" << ae << endl;
    switch(ae){
        case 0: return l_copcall_fmt(sig, cpInstructionAE0, "A", *(ull*)&i);
          break;
        case 1: return l_copcall_fmt(sig, cpInstructionAE1, "A", *(ull*)&i);
          break;
        case 2: return l_copcall_fmt(sig, cpInstructionAE2, "A", *(ull*)&i);
          break;
        case 3: return l_copcall_fmt(sig, cpInstructionAE3, "A", *(ull*)&i);
          break;
        case 4: return l_copcall_fmt(sig, cpInstructionAEall, "A", *(ull*)&i);
          break;
        default: return 0;
                 break;
    }
}

void loadRegister(int ae, int pe, int registerAddress, void* value){
    loadRegister(ae, pe, registerAddress, *(ull*)&value);
}
void loadRegister(int ae, int pe, int registerAddress, int value){
    loadRegister(ae, pe, registerAddress, (ull)value);
}
void loadDeltas(int ae, int pe, ull deltas){
    loadRegister(ae, pe, 4, deltas);
    loadRegister(ae, pe, 8, (ull)deltas + (ull)(8*pow((double)2, (double)9)));
    loadRegister(ae, pe, 5, 0);
    loadRegister(ae, pe, 9, (ull)(8*pow((double)2, (double)9)));
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
    //loadRegister(ae, pe, 8, (ull)commonCodes + (ull)(8*pow((double)2, (double)9)));
    loadRegister(ae, pe, 8, (ull)commonCodes + (ull)(8*pow((double)2, (double)13)));
    loadRegister(ae, pe, 5, 0);
    //loadRegister(ae, pe, 9, (ull)(8*pow((double)2, (double)9)));
    loadRegister(ae, pe, 9, (ull)(8*pow((double)2, (double)13)));
    sendInstruction(ae, Instruction(Instruction::LD_COMMON_CODES, pe));
}
void steadyPart1(int ae, int pe, ull matrixData, SmacHeader matrixHeader, ull xPtr, ull yPtr){
    loadRegister(ae, pe, 0, yPtr);
    loadRegister(ae, pe, 1, yPtr + matrixHeader.height * 8);
    loadRegister(ae, pe, 2, xPtr);
    loadRegister(ae, pe, 3, matrixHeader.nnz - 1);
    loadRegister(ae, pe, 4, matrixData + matrixHeader.spmCodeStreamPtr);
    loadRegister(ae, pe, 5, matrixData + matrixHeader.spmArgumentStreamPtr);
    loadRegister(ae, pe, 6, matrixData + matrixHeader.fzipCodeStreamPtr);
    loadRegister(ae, pe, 7, matrixData + matrixHeader.fzipArgumentStreamPtr);
    loadRegister(ae, pe, 8, matrixData + matrixHeader.spmArgumentStreamPtr);
    loadRegister(ae, pe, 9, matrixData + matrixHeader.fzipCodeStreamPtr);
    loadRegister(ae, pe, 10, matrixData + matrixHeader.fzipArgumentStreamPtr);
    loadRegister(ae, pe, 11, matrixData + matrixHeader.size);
    loadRegister(ae, pe, 12, matrixHeader.nnz - 1);
    loadRegister(ae, pe, 13, matrixHeader.nnz - 1);
}

void reset(int ae, int pe){
    sendInstruction(ae, Instruction(Instruction::RST, pe));
}

void resetAll(){
    sendInstruction(4, Instruction(Instruction::RST, 16));
    for(int i = 0; i < 14; ++i){
        loadRegister(4, 16, i, 0);
    }
    loadRegister(4, 16, 12, (ull)-1LL);
    loadRegister(4, 16, 13, (ull)-1LL);
    sendInstruction(4, Instruction(Instruction::RST, 16));
}

void steadyPart2(int ae, int pe){
    sendInstruction(ae, Instruction(Instruction::STEADY, pe));
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

ull readRegister(int ae, int pe, int registerAddress){
    //cerr << "reading register " << registerAddress << " on pe " << pe << " on ae " << ae << endl;
    Instruction tmp;
    tmp.op = Instruction::READ;
    tmp.pe = pe;
    tmp.arg1 = registerAddress;
    tmp.arg2 = 0;
    Instruction ret = (Instruction)sendInstruction(ae, tmp);
    //cerr << "reagister value: " << ret.arg2 << endl;
    //TODO: return return value
    return ret.arg2;
}

vector<ull> printRegisters(int ae, int pe){
    vector<ull> registers;
    for(int i = 0; i < 16; ++i)
        registers.push_back(readRegister(ae, pe, i));
    cerr << "printing the register values of pe" << pe << " on ae" << ae << ":\n";
    for(int i = 0; i < 14; ++i)
        cerr << i << " (" << registerNames[i] << "): " << registers[i] << endl;
    return registers;
}
vector<vector<ull> > printRegisters(){
    return printRegisters(64);
}
vector<vector<ull> > printRegisters(int count){
    vector<vector<ull> > ret;
    for(int i = 0; i < count; ++i){
        ret.push_back(printRegisters(i / 16, i % 16));
    }
    return ret;
}

void discoverProblemPEs(vector<vector<ull> > PEs){
    for(int i = 0; i < PEs.size(); ++i){
        if(PEs[i][0] != PEs[i][1]){
            cerr << "PE " << i << " is a problem\n";
            for(int j = 0; j < 14; ++j)
                cerr << j << " (" << registerNames[j] << "): " << PEs[i][j] << endl;
            cerr << "dirived numbers: " << endl;
            cerr << "y values not stored: " << ((PEs[i][1] - PEs[i][0]) / 8) << endl;
            cerr << "index stream bytes: " << (PEs[i][8] - PEs[i][4]) << endl;
            cerr << "index argument stream bytes: " << (PEs[i][9] - PEs[i][5]) << endl;
            cerr << "fzip stream bytes: " << (PEs[i][10] - PEs[i][6]) << endl;
            cerr << "fzip argument stream bytes: " << (PEs[i][11] - PEs[i][7]) << endl;
            cerr << "debug flag register: " << PEs[i][14] << endl;
        }
    }
}

vector<vector<ull> > getDebugRegisters(int count){
    vector<vector<ull> > ret;
    for(int i = 0; i < count; ++i){
        vector<ull> debugRegisters;
        for(int j = 14; j < 22; ++j)
            debugRegisters.push_back(readRegister(i / 16, i % 16, j));
        ret.push_back(debugRegisters);
    }
    return ret;
}
void printDebugInfo(vector<vector<ull> > debugRegisters){
    int worstOffender = 0;
    int highestClockCycles = 0;
    for(int i = 0; i < debugRegisters.size(); ++i){
        if(debugRegisters[i][5] > highestClockCycles){
            worstOffender = i;
            highestClockCycles = debugRegisters[i][5];
        }

        /*
        cerr << "debug registers on PE" << i << endl;
        for(int j = 0; j < debugRegisters[i].size(); ++j){
            cerr << j << ": " << debugRegisters[i][j] << endl;
        }
        */
    }
    cerr << "Slowest PE: " << worstOffender << endl;
    cerr << "debug registers: " << endl;
    for(int i = 0; i < debugRegisters[worstOffender].size(); ++i)
        cerr << i << " (" << debugRegisterNames[i] << "): " << debugRegisters[worstOffender][i] << endl;

}
