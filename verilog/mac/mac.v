module mac(clk, rst, wr, row, v0, v1, push_out, v_out, eof);
    parameter INTERMEDIATOR_DEPTH = 1024;
    parameter LOG2_INTERMEDIATOR_DEPTH = log2(INTERMEDIATOR_DEPTH - 1);

    input clk, rst, wr;
    input [LOG2_INTERMEDIATOR_DEPTH - 1:0] row;
    input [63:0] v0, v1;
    output push_out;
    output [63:0] v_out;
    input eof;

    wire [65:0] flopoco_conv_v0, flopoco_conv_v1;
    //TODO: flopoco converter
    wire [65:0] multiliper_out;
    wire [LOG2_INTERMEDIATOR_DEPTH - 1:0] multiplier_row;
    wire multiplier_push;

    multiplier_pipe multilier(clk, flopoco_conv_push, flopoco_conv_row, flopoco_conv_v0, flopoco_conv_v1, multiplier_push, multiplier_row, multiplier_out);

    wire adder_push_out;
    wire [LOG2_INTERMEDIATOR_DEPTH - 1:0] adder_row;
    wire [65:0] adder_out;

    wire intermediator_push_to_adder;
    wire [LOG2_INTERMEDIATOR_DEPTH - 1:0] intermediator_row_to_adder;
    wire [65:0] intermediator_v0_to_adder;
    wire [65:0] intermediator_v1_to_adder;

    intermediator intermediator_inst(clk, rst, multiplier_push_out, multiplier_row, multiplier_out, adder_push_out, adder_row, adder_out, intermediator_push_to_adder, intermediator_row_to_adder, intermediator_v0_to_adder, intermediator_v1_to_adder, intermediator_push_to_ieee, intermediator_v_to_ieee, eof);

    adder_pipe adder(clk, intermediator_push_to_adder, intermediator_row_to_adder, intermediator_v0_to_adder, intermediator_v1_to_adder, adder_push_out, adder_row, adder_out);

    //TODO: ieee converter

endmodule
