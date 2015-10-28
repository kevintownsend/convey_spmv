module adder_pipe(clk, push_in, row_in, v0_in, v1_in, push_out, row_out, v_out);
    parameter ROW_WIDTH = log2(1024 - 1);
    input clk, push_in;
    input [ROW_WIDTH - 1:0] row_in;
    input [65:0] v0_in, v1_in;
    output push_out;
    output [ROW_WIDTH - 1:0] row_out;
    output [65:0] v_out;
    wire rst = 0;
    FPAdder_11_52_uid2 flopoco(.clk(clk), .rst(rst), .X(v0_in), .Y(v1_in), .R(v_out));
    reg [ROW_WIDTH - 1:0] row_pipe [0:13];
    reg push_pipe [0:13];
    integer i;
    always @(posedge clk) begin
        row_pipe[0] <= row_in;
        push_pipe[0] <= push_in;
        for(i = 1; i < 14; i = i + 1) begin
            row_pipe[i] <= row_pipe[i - 1];
            push_pipe[i] <= push_pipe[i - 1];
        end
    end
    assign row_out = row_pipe[13];
    assign push_out = push_pipe[13];
    `include "common.vh"
endmodule
