module mac_tb;
    parameter INTERMEDIATOR_DEPTH = 1024;
    parameter LOG2_INTERMEDIATOR_DEPTH = log2(INTERMEDIATOR_DEPTH - 1);

    reg clk, rst, wr;
    reg [LOG2_INTERMEDIATOR_DEPTH - 1:0] row;
    reg [63:0] v0, v1;
    wire push_out;
    wire [63:0] v_out;
    reg eof;

    mac #(INTERMEDIATOR_DEPTH) dut(clk, rst, wr, row, v0, v1, push_out, v_out, eof);

    initial begin
        clk = 0;
        forever #5 clk = !clk;
    end

    reg [63:0] floats [0:24];
    reg [63:0] row_index [0:24];
    reg [63:0] col_index [0:24];

    initial $readmemh("floats.hex", floats);

    integer i = 0;
    initial begin
        rst = 1;
        wr = 0;
        row = 0;
        v0 = 0;
        v1 = 0;
        eof = 0;
        #1000 rst = 0;
        #1000;
        for(i = 0; i < 25; i = i + 1) begin
            wr = 1;
            row = row_index[i];
            v0 = floats[i];
            v1 = floats[col_index[i]];
            #10;
        end
        wr = 0;
        eof = 1;
        #10 eof = 0;
    end
    always @(posedge clk) begin
        //TODO: output
    end
    `include "common.vh"
endmodule
