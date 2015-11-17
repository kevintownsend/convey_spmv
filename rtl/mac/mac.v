module mac(clk, rst, wr, row, v0, v1, push_out, v_out, eof, stall);
    parameter INTERMEDIATOR_DEPTH = 1024;
    parameter LOG2_INTERMEDIATOR_DEPTH = log2(INTERMEDIATOR_DEPTH - 1);

    input clk, rst, wr;
    input [LOG2_INTERMEDIATOR_DEPTH - 1:0] row;
    input [63:0] v0, v1;
    output push_out;
    output [63:0] v_out;
    input eof;
    output stall;

    wire [65:0] flopoco_conv_v0, flopoco_conv_v1;
    wire flopoco_conv_push;
    //TODO: flopoco converter
    ieee_to_flopoco to_flop0(clk, wr, v0, flopoco_conv_push, flopoco_conv_v0);
    ieee_to_flopoco to_flop1(clk, wr, v1, , flopoco_conv_v1);
    reg [LOG2_INTERMEDIATOR_DEPTH - 1:0] row_input_stage;
    always @(posedge clk) row_input_stage <= row;

    wire [65:0] multiplier_out;
    wire [LOG2_INTERMEDIATOR_DEPTH - 1:0] multiplier_row;
    wire multiplier_push;

    multiplier_pipe #(LOG2_INTERMEDIATOR_DEPTH) multiplier(clk, flopoco_conv_push, row_input_stage, flopoco_conv_v0, flopoco_conv_v1, multiplier_push, multiplier_row, multiplier_out);

    wire adder_push_out;
    wire [LOG2_INTERMEDIATOR_DEPTH - 1:0] adder_row;
    wire [65:0] adder_out;

    wire intermediator_push_to_adder;
    wire [LOG2_INTERMEDIATOR_DEPTH - 1:0] intermediator_row_to_adder;
    wire [65:0] intermediator_v0_to_adder;
    wire [65:0] intermediator_v1_to_adder;

    wire intermediator_push_to_ieee;
    wire [65:0] intermediator_v_to_ieee;

    intermediator #(INTERMEDIATOR_DEPTH) intermediator_inst(clk, rst, multiplier_push, multiplier_row, multiplier_out, adder_push_out, adder_row, adder_out, intermediator_push_to_adder, intermediator_row_to_adder, intermediator_v0_to_adder, intermediator_v1_to_adder, intermediator_push_to_ieee, intermediator_v_to_ieee, eof, stall);

    adder_pipe #(LOG2_INTERMEDIATOR_DEPTH) adder(clk, intermediator_push_to_adder, intermediator_row_to_adder, intermediator_v0_to_adder, intermediator_v1_to_adder, adder_push_out, adder_row, adder_out);

    //TODO: ieee converter
    flopoco_to_ieee to_ieee(clk, intermediator_push_to_ieee, intermediator_v_to_ieee, push_out, v_out);

    `include "common.vh"
endmodule
