module intermediator_tb;

parameter INTERMEDIATOR_DEPTH = 1024;
parameter LOG2_INTERMEDIATOR_DEPTH = log2(INTERMEDIATOR_DEPTH - 1);
reg clk, rst, wr0;
reg [LOG2_INTERMEDIATOR_DEPTH - 1:0] row0;
reg [65:0] v0;
reg wr1;
reg [LOG2_INTERMEDIATOR_DEPTH - 1:0] row1;
reg [65:0] v1;
wire push_to_adder;
wire [LOG2_INTERMEDIATOR_DEPTH - 1:0] row_to_adder;
wire [65:0] v0_to_adder;
wire [65:0] v1_to_adder;
wire push_to_y;
wire [65:0] v_to_y;
reg eof;

intermediator #(8) dut(clk, rst, wr0, row0, v0, wr1, row1, v1, push_to_adder, row_to_adder, v0_to_adder, v1_to_adder, push_to_y, v_to_y, eof);

initial begin
    clk = 0;
    forever #5 clk = !clk;
end

initial begin
    #3000 $display("watchdog reached");
    $finish;
end
integer i;
initial begin
    rst = 1;
    wr0 = 0;
    row0 = 0;
    v0 = 0;
    wr1 = 0;
    row1 = 0;
    v1 = 0;
    eof = 0;
    #100 rst = 0;
    #100 wr0 = 1;
    #10 wr0 = 0;
    #10 wr0 = 1;
    #10 wr0 = 0;
    //TODO: figure out
    for(i = 0; i < 8; i = i + 1) begin
        wr0 = 1;
        row0 = i;
        #10;
    end
    wr0 = 0;
    #2000 wr0 = 1;
    row0 = 4;
    wr1 = 1;
    row1 = 5;
    #10 wr0 = 0;
    wr1 = 0;
    #100 wr0 = 1;
    row0 = 4;
    wr1 = 1;
    row1 = 4;
    #10 wr0 = 0;
    wr1 = 0;
end
integer store_count;
initial store_count = 0;
integer adder_count;
initial adder_count = 0;
always @(posedge clk) begin
    //$display("debug: ");
    //$display("%d", push_to_adder);
    if(dut.p0_stage_1)
        $display("p0_stage_1");
    if(dut.p0_stage_2) begin
        $display("p0_stage_2");
        $display("r0_stage_2: %d", dut.r0_stage_2);
        $display("occupency0_stage_2_comb: %d", dut.occupency0_stage_2_comb);
    end
    if(dut.p0_stage_3) begin
        $display("p0_stage_3");
        $display("occupency0_stage_3: %d", dut.occupency0_stage_3);
    end
    if(dut.to_store_stage_2_comb)
        $display("to_store_stage_2_comb");
    //$display("to_store_stage_2_comb: %d", dut.to_store_stage_2_comb);
    if(dut.p0_retrieve_from_intermediator_stage_4)
        $display("p0_retrieve_stage_4");
    if(dut.p0_store_to_intermediator_stage_4)
        $display("p0_store_stage_4");
    if(dut.p0_retrieve_from_intermediator_stage_4 || dut.p0_store_to_intermediator_stage_4) begin

    end
    if(dut.p0_stage_5)
        $display("p0_stage_5");
    if(dut.p0_stage_6)
        $display("p0_stage_6");
    if(dut.row_cmp_stage_3)
        $display("row_cmp_stage_3");

    //$display("p1_stage3: %d", dut.p1_stage_3);

    if(push_to_adder) begin
        $display("pushed to adder count: %d time: %d", adder_count, $time);
        adder_count = adder_count + 1;
    end
    if(push_to_y) begin
        $display("pushed to y count: %d", store_count);
        store_count = store_count + 1;
        //$finish;
    end
end
`include "common.vh"
endmodule
