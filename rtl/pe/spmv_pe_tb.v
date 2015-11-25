module spmv_pe_tb;

parameter ID = 0;
`include "spmv_opcodes.vh"
`include "smac.vh"
reg clk;
reg [63:0] op_in;
wire [63:0] op_out;
reg busy_in;
wire busy_out;
wire req_mem_ld;
wire req_mem_st;
wire [47:0] req_mem_addr;
wire [63:0] req_mem_d_or_tag;
reg req_mem_stall;
reg rsp_mem_push;
reg [2:0] rsp_mem_tag;
reg [63:0] rsp_mem_q;
wire rsp_mem_stall;

wire req_scratch_ld;
wire req_scratch_st;
wire [12:0] req_scratch_addr;
wire [63:0] req_scratch_d;
reg req_scratch_stall;
reg rsp_scratch_push;
reg [63:0] rsp_scratch_q;
wire rsp_scratch_stall;
spmv_pe #(0) dut(clk, op_in, op_out, busy_in, busy_out, req_mem_ld, req_mem_st, req_mem_addr, req_mem_d_or_tag, req_mem_stall, rsp_mem_push, rsp_mem_tag, rsp_mem_q, rsp_mem_stall, req_scratch_ld, req_scratch_st, req_scratch_addr, req_scratch_d, req_scratch_stall, rsp_scratch_push, rsp_scratch_q, rsp_scratch_stall);

initial begin
    clk = 0;
    forever #5 clk = !clk;
end

    integer i;
initial begin
    #10000000 $display("watchdog timer reached");
    $display("registers:");
    for(i = 0; i < 4; i = i + 1) begin
        $display("%d: %d", i, dut.registers[i]);
    end
    for(i = 4; i < 14; i = i + 1) begin
        $display("%d: %d", i, dut.registers[i]);
    end
    $finish;
end

    reg [63:0] mock_main_memory [0:1000000 - 1];

    /*
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
*/
    initial $readmemh("cant0.hex", mock_main_memory);
    //initial $readmemh("example.hex", mock_main_memory);
    //initial $readmemh("example2.hex", mock_main_memory);
    wire [63:0] width = mock_main_memory[1];
    wire [63:0] height = mock_main_memory[2];
    wire [63:0] nnz = mock_main_memory[3];

    wire [63:0] spmCodesPtr = mock_main_memory[16];
    wire [63:0] fzipCodesPtr = mock_main_memory[17];
    wire [63:0] commonDoublesPtr = mock_main_memory[18];
    wire [63:0] spmCodeStreamPtr = mock_main_memory[19];
    wire [63:0] spmArgumentStreamPtr = mock_main_memory[20];
    wire [63:0] fzipCodeStreamPtr = mock_main_memory[21];
    wire [63:0] fzipArgumentStreamPtr = mock_main_memory[22];
    wire [63:0] size = mock_main_memory[23];

    wire [63:0] x_vector_ptr = size;
    wire [63:0] y_vector_ptr = x_vector_ptr + width * 8;
    wire [63:0] y_vector_ptr_end = y_vector_ptr + height * 8;
    real tmp;
    initial #1 begin
        for(i = 0; i < width; i = i + 1) begin
            tmp = i + 1;
            mock_main_memory[x_vector_ptr / 8 + i] = $realtobits(tmp);
        end
    end
    reg [63:0] gold_result [0:1000000];
    initial $readmemh("cant0Result.hex", gold_result);
    //initial $readmemh("exampleResult.hex", gold_result);
    //initial $readmemh("example2Result.hex", gold_result);

    initial begin
        op_in[OPCODE_ARG_PE - 1:0] = OP_RST; //reset
        op_in[OPCODE_ARG_1 - 1:OPCODE_ARG_PE] = 0;
        op_in[OPCODE_ARG_2 - 1:OPCODE_ARG_1] = 0;
        op_in[63:OPCODE_ARG_2] = 0;
        req_mem_stall = 0;
        busy_in = 0;

        #100 op_in = OP_NOP;
        #100;
        $display("starting to load delta codes");
        op_in[OPCODE_ARG_PE - 1:0] = OP_LD;
        op_in[OPCODE_ARG_1 - 1:OPCODE_ARG_PE] = 0;
        op_in[OPCODE_ARG_2 - 1:OPCODE_ARG_1] = 4;
        op_in[63:OPCODE_ARG_2] = spmCodesPtr;
        #10;
        op_in[OPCODE_ARG_PE - 1:0] = OP_LD;
        op_in[OPCODE_ARG_1 - 1:OPCODE_ARG_PE] = 0;
        op_in[OPCODE_ARG_2 - 1:OPCODE_ARG_1] = 8;
        op_in[63:OPCODE_ARG_2] = fzipCodesPtr;
        #10;
        op_in[OPCODE_ARG_PE - 1:0] = OP_LD;
        op_in[OPCODE_ARG_1 - 1:OPCODE_ARG_PE] = 0;
        op_in[OPCODE_ARG_2 - 1:OPCODE_ARG_1] = 5;
        op_in[63:OPCODE_ARG_2] = 0;
        #10;
        op_in[OPCODE_ARG_PE - 1:0] = OP_LD;
        op_in[OPCODE_ARG_1 - 1:OPCODE_ARG_PE] = 0;
        op_in[OPCODE_ARG_2 - 1:OPCODE_ARG_1] = 9;
        op_in[63:OPCODE_ARG_2] = 2**9*8;
        #10;
        op_in[OPCODE_ARG_PE - 1:0] = OP_LD_DELTA_CODES;
        op_in[OPCODE_ARG_1 - 1:OPCODE_ARG_PE] = 0;
        op_in[OPCODE_ARG_2 - 1:OPCODE_ARG_1] = 0;
        op_in[63:OPCODE_ARG_2] = 0;
        #10 op_in = OP_NOP;
        #100;
        while(busy_out)begin
            #10;
        end
        $display("starting to load prefix codes");
        op_in[OPCODE_ARG_PE - 1:0] = OP_LD;
        op_in[OPCODE_ARG_1 - 1:OPCODE_ARG_PE] = 0;
        op_in[OPCODE_ARG_2 - 1:OPCODE_ARG_1] = 4;
        op_in[63:OPCODE_ARG_2] = fzipCodesPtr;
        #10;
        op_in[OPCODE_ARG_PE - 1:0] = OP_LD;
        op_in[OPCODE_ARG_1 - 1:OPCODE_ARG_PE] = 0;
        op_in[OPCODE_ARG_2 - 1:OPCODE_ARG_1] = 8;
        op_in[63:OPCODE_ARG_2] = commonDoublesPtr;
        #10;
        op_in[OPCODE_ARG_PE - 1:0] = OP_LD;
        op_in[OPCODE_ARG_1 - 1:OPCODE_ARG_PE] = 0;
        op_in[OPCODE_ARG_2 - 1:OPCODE_ARG_1] = 5;
        op_in[63:OPCODE_ARG_2] = 0;
        #10;
        op_in[OPCODE_ARG_PE - 1:0] = OP_LD;
        op_in[OPCODE_ARG_1 - 1:OPCODE_ARG_PE] = 0;
        op_in[OPCODE_ARG_2 - 1:OPCODE_ARG_1] = 9;
        op_in[63:OPCODE_ARG_2] = 2**9*8*2;
        #10;
        op_in[OPCODE_ARG_PE - 1:0] = OP_LD_PREFIX_CODES;
        op_in[OPCODE_ARG_1 - 1:OPCODE_ARG_PE] = 0;
        op_in[OPCODE_ARG_2 - 1:OPCODE_ARG_1] = 0;
        op_in[63:OPCODE_ARG_2] = 0;
        #10;
        op_in = OP_NOP;
        #100;
        while(busy_out)begin
            #10;
        end

        $display("starting to load common codes");
        op_in[OPCODE_ARG_PE - 1:0] = OP_LD;
        op_in[OPCODE_ARG_1 - 1:OPCODE_ARG_PE] = 0;
        op_in[OPCODE_ARG_2 - 1:OPCODE_ARG_1] = 4;
        op_in[63:OPCODE_ARG_2] = commonDoublesPtr;
        #10;
        op_in[OPCODE_ARG_PE - 1:0] = OP_LD;
        op_in[OPCODE_ARG_1 - 1:OPCODE_ARG_PE] = 0;
        op_in[OPCODE_ARG_2 - 1:OPCODE_ARG_1] = 8;
        op_in[63:OPCODE_ARG_2] = spmCodeStreamPtr;
        #10;
        op_in[OPCODE_ARG_PE - 1:0] = OP_LD;
        op_in[OPCODE_ARG_1 - 1:OPCODE_ARG_PE] = 0;
        op_in[OPCODE_ARG_2 - 1:OPCODE_ARG_1] = 5;
        op_in[63:OPCODE_ARG_2] = 0;
        #10;
        op_in[OPCODE_ARG_PE - 1:0] = OP_LD;
        op_in[OPCODE_ARG_1 - 1:OPCODE_ARG_PE] = 0;
        op_in[OPCODE_ARG_2 - 1:OPCODE_ARG_1] = 9;
        op_in[63:OPCODE_ARG_2] = 2**9*16 * 8;
        #10;
        op_in[OPCODE_ARG_PE - 1:0] = OP_LD_COMMON_CODES;
        op_in[OPCODE_ARG_1 - 1:OPCODE_ARG_PE] = 0;
        op_in[OPCODE_ARG_2 - 1:OPCODE_ARG_1] = 0;
        op_in[63:OPCODE_ARG_2] = 0;
        #10;
        op_in = OP_NOP;
        #100;
        while(busy_out)begin
            #10;
        end
        $display("starting steady state");
        op_in[OPCODE_ARG_PE - 1:0] = OP_LD;
        op_in[OPCODE_ARG_1 - 1:OPCODE_ARG_PE] = 0;
        op_in[OPCODE_ARG_2 - 1:OPCODE_ARG_1] = 0;
        op_in[63:OPCODE_ARG_2] = y_vector_ptr;
        #10;
        op_in[OPCODE_ARG_PE - 1:0] = OP_LD;
        op_in[OPCODE_ARG_1 - 1:OPCODE_ARG_PE] = 0;
        op_in[OPCODE_ARG_2 - 1:OPCODE_ARG_1] = 1;
        op_in[63:OPCODE_ARG_2] = y_vector_ptr_end;
        #10;
        op_in[OPCODE_ARG_PE - 1:0] = OP_LD;
        op_in[OPCODE_ARG_1 - 1:OPCODE_ARG_PE] = 0;
        op_in[OPCODE_ARG_2 - 1:OPCODE_ARG_1] = 2;
        op_in[63:OPCODE_ARG_2] = x_vector_ptr;
        #10;
        op_in[OPCODE_ARG_PE - 1:0] = OP_LD;
        op_in[OPCODE_ARG_1 - 1:OPCODE_ARG_PE] = 0;
        op_in[OPCODE_ARG_2 - 1:OPCODE_ARG_1] = 3;
        op_in[63:OPCODE_ARG_2] = nnz - 1;
        #10;
        op_in[OPCODE_ARG_PE - 1:0] = OP_LD;
        op_in[OPCODE_ARG_1 - 1:OPCODE_ARG_PE] = 0;
        op_in[OPCODE_ARG_2 - 1:OPCODE_ARG_1] = 4;
        op_in[63:OPCODE_ARG_2] = spmCodeStreamPtr;
        #10;
        op_in[OPCODE_ARG_PE - 1:0] = OP_LD;
        op_in[OPCODE_ARG_1 - 1:OPCODE_ARG_PE] = 0;
        op_in[OPCODE_ARG_2 - 1:OPCODE_ARG_1] = 5;
        op_in[63:OPCODE_ARG_2] = spmArgumentStreamPtr;
        #10;
        op_in[OPCODE_ARG_PE - 1:0] = OP_LD;
        op_in[OPCODE_ARG_1 - 1:OPCODE_ARG_PE] = 0;
        op_in[OPCODE_ARG_2 - 1:OPCODE_ARG_1] = 6;
        op_in[63:OPCODE_ARG_2] = fzipCodeStreamPtr;
        #10;
        op_in[OPCODE_ARG_PE - 1:0] = OP_LD;
        op_in[OPCODE_ARG_1 - 1:OPCODE_ARG_PE] = 0;
        op_in[OPCODE_ARG_2 - 1:OPCODE_ARG_1] = 7;
        op_in[63:OPCODE_ARG_2] = fzipArgumentStreamPtr;
        #10;
        op_in[OPCODE_ARG_PE - 1:0] = OP_LD;
        op_in[OPCODE_ARG_1 - 1:OPCODE_ARG_PE] = 0;
        op_in[OPCODE_ARG_2 - 1:OPCODE_ARG_1] = 8;
        op_in[63:OPCODE_ARG_2] = spmArgumentStreamPtr;
        #10;
        op_in[OPCODE_ARG_PE - 1:0] = OP_LD;
        op_in[OPCODE_ARG_1 - 1:OPCODE_ARG_PE] = 0;
        op_in[OPCODE_ARG_2 - 1:OPCODE_ARG_1] = 9;
        op_in[63:OPCODE_ARG_2] = fzipCodeStreamPtr;
        #10;
        op_in[OPCODE_ARG_PE - 1:0] = OP_LD;
        op_in[OPCODE_ARG_1 - 1:OPCODE_ARG_PE] = 0;
        op_in[OPCODE_ARG_2 - 1:OPCODE_ARG_1] = 10;
        op_in[63:OPCODE_ARG_2] = fzipArgumentStreamPtr;
        #10;
        op_in[OPCODE_ARG_PE - 1:0] = OP_LD;
        op_in[OPCODE_ARG_1 - 1:OPCODE_ARG_PE] = 0;
        op_in[OPCODE_ARG_2 - 1:OPCODE_ARG_1] = 11;
        op_in[63:OPCODE_ARG_2] = size;
        #10;
        op_in[OPCODE_ARG_PE - 1:0] = OP_LD;
        op_in[OPCODE_ARG_1 - 1:OPCODE_ARG_PE] = 0;
        op_in[OPCODE_ARG_2 - 1:OPCODE_ARG_1] = 12;
        op_in[63:OPCODE_ARG_2] = nnz - 1;
        #10;
        op_in[OPCODE_ARG_PE - 1:0] = OP_LD;
        op_in[OPCODE_ARG_1 - 1:OPCODE_ARG_PE] = 0;
        op_in[OPCODE_ARG_2 - 1:OPCODE_ARG_1] = 13;
        op_in[63:OPCODE_ARG_2] = nnz - 1;
        #10;
        op_in[OPCODE_ARG_PE - 1:0] = OP_STEADY;
        op_in[OPCODE_ARG_1 - 1:OPCODE_ARG_PE] = 0;
        op_in[OPCODE_ARG_2 - 1:OPCODE_ARG_1] = 0;
        op_in[63:OPCODE_ARG_2] = 0;
        #10 op_in = OP_NOP;
        #100;
        while(busy_out)begin
            #10;
        end
        $display("Done");
        $finish;
    end

    //TODO: memory interface
    localparam MEMORY_LATENCY = 256;
    reg rsp_mem_push_latency [0:MEMORY_LATENCY];
    reg [2:0] rsp_mem_tag_latency [0:MEMORY_LATENCY];
    reg [63:0] rsp_mem_q_latency [0:MEMORY_LATENCY];
    always @(posedge clk) begin
        rsp_mem_push <= 0;
        rsp_mem_tag <= 0;
        rsp_mem_q <= 0;
        /*
        if(req_mem_ld) begin
            rsp_mem_push <= 1;
            rsp_mem_tag <= req_mem_d_or_tag;
            rsp_mem_q <= mock_main_memory[req_mem_addr / 8];
        end
        */
        rsp_mem_push_latency[0] <= req_mem_ld;
        rsp_mem_tag_latency[0] <= req_mem_d_or_tag;
        rsp_mem_q_latency[0] <= mock_main_memory[req_mem_addr / 8];
        for(i = 0; i < MEMORY_LATENCY; i = i + 1) begin
            rsp_mem_push_latency[i + 1] <= rsp_mem_push_latency[i];
            rsp_mem_tag_latency[i + 1] <= rsp_mem_tag_latency[i];
            rsp_mem_q_latency[i + 1] <= rsp_mem_q_latency[i];
        end
        rsp_mem_push <= rsp_mem_push_latency[MEMORY_LATENCY];
        rsp_mem_tag <= rsp_mem_tag_latency[MEMORY_LATENCY];
        rsp_mem_q <= rsp_mem_q_latency[MEMORY_LATENCY];
        if(rsp_mem_stall) begin
            $display("rsp_mem_stall reached.");
            $finish;
        end
    end
    reg [63:0] mock_scratch_pad [0:512*16 - 1];
    //TODO: scratch pad interface
    always @(posedge clk) begin
        rsp_scratch_push <= 0;
        rsp_scratch_q <= 0;
        if(req_scratch_st) begin
            mock_scratch_pad[req_scratch_addr] <= req_scratch_d;
        end
        if(req_scratch_ld) begin
            $display("loading to scratchpad");
            rsp_scratch_push <= 1;
            rsp_scratch_q <= mock_scratch_pad[req_scratch_addr];
        end
    end

    //TODO: check output
    integer result_index;
    initial result_index = 0;
    always @(posedge clk) begin
        if(req_mem_st) begin
            $display("writing to memory: addr: %d val: %f gold: %f", req_mem_addr, $bitstoreal(req_mem_d_or_tag), $bitstoreal(gold_result[result_index]));
            result_index = result_index + 1;
        end
    end

    always @(posedge clk) begin
        //$display("req_scratch_ld: %d", req_scratch_ld);
        //$display("state: %d", dut.state);
        /*
        if(dut.state == 1) begin
            $display("state 1: at %d", $time);
            $display("r[2]: %d", dut.registers[2]);
            $display("r[6]: %d", dut.registers[6]);
        end
        */
    end
    `include "common.vh"
endmodule
