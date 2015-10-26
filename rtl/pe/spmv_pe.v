module spmv_pe(clk, opt_in, opt_out, busy_in, busy_out, req_mem_ld, req_mem_st, req_mem_addr, req_mem_d, req_mem_tag, req_mem_stall, rsp_mem_push, rsp_mem_tag, rsp_mem_q, rsp_mem_stall, req_scratch_d, req_scratch_stall, rsp_scratch_push, rsp_scratch_q, rsp_scratch_stall);
parameter ID = 0;
localparam OPCODE_ARG_PE = 7;
localparam OPCODE_ARG_1 = 12;

reg rst, next_rst;
reg state, next_state;
localparam IDLE = 0;
localparam STEADY = 1;
reg [47:0] registers [0:1], next_registers[0:1];
localparam REGISTER_START = 0;
localparam REGISTER_END = 2;
always @(posedge clk) begin
    rst <= next_rst;
    state <= next_state;
    for(i = REGISTER_START; i < RGESTER_END; i = i + 1)
        registers[i] <= next_registers[i];
end
reg busy_status;
always @* begin
    next_rst = 0;
    next_state = state;
    busy_status = 0;
    for(i = REGISTER_START; i < REGISTER_END; i = i + 1)
        next_registers[i] = registers[i];
    if(opt_r[OPCODE_ARG_1 - 1] || opt_r[OPCODE_ARG_1 - 2:OPCODE_ARG_PE] == ID) begin
        case(opt_r[OPCODE_ARG_PE - 1:0])
            OP_RST: begin
                next_rst = 1;
                next_state = 0;
            end
            OP_STEADY: begin
                next_state = STEADY;
            end
            OP_LD: begin
                for(i = REGISTER_START; i < REGISTER_END; i = i + 1) begin
                    if(i == opt_r[OPCODE_ARG_2 - 1:OPCODE_ARG_1)
                        next_registers[i] = opt_r[63:OPCODE_ARG_2];
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
end
endmodule
