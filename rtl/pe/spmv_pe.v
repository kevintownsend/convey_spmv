module spmv_pe(clk, op_in, op_out, busy_in, busy_out, req_mem_ld, req_mem_st, req_mem_addr, req_mem_d_or_tag, req_mem_stall, rsp_mem_push, rsp_mem_tag, rsp_mem_q, rsp_mem_stall, req_scratch_ld, req_scratch_st, req_scratch_addr, req_scratch_d, req_scratch_stall, rsp_scratch_push, rsp_scratch_q, rsp_scratch_stall);

parameter ID = 0;
parameter SUB_WIDTH = 8;
parameter SUB_HEIGHT = 512;
`include "spmv_opcodes.vh"
input clk;
input [63:0] op_in;
output [63:0] op_out;
input busy_in;
output busy_out;
output reg req_mem_ld;
output reg req_mem_st;
output reg [47:0] req_mem_addr;
output reg [63:0] req_mem_d_or_tag;
input req_mem_stall;
input rsp_mem_push;
input [2:0] rsp_mem_tag;
input [63:0] rsp_mem_q;
output reg rsp_mem_stall;

output req_scratch_ld;
output req_scratch_st;
output [12:0] req_scratch_addr;
output [63:0] req_scratch_d;
input req_scratch_stall;
input rsp_scratch_push;
input [63:0] rsp_scratch_q;
output rsp_scratch_stall;



reg rst, next_rst;
reg state, next_state;
localparam IDLE = 0;
localparam STEADY = 1;
localparam REGISTER_START = 0;
localparam REGISTER_END = 4;
reg [47:0] registers [REGISTER_START:REGISTER_END - 1], next_registers[REGISTER_START:REGISTER_END - 1];
//TODO: wire registers
wire [47:0] register_0 = registers[0];
wire [47:0] register_1 = registers[1];
wire [47:0] register_2 = registers[2];
wire [47:0] register_3 = registers[3];
integer i;
always @(posedge clk) begin
    rst <= next_rst;
    state <= next_state;
    for(i = REGISTER_START; i < REGISTER_END; i = i + 1)
        registers[i] <= next_registers[i];
end
wire registers_equal = registers[0] == registers[1];
reg busy_status;
wire decoder_busy;
reg [63:0] op_r;
reg busy_r;
reg mac_input_stage_1;
reg mac_mem_req_stage_1;
always @* begin
    next_rst = 0;
    next_state = state;
    busy_status = 0;
    //for(i = REGISTER_START; i < REGISTER_END; i = i + 1)
    //    next_registers[i] = registers[i];
    next_registers[0] = register_0;
    next_registers[1] = register_1;
    next_registers[2] = register_2;
    next_registers[3] = register_3;
    if(op_r[OPCODE_ARG_1 - 1] || op_r[OPCODE_ARG_1 - 2:OPCODE_ARG_PE] == ID) begin
        case(op_r[OPCODE_ARG_PE - 1:0])
            OP_RST: begin
                next_rst = 1;
                next_state = 0;
            end
            OP_STEADY: begin
                next_state = STEADY;
            end
            OP_LD: begin
                for(i = REGISTER_START; i < REGISTER_END; i = i + 1) begin
                    if(i == op_r[OPCODE_ARG_2 - 1:OPCODE_ARG_1])
                        next_registers[i] = op_r[63:OPCODE_ARG_2];
                end
            end
        endcase
    end
    busy_status = decoder_busy;
    case(state)
        STEADY: begin
            busy_status = 1;
            if(registers_equal)
                next_state = IDLE;
        end
    endcase
    if(mac_input_stage_1)
        next_registers[3] = register_3 - 1;
    if(register_3[47])
        next_registers[3] = 0;
    //    next_registers[3][47] = 0;
    if(mac_mem_req_stage_1 && !registers_equal)
        next_registers[0] = register_0 + 8;
end


always @(posedge clk) begin
    op_r <= op_in;
    busy_r <= busy_status || busy_in;

end
assign op_out = op_r;
assign busy_out = busy_r;
    //TODO: decoder
    wire decoder_req_mem_ld;
    wire [47:0] decoder_req_mem_addr;
    wire [1:0] decoder_req_mem_tag;
    wire decoder_mem_req_fifo_almost_full;
    reg decoder_mem_req_stall;
    reg decoder_rsp_mem_push;
    reg [2:0] rsp_mem_tag_stage_1;
    reg [63:0] rsp_mem_q_stage_1;
    //reg decoder_rsp_mem_stall;
    wire decoder_rsp_mem_stall;
    wire decoder_push_index;
    wire [31:0] decoder_row;
    wire [31:0] decoder_col;
    reg decoder_stall_index;
    wire decoder_push_val;
    wire [63:0] decoder_val;
    reg decoder_stall_val;
    //TODO: finish
    always @(posedge clk) decoder_mem_req_stall <= decoder_mem_req_fifo_almost_full;

    sparse_matrix_decoder #(ID, 4, SUB_WIDTH, SUB_HEIGHT) decoder(clk, op_r, decoder_busy, decoder_req_mem_ld, decoder_req_mem_addr, decoder_req_mem_tag, decoder_mem_req_stall, decoder_rsp_mem_push, rsp_mem_tag_stage_1[2:1], rsp_mem_q_stage_1, decoder_rsp_mem_stall, req_scratch_ld, req_scratch_st, req_scratch_addr, req_scratch_d, req_scratch_stall, rsp_scratch_push, rsp_scratch_q, rsp_scratch_stall, decoder_push_index, decoder_row, decoder_col, decoder_stall_index, decoder_push_val, decoder_val, decoder_stall_val);
    always @(posedge clk) begin
        if(decoder_push_index)
            $display("decoder_push_index: row: %d col: %d", decoder_row, decoder_col);
        if(decoder_push_val)
            $display("decoder_push_val: %f", $bitstoreal(decoder_val));
        /*
        $display("debug:");
        $display("registers[6]: %d", decoder.registers[6]);
        $display("registers[10]: %d", decoder.registers[10]);
        $display("registers[7]: %d", decoder.registers[7]);
        $display("registers[11]: %d", decoder.registers[11]);
        */
        //$display("stall: %d", decoder_stall_val);
        /*
        if(op_r[OPCODE_ARG_PE - 1:0] != OP_NOP)
            $display("%d:opcode: %d, %d, %d", $time, op_r[OPCODE_ARG_PE - 1:0], op_r[OPCODE_ARG_1 - 1:OPCODE_ARG_PE], op_r[OPCODE_ARG_2 - 1:OPCODE_ARG_1], op_r[31:OPCODE_ARG_2]);
        //$display("wtf: %d", decoder_req_mem_ld);
        //$display("wtf: %d", decoder_busy);
        if(decoder_rsp_mem_push) begin
            $display("memory response");
        end
        */

    end

    always @(posedge clk) begin
        decoder_rsp_mem_push <= rsp_mem_push && !rsp_mem_tag[0];
        rsp_mem_tag_stage_1 <= rsp_mem_tag;
        rsp_mem_q_stage_1 <= rsp_mem_q;
    end
    //std_fifo
    reg decoder_mem_req_fifo_pop;
    wire [48 + 2 - 1:0] decoder_mem_req_fifo_q;
    wire decoder_mem_req_fifo_full, decoder_mem_req_fifo_empty;
    std_fifo #(50, 32) decoder_mem_req_fifo(rst, clk, decoder_req_mem_ld, decoder_mem_req_fifo_pop, {decoder_req_mem_addr, decoder_req_mem_tag}, decoder_mem_req_fifo_q, decoder_mem_req_fifo_full, decoder_mem_req_fifo_empty, , , decoder_mem_req_fifo_almost_full);

    //TODO: x vector cache
    wire cache_req_mem;
    wire [47:0] cache_req_mem_addr;
    reg cache_rsp_mem_push;
    wire cache_push_x;
    wire [63:0] cache_x_val;
    x_vector_cache #(SUB_WIDTH) cache(clk, rst, decoder_col, decoder_push_index, registers[2], cache_req_mem, cache_req_mem_addr, cache_rsp_mem_push, rsp_mem_q_stage_1, cache_push_x, cache_x_val);

    always @(posedge clk) begin
        cache_rsp_mem_push <= rsp_mem_push && rsp_mem_tag[0];
    end

    reg cache_mem_req_fifo_pop;
    wire [47:0] cache_mem_req_fifo_q;
    wire cache_mem_req_fifo_full;
    wire cache_mem_req_fifo_empty;
    wire cache_mem_req_fifo_almost_full;
    std_fifo #(.WIDTH(48), .DEPTH(32), .ALMOST_FULL_COUNT(8)) cache_mem_req_fifo(rst, clk, cache_req_mem, cache_mem_req_fifo_pop, cache_req_mem_addr, cache_mem_req_fifo_q, cache_mem_req_fifo_full, cache_mem_req_fifo_empty, , , cache_mem_req_fifo_almost_full);

    reg mac_input_stage_0;
    wire [63:0] val_fifo_q;
    wire val_fifo_full;
    wire val_fifo_empty;
    wire val_fifo_almost_full;
    std_fifo #(.WIDTH(64), .DEPTH(32), .ALMOST_FULL_COUNT(8)) val_fifo(rst, clk, decoder_push_val, mac_input_stage_0, decoder_val, val_fifo_q, val_fifo_full, val_fifo_empty, , , val_fifo_almost_full);
    always @* decoder_stall_val = val_fifo_almost_full;

    wire [31:0] row_fifo_q;
    wire row_fifo_full;
    wire row_fifo_empty;
    wire row_fifo_almost_full;
    std_fifo #(.WIDTH(32), .DEPTH(512), .ALMOST_FULL_COUNT(8)) row_fifo(rst, clk, decoder_push_index, mac_input_stage_0, decoder_row, row_fifo_q, row_fifo_full, row_fifo_empty, , , row_fifo_almost_full);
    always @* decoder_stall_index = cache_mem_req_fifo_almost_full || row_fifo_almost_full;

    wire [63:0] x_val_fifo_q;
    wire x_val_fifo_full;
    wire x_val_fifo_empty;
    wire x_val_fifo_almost_full;
    std_fifo #(.WIDTH(64), .DEPTH(512), .ALMOST_FULL_COUNT(10)) x_val_fifo(rst, clk, cache_push_x, mac_input_stage_0, cache_x_val, x_val_fifo_q, x_val_fifo_full, x_val_fifo_empty, , , x_val_fifo_almost_full);

    wire mac_push_out;
    wire [63:0] mac_v_out;
    reg mac_eof;
    mac #(1024) mac_inst(clk, rst, mac_input_stage_1, row_fifo_q, val_fifo_q, x_val_fifo_q, mac_push_out, mac_v_out, mac_eof);
    always @(posedge clk) begin
        if(mac_input_stage_1)
            $display("mac push in: row: %d v0: %f v1: %f", row_fifo_q, $bitstoreal(val_fifo_q), $bitstoreal(x_val_fifo_q));
        if(mac_eof)
            $display("mac_eof");

    end
    always @* begin
        mac_input_stage_0 = !val_fifo_empty && !row_fifo_empty && !x_val_fifo_empty;
        mac_eof = register_3[47];
    end

    always @(posedge clk) begin
        mac_input_stage_1 <= mac_input_stage_0;
    end

    reg mac_mem_req_fifo_pop;
    wire [63:0] mac_mem_req_fifo_q;
    wire mac_mem_req_fifo_full;
    wire mac_mem_req_fifo_empty;

    //std_fifo #(64, 32) mac_mem_req_fifo(rst, clk, mac_push_out, mac_mem_req_fifo_pop, mac_v_out, mac_mem_req_fifo_q, mac_mem_req_fifo_full, mac_mem_req_fifo_empty, , , );
    std_fifo #(64, 512) mac_mem_req_fifo(rst, clk, mac_push_out, mac_mem_req_fifo_pop, mac_v_out, mac_mem_req_fifo_q, mac_mem_req_fifo_full, mac_mem_req_fifo_empty, , , );

    always @* begin
        mac_mem_req_fifo_pop = 0;
        cache_mem_req_fifo_pop = 0;
        decoder_mem_req_fifo_pop = 0;
        if(req_mem_stall) begin
        end else if(!mac_mem_req_fifo_empty) begin
            mac_mem_req_fifo_pop = 1;
        end else if(!cache_mem_req_fifo_empty) begin
            cache_mem_req_fifo_pop = 1;
        end else if(!decoder_mem_req_fifo_empty) begin
            decoder_mem_req_fifo_pop = 1;
        end
    end
    reg cache_mem_req_stage_1;
    reg decoder_mem_req_stage_1;
    always @(posedge clk) begin
        mac_mem_req_stage_1 <= mac_mem_req_fifo_pop;
        cache_mem_req_stage_1 <= cache_mem_req_fifo_pop;
        decoder_mem_req_stage_1 <= decoder_mem_req_fifo_pop;
    end

    /*
    always @* begin
        req_mem_ld = 0;
        req_mem_st = 0;
        req_mem_addr = registers[0];
        req_mem_d_or_tag = mac_mem_req_fifo_q;
        if(mac_mem_req_stage_1) begin
            req_mem_st = 1;
            req_mem_addr = registers[0];
            req_mem_d_or_tag = mac_mem_req_fifo_q;
        end else if(cache_mem_req_stage_1) begin
            req_mem_ld = 1;
            req_mem_addr = cache_mem_req_fifo_q;
            req_mem_d_or_tag[0] = 1;
        end else if(decoder_mem_req_stage_1) begin
            req_mem_ld = 1;
            req_mem_addr = decoder_mem_req_fifo_q[49:2];
            req_mem_d_or_tag[0] = 0;
            req_mem_d_or_tag[2:1] = decoder_mem_req_fifo_q[1:0];
        end
        if(rst) begin
            req_mem_ld = 0;
            req_mem_st = 0;
        end
    end
    */
    always @(posedge clk) begin
        req_mem_ld <= 0;
        req_mem_st <= 0;
        req_mem_addr <= registers[0];
        req_mem_d_or_tag <= mac_mem_req_fifo_q;
        if(mac_mem_req_stage_1) begin
            req_mem_st <= !registers_equal;
            req_mem_addr <= registers[0];
            req_mem_d_or_tag <= mac_mem_req_fifo_q;
        end else if(cache_mem_req_stage_1) begin
            req_mem_ld <= 1;
            req_mem_addr <= cache_mem_req_fifo_q;
            req_mem_d_or_tag[0] <= 1;
        end else if(decoder_mem_req_stage_1) begin
            req_mem_ld <= 1;
            req_mem_addr <= decoder_mem_req_fifo_q[49:2];
            req_mem_d_or_tag[0] <= 0;
            req_mem_d_or_tag[2:1] <= decoder_mem_req_fifo_q[1:0];
        end
        if(rst || !busy_r) begin
            req_mem_ld <= 0;
            req_mem_st <= 0;
        end
    end
    always @(posedge clk) rsp_mem_stall <= decoder_rsp_mem_stall;// || x_val_fifo_almost_full;
    // synthesis translate_off
    always @(posedge clk) begin
        $display("@verilog debug spmv_pe @ %d", $time);
        $display("@verilog state: %d", state);
        $display("@verilog op_r: %B %B %B %B", op_r[63:12], op_r[11:8], op_r[7:3], op_r[2:0]);
        $display("@verilog: reset %d", rst);
    end
    // synthesis translate_on

    `include "common.vh"
endmodule
