module(clk, push_in, ieee_float, push_out, flopoco_float);
input clk, push_in;
input [63:0] ieee_float;
output push_out;
output [52+11+2:0] flopoco_float;

reg push;
always @(posedge clk)
    push <= push_in;
assign push_out = push;
wire rst = 0;
InputIEEE_11_52_to_11_52 flopoco_conv(.clk(clk),.rst(rst),.X(ieee_float),.R(flopoco_float));

endmodule
