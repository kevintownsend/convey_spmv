module intermediator(clk, rst, wr0, row0, v0, wr1, row1, v1, push_to_adder, row_to_adder, v0_to_adder, v1_to_adder, push_to_y, v_to_y, eof, stall, stall_out);
parameter INTERMEDIATOR_DEPTH = 1024;
parameter LOG2_INTERMEDIATOR_DEPTH = log2(INTERMEDIATOR_DEPTH - 1);
input clk, rst, wr0;
input [LOG2_INTERMEDIATOR_DEPTH - 1:0] row0;
input [65:0] v0;
input wr1;
input [LOG2_INTERMEDIATOR_DEPTH - 1:0] row1;
input [65:0] v1;
output push_to_adder;
output [LOG2_INTERMEDIATOR_DEPTH - 1:0] row_to_adder;
output [65:0] v0_to_adder;
output [65:0] v1_to_adder;
output push_to_y;
output [65:0] v_to_y;
input eof;
output stall;
input stall_out;

reg p0_stage_0;
reg [65:0] v0_stage_0;
reg [LOG2_INTERMEDIATOR_DEPTH - 1:0] r0_stage_0;
reg p1_stage_0;
reg [65:0] v1_stage_0;
reg [LOG2_INTERMEDIATOR_DEPTH - 1:0] r1_stage_0;

always @(posedge clk) begin
    p0_stage_0 <= wr0;
    v0_stage_0 <= v0;
    r0_stage_0 <= row0;
    p1_stage_0 <= wr1;
    v1_stage_0 <= v1;
    r1_stage_0 <= row1;
    if(rst) begin
        p0_stage_0 <= 0;
        p1_stage_0 <= 0;
    end
end

reg p0_stage_1;
reg [LOG2_INTERMEDIATOR_DEPTH - 1:0] r0_stage_1;
reg [65:0] v0_stage_1;
reg p1_stage_1;
reg [LOG2_INTERMEDIATOR_DEPTH - 1:0] r1_stage_1;
reg [65:0] v1_stage_1;
reg row_cmp_stage_1;

reg multiplier_overflow_fifo_pop_delay;
wire [66 + LOG2_INTERMEDIATOR_DEPTH - 1:0] multiplier_overflow_fifo_q;
always @(posedge clk) begin
    p0_stage_1 <= p0_stage_0;
    r0_stage_1 <= r0_stage_0;
    v0_stage_1 <= v0_stage_0;
    p1_stage_1 <= p1_stage_0;
    r1_stage_1 <= r1_stage_0;
    v1_stage_1 <= v1_stage_0;
    row_cmp_stage_1 <= 0;
    if(r0_stage_0 == r1_stage_0 && p0_stage_0 && p1_stage_0) begin
        p0_stage_1 <= 0;
        p1_stage_1 <= 0;
        row_cmp_stage_1 <= 1;
    end
    if(multiplier_overflow_fifo_pop_delay) begin
        p0_stage_1 <= 1;
        r0_stage_1 <= multiplier_overflow_fifo_q[LOG2_INTERMEDIATOR_DEPTH - 1:0];
        v0_stage_1 <= multiplier_overflow_fifo_q[66 + LOG2_INTERMEDIATOR_DEPTH - 1 -:66];
    end
end

reg [LOG2_INTERMEDIATOR_DEPTH - 1:0] window_begin;
reg [LOG2_INTERMEDIATOR_DEPTH - 1:0] window_end;

reg [7:0] fade_counter;
initial fade_counter = 0;

reg p0_stage_2;
reg [LOG2_INTERMEDIATOR_DEPTH - 1:0] r0_stage_2;
reg [65:0] v0_stage_2;
reg p1_stage_2;
reg [LOG2_INTERMEDIATOR_DEPTH - 1:0] r1_stage_2;
reg [65:0] v1_stage_2;
reg row_cmp_stage_2;
reg push_store_stage_2;

reg stall_out_r;
always @(posedge clk) stall_out_r <= stall_out;
wire to_store_stage_2_comb = !p1_stage_1 && window_begin[LOG2_INTERMEDIATOR_DEPTH - 1] != window_end[LOG2_INTERMEDIATOR_DEPTH - 1] && !fade_counter[7] && !stall_out_r;

reg window_closed;
reg [10:0] eof_delay;
initial eof_delay = 0;
always @(posedge clk) begin
    if(eof)
        eof_delay[9] <= 1;
    if(eof_delay[9] && window_closed)
        eof_delay <= eof_delay + 1;
    if(eof_delay[10])
        eof_delay[10] <= 0;
    if(rst)
        eof_delay <= 0;
end

always @(posedge clk) window_closed <= window_begin == window_end;
reg multiplier_overflow_fifo_push;
wire multiplier_overflow_fifo_empty;
wire overflow_fifo_half_full;
always @* multiplier_overflow_fifo_push = p0_stage_1 && ((!window_closed && r0_stage_1[LOG2_INTERMEDIATOR_DEPTH - 1] != window_end[LOG2_INTERMEDIATOR_DEPTH - 1]));
reg multiplier_overflow_fifo_pop;
always @* multiplier_overflow_fifo_pop = !multiplier_overflow_fifo_empty && window_closed && !wr0;
always @(posedge clk) multiplier_overflow_fifo_pop_delay <= multiplier_overflow_fifo_pop;
std_fifo #(66 + LOG2_INTERMEDIATOR_DEPTH, 32) multiplier_overflow_fifo(rst, clk, multiplier_overflow_fifo_push, multiplier_overflow_fifo_pop, {v0_stage_1, r0_stage_1}, multiplier_overflow_fifo_q, , multiplier_overflow_fifo_empty, , , );
assign stall = !multiplier_overflow_fifo_empty || overflow_fifo_half_full;
//TODO: complete

always @(posedge clk) begin
    p0_stage_2 <= p0_stage_1;
    r0_stage_2 <= r0_stage_1;
    v0_stage_2 <= v0_stage_1;
    p1_stage_2 <= p1_stage_1;
    r1_stage_2 <= r1_stage_1;
    v1_stage_2 <= v1_stage_1;
    row_cmp_stage_2 <= row_cmp_stage_1;
    push_store_stage_2 <= 0;
    if(to_store_stage_2_comb) begin
        push_store_stage_2 <= 1;
        window_begin <= window_begin + 1;
        r1_stage_2 <= window_begin;
    end
    if(multiplier_overflow_fifo_push)
        p0_stage_2 <= 0;
    if(window_closed && r0_stage_1[LOG2_INTERMEDIATOR_DEPTH - 1] != window_end[LOG2_INTERMEDIATOR_DEPTH - 1] && p0_stage_1 || eof_delay[10]) begin
        // synthesis off
        $display("incrementing window at %d", $time);
        $display("p0: %d %d", p0_stage_1, r0_stage_1);
        $display("multiplier_overflow_fifo.count: %d", multiplier_overflow_fifo.count);
        //TODO: raise error if window begin not equal window end
        if(window_begin != window_end) begin
            $display("ERROR advancing too soon");
            $display("window_begin: %B", window_begin);
            $display("window_end: %B", window_end);
            $display("eof: %d", eof_delay[10]);
            //$finish;
        end
        // synthesis on

        fade_counter[7] <= 1;
        window_end[LOG2_INTERMEDIATOR_DEPTH - 1] <= !window_end[LOG2_INTERMEDIATOR_DEPTH - 1];
    end
    //TODO: raise error if adder input not in the red or yellow window
    if(fade_counter[7])
        fade_counter <= fade_counter + 1;
    if(rst) begin
        window_begin <= 0;
        window_end <= 0;
    end
end

wire occupency0_stage_2_comb;
wire occupency1_stage_2_comb;

dual_port_xor_ram #(INTERMEDIATOR_DEPTH) occupency_ram(clk, rst, p0_stage_2, r0_stage_2, occupency0_stage_2_comb, p1_stage_2 || push_store_stage_2, r1_stage_2, occupency1_stage_2_comb);
/*
always @(posedge clk) begin
    $display();
    $display("debug at %d", $time);
    $display("p1_stage_2: %d", p1_stage_2);
    $display("push_store_stage_2: %d", push_store_stage_2);
    $display("end debug");
    $display();
end
*/
reg p0_stage_3;
reg [LOG2_INTERMEDIATOR_DEPTH - 1:0] r0_stage_3;
reg [65:0] v0_stage_3;
reg p1_stage_3;
reg [LOG2_INTERMEDIATOR_DEPTH - 1:0] r1_stage_3;
reg [65:0] v1_stage_3;
reg occupency0_stage_3, occupency1_stage_3;
reg push_store_stage_3;
reg row_cmp_stage_3;

always @(posedge clk) begin
    p0_stage_3 <= p0_stage_2;
    r0_stage_3 <= r0_stage_2;
    v0_stage_3 <= v0_stage_2;
    p1_stage_3 <= p1_stage_2;
    r1_stage_3 <= r1_stage_2;
    v1_stage_3 <= v1_stage_2;
    occupency0_stage_3 <= occupency0_stage_2_comb;
    occupency1_stage_3 <= occupency1_stage_2_comb;
    row_cmp_stage_3 <= row_cmp_stage_2;
    push_store_stage_3 <= push_store_stage_2;
end

reg p0_store_to_intermediator_stage_4;
reg p0_retrieve_from_intermediator_stage_4;
reg [LOG2_INTERMEDIATOR_DEPTH - 1:0] r0_stage_4;
reg [65:0] v0_stage_4;
reg p1_store_to_intermediator_stage_4;
reg p1_retrieve_from_intermediator_stage_4;
reg [LOG2_INTERMEDIATOR_DEPTH - 1:0] r1_stage_4;
reg [65:0] v1_stage_4;
reg row_cmp_stage_4;
reg push_store_stage_4;

always @(posedge clk) begin
    p0_store_to_intermediator_stage_4 <= p0_stage_3 && ! occupency0_stage_3;
    p0_retrieve_from_intermediator_stage_4 <= p0_stage_3 && occupency0_stage_3;
    r0_stage_4 <= r0_stage_3;
    v0_stage_4 <= v0_stage_3;
    p1_store_to_intermediator_stage_4 <= p1_stage_3 && ! occupency1_stage_3;
    p1_retrieve_from_intermediator_stage_4 <= p1_stage_3 && occupency1_stage_3;
    r1_stage_4 <= r1_stage_3;
    v1_stage_4 <= v1_stage_3;
    row_cmp_stage_4 <= row_cmp_stage_3;
    push_store_stage_4 <= push_store_stage_3;
end

wire [65:0] v0_second_stage_5, v1_second_stage_5;

reg p0_stage_5;
reg [LOG2_INTERMEDIATOR_DEPTH - 1:0] r0_stage_5;
reg [65:0] v0_stage_5;
reg p1_stage_5;
reg [LOG2_INTERMEDIATOR_DEPTH - 1:0] r1_stage_5;
reg [65:0] v1_stage_5;
reg row_cmp_stage_5;
reg push_store_stage_5;
//reg [65:0] v_store_stage_5;

dual_port_block_ram #(66, INTERMEDIATOR_DEPTH) intermediator_memory(clk, p0_store_to_intermediator_stage_4, r0_stage_4, v0_stage_4, v0_second_stage_5, p1_store_to_intermediator_stage_4, r1_stage_4, v1_stage_4, v1_second_stage_5);

always @(posedge clk) begin
    p0_stage_5 <= p0_retrieve_from_intermediator_stage_4;
    r0_stage_5 <= r0_stage_4;
    v0_stage_5 <= v0_stage_4;
    p1_stage_5 <= p1_retrieve_from_intermediator_stage_4;
    r1_stage_5 <= r1_stage_4;
    v1_stage_5 <= v1_stage_4;
    row_cmp_stage_5 <= row_cmp_stage_4;
    push_store_stage_5 <= push_store_stage_4;
end

reg p0_stage_6;
reg [LOG2_INTERMEDIATOR_DEPTH - 1:0] r0_stage_6;
reg [65:0] v0_stage_6;
reg [65:0] v0_second_stage_6;
reg p1_stage_6;
reg [LOG2_INTERMEDIATOR_DEPTH - 1:0] r1_stage_6;
reg [65:0] v1_stage_6;
reg [65:0] v1_second_stage_6;
reg push_store_stage_6;

always @(posedge clk) begin
    p0_stage_6 <= p0_stage_5;
    r0_stage_6 <= r0_stage_5;
    v0_stage_6 <= v0_stage_5;
    v0_second_stage_6 <= v0_second_stage_5;
    p1_stage_6 <= p1_stage_5;
    r1_stage_6 <= r1_stage_5;
    v1_stage_6 <= v1_stage_5;
    v1_second_stage_6 <= v1_second_stage_5;
    push_store_stage_6 <= push_store_stage_5;
    if(row_cmp_stage_5) begin
        p0_stage_6 <= 1;
        v0_second_stage_6 <= v1_stage_5;
    end
end

assign push_to_y = push_store_stage_6;
assign v_to_y = v1_second_stage_6;

wire overflow_fifo_empty;
wire overflow_fifo_pop_stage_5 = !overflow_fifo_empty && !p1_stage_5;
reg overflow_fifo_pop_delay_stage_6;
always @(posedge clk) overflow_fifo_pop_delay_stage_6 <= overflow_fifo_pop_stage_5;
wire [66 + 66 + LOG2_INTERMEDIATOR_DEPTH - 1:0] overflow_fifo_q_stage_6;
wire [LOG2_INTERMEDIATOR_DEPTH - 1:0] overflow_fifo_q_row_stage_6 = overflow_fifo_q_stage_6[LOG2_INTERMEDIATOR_DEPTH - 1:0];
wire [65:0] overflow_fifo_q_value0_stage_6 = overflow_fifo_q_stage_6[66 + LOG2_INTERMEDIATOR_DEPTH - 1 -:66];
wire [65:0] overflow_fifo_q_value1_stage_6 = overflow_fifo_q_stage_6[66 + 66 + LOG2_INTERMEDIATOR_DEPTH - 1 -:66];

std_fifo #(.WIDTH(66 + 66 + LOG2_INTERMEDIATOR_DEPTH), .DEPTH(32), .ALMOST_FULL_COUNT(16)) overflow_fifo(rst, clk, p0_stage_6, overflow_fifo_pop_stage_5, {v0_second_stage_6, v0_stage_6, r0_stage_6}, overflow_fifo_q_stage_6, , overflow_fifo_empty, , , overflow_fifo_half_full);

reg to_adder_stage_7;
reg [LOG2_INTERMEDIATOR_DEPTH - 1:0] row_to_adder_stage_7;
reg [65:0] value0_to_adder_stage_7;
reg [65:0] value1_to_adder_stage_7;

always @(posedge clk) begin
    to_adder_stage_7 <= p1_stage_6;
    row_to_adder_stage_7 <= r1_stage_6;
    value0_to_adder_stage_7 <= v1_stage_6;
    value1_to_adder_stage_7 <= v1_second_stage_6;
    if(overflow_fifo_pop_delay_stage_6) begin
        to_adder_stage_7 <= 1;
        row_to_adder_stage_7 <= overflow_fifo_q_row_stage_6;
        value0_to_adder_stage_7 <= overflow_fifo_q_value0_stage_6;
        value1_to_adder_stage_7 <= overflow_fifo_q_value1_stage_6;
    end
end
assign push_to_adder = to_adder_stage_7;
assign row_to_adder = row_to_adder_stage_7;
assign v0_to_adder = value0_to_adder_stage_7;
assign v1_to_adder = value1_to_adder_stage_7;
//TODO: complete

`include "common.vh"
endmodule
