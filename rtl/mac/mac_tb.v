module mac_tb;
    parameter INTERMEDIATOR_DEPTH = 1024;
    parameter LOG2_INTERMEDIATOR_DEPTH = log2(INTERMEDIATOR_DEPTH - 1);
    parameter MATRIX_FILENAME = "../../src/tmp/cant/cant.mtx";

    reg clk, rst, wr;
    reg [LOG2_INTERMEDIATOR_DEPTH - 1:0] row;
    reg [63:0] v0, v1;
    wire push_out;
    wire [63:0] v_out;
    reg eof;
    wire stall;
    reg stall_out;

    mac #(INTERMEDIATOR_DEPTH) dut(clk, rst, wr, row, v0, v1, push_out, v_out, eof, stall, stall_out);

    initial begin
        clk = 0;
        forever #5 clk = !clk;
    end

    reg [63:0] floats [0:10000000];
    reg [63:0] row_index [0:10000000];
    reg [63:0] col_index [0:10000000];
    integer file;
    integer bufferSize = 100;
    reg [100 * 8 - 1:0] string;
    integer M, N, nnz;
    integer r;
    integer i = 0;
    integer tmp1, tmp2;
    real tmp3;
    initial begin
        $readmemh("floats.hex", floats);
        $readmemh("row.hex", row_index);
        $readmemh("col.hex", col_index);
        file = $fopen(MATRIX_FILENAME, "r");
        r = $fgets(string, file);
        r = $fscanf(file, "%d%d%d", M, N, nnz);
        for(i = 0; i < nnz; i = i + 1) begin
            $fscanf(file, "%d%d%f", tmp1, tmp2, tmp3);
            //$display("tmp1: %d", tmp1);
            row_index[i] = tmp1 - 1;
            col_index[i] = tmp2 - 1;
            floats[i] = $realtobits(tmp3);
        end
        $display("finshed reading mtx file");
    end

    integer stall_count = 0;
    initial begin
        rst = 1;
        wr = 0;
        row = 0;
        v0 = 0;
        v1 = 0;
        eof = 0;
        stall_out = 0;
        #1000 rst = 0;
        #100;
        for(i = 0; i < nnz; i = i + 1) begin
            while(stall) begin
                stall_count = stall_count + 1;
                wr = 0;
                #10;
            end
            wr = 1;
            row = row_index[i];
            v0 = floats[i];
            v1 = floats[col_index[i]];
            //$display("pushing: row: %d, v0: %f, v0: %f", row, $bitstoreal(v0), $bitstoreal(v1));
            #10;
        end
        wr = 0;
        //eof = 1;
        #10000 eof = 1;
        #10 eof = 0;
    end
    wire multiplier_push_ieee;
    wire [63:0] ieee_multiplier_out;
    flopoco_to_ieee conv_after_mult(clk, dut.multiplier_push, dut.multiplier_out, multiplier_push_ieee, ieee_multiplier_out);
    wire adder_push_ieee;
    wire [63:0] ieee_adder_out;
    flopoco_to_ieee conv_after_add(clk, dut.adder_push_out, dut.adder_out, adder_push_ieee, ieee_adder_out);
    wire [63:0] before_adder_v0, before_adder_v1;
    wire push_before_adder;
    flopoco_to_ieee conv_before_add0(clk, dut.intermediator_push_to_adder, dut.intermediator_v0_to_adder, push_before_adder, before_adder_v0);
    flopoco_to_ieee conv_before_add1(clk, dut.intermediator_push_to_adder, dut.intermediator_v1_to_adder, , before_adder_v1);

    integer out_count;
    initial begin
        #1000000000 $display("watchdog reached");
        $display("out_count: %d", out_count);
        $display("stall_count: %d", stall_count);
        $finish;
    end

    initial begin
        #20000 $display("endgame:");
        $display("window end: %d", dut.intermediator_inst.window_end);
    end
    initial out_count = 0;
    always @(posedge clk) begin
        if(out_count == M) begin
            $display("reached the end");
            $display("@verilog:out_count: %d", out_count);
            $display("@verilog:stall_count: %d : %d", stall_count, nnz);
            $finish;

        end
        if(push_out) begin
            //$display("push_out: %d, %f", v_out, $bitstoreal(v_out));
            out_count = out_count + 1;
        end
        /*
        if(dut.flopoco_conv_push)
            $display("flopoco_conv_push");
        if(dut.multiplier_push)
            $display("multiplier_push: row: %d", dut.multiplier_row);
        if(dut.intermediator_push_to_adder)
            $display("adder push");
        if(dut.adder_push_out)
            $display("adder output");

        if(multiplier_push_ieee)
            $display("multiplier_out: %f", $bitstoreal(ieee_multiplier_out));
        if(dut.adder_push_out)
            $display("flopoco adder out: %H", dut.adder_out);
        if(adder_push_ieee)begin
            $display("adder_out: %H %f", ieee_adder_out, $bitstoreal(ieee_adder_out));
        end
        if(push_before_adder) begin
            $display("before adder: v0: %f v1: %f", $bitstoreal(before_adder_v0), $bitstoreal(before_adder_v1));
        end
        */
        /*
        if(dut.multiplier_push)
            $display("flopoco multiplier_out: %H", dut.multiplier_out);
        */
        /*
        if(dut.intermediator_inst.p0_stage_0)
            $display("intermediator p0_stage_0");
        if(dut.intermediator_inst.p0_stage_1)
            $display("intermediator p0_stage_1");
        if(dut.intermediator_inst.p0_stage_2)
            $display("intermediator p0_stage_2");
        if(dut.intermediator_inst.p0_stage_3)
            $display("intermediator p0_stage_3");
        if(dut.intermediator_inst.p0_stage_5)
            $display("intermediator p0_stage_5");
        if(dut.intermediator_inst.p0_stage_6)
            $display("intermediator p0_stage_6");
        if(dut.intermediator_inst.to_adder_stage_7)
            $display("intermediator to adder stage 7");
        if(dut.intermediator_inst.overflow_fifo_pop_stage_5)
            $display("intermediator popping overflow fifo");
        */
        /*
        $display("overflow_fifo_empty: %d", dut.intermediator_inst.overflow_fifo_empty);
        $display("p1_stage_5: %d", dut.intermediator_inst.p1_stage_5);
        $display("p1_stage_3: %d", dut.intermediator_inst.p1_stage_3);
        $display("p1_stage_0: %d", dut.intermediator_inst.p1_stage_0);
        */
    end
    `include "common.vh"
endmodule
