module flopoco_to_ieee(clk, push_in, flopoco_float, push_out, ieee_float);
    input clk, push_in;
    input [11 + 52 + 2:0] flopoco_float;
    output push_out;
    output [63:0] ieee_float;

    wire rst = 0;
    OutputIEEE_11_52_to_11_52 ieee_conv(.clk(clk), .rst(rst), .X(flopoco_float), .R(ieee_float));
    reg push;
    always @(posedge clk)
        push <= push_in;
    assign push_out = push;

    //TODO: finish
endmodule
