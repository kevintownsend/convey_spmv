module x_vector_cache_tb;

    parameter SUB_WIDTH = 8;
    parameter LOG2_SUB_WIDTH = log2(SUB_WIDTH - 1);
    reg clk;
    reg rst;
    reg [31:0] col;
    reg push_col;
    reg [47:0] start_address;
    wire req_mem;
    wire [47:0] req_mem_addr;
    reg rsp_mem_push;
    reg [63:0] rsp_mem_q;
    wire push_x;
    wire [63:0] x_val;
    reg stall;
    wire almost_full;

    x_vector_cache #(SUB_WIDTH) dut(clk, rst, col, push_col, start_address, req_mem, req_mem_addr, rsp_mem_push, rsp_mem_q, push_x, x_val, stall, almost_full);

    initial begin
        #1000 $display("watchdog timer reached");
        $finish;
    end

    initial begin
        clk = 0;
        forever #5 clk = !clk;
    end

    initial begin
        stall = 0;
        rst = 1;
        col = 0;
        push_col = 0;
        start_address = 0;
        #100 rst = 0;
        #100 push_col = 1;
        #10 push_col = 0;
        #10 push_col = 1;
        col = 1;
        #10 push_col = 1;
        col = 0;
        #10 push_col = 0;

    end

    reg [63:0] memory [0:9];
    integer i;
    initial begin
        for(i = 0; i < 10; i = i + 1) begin
            memory[i] = i;
        end
    end

    always @(posedge clk) begin
        rsp_mem_push <= req_mem;
        rsp_mem_q <= memory[req_mem_addr / 8];
        if(req_mem)
            $display("memory request");
    end

    always @(posedge clk) begin
        if(push_x)
            $display("woot: %d", x_val);
    end

    `include "common.vh"
endmodule
