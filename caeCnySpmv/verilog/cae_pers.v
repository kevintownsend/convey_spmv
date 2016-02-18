`timescale 1 ns / 1 ps

`include "pdk_fpga_defines.vh"

(* keep_hierarchy = "true" *)
module cae_pers (
   input        clk_csr,
   input        clk,
   input        clk2x,
   input        i_reset,
   input        i_csr_reset_n,
   input  [1:0]     i_aeid,

   input        ppll_reset,
   output       ppll_locked,
   output       clk_per,

   //
   // Dispatch Interface
   //
   input  [31:0]    cae_inst,
   input  [63:0]    cae_data,
   input        cae_inst_vld,

   output [17:0]    cae_aeg_cnt,
   output [15:0]    cae_exception,
   output [63:0]    cae_ret_data,
   output       cae_ret_data_vld,
   output       cae_idle,
   output       cae_stall,

   //
   // MC Interface(s)
   //
   output       mc0_req_ld_e, mc0_req_ld_o,
   output       mc0_req_st_e, mc0_req_st_o,
   output [1:0]     mc0_req_size_e, mc0_req_size_o,
   output [47:0]    mc0_req_vadr_e, mc0_req_vadr_o,
   output [63:0]    mc0_req_wrd_rdctl_e, mc0_req_wrd_rdctl_o,
   output       mc0_rsp_stall_e, mc0_rsp_stall_o,
   input        mc0_rd_rq_stall_e, mc0_rd_rq_stall_o,
   input        mc0_wr_rq_stall_e, mc0_wr_rq_stall_o,
   input  [63:0]    mc0_rsp_data_e, mc0_rsp_data_o,
   input        mc0_rsp_push_e, mc0_rsp_push_o,
   input  [31:0]    mc0_rsp_rdctl_e, mc0_rsp_rdctl_o,
   output       mc1_req_ld_e, mc1_req_ld_o,
   output       mc1_req_st_e, mc1_req_st_o,
   output [1:0]     mc1_req_size_e, mc1_req_size_o,
   output [47:0]    mc1_req_vadr_e, mc1_req_vadr_o,
   output [63:0]    mc1_req_wrd_rdctl_e, mc1_req_wrd_rdctl_o,
   output       mc1_rsp_stall_e, mc1_rsp_stall_o,
   input        mc1_rd_rq_stall_e, mc1_rd_rq_stall_o,
   input        mc1_wr_rq_stall_e, mc1_wr_rq_stall_o,
   input  [63:0]    mc1_rsp_data_e, mc1_rsp_data_o,
   input        mc1_rsp_push_e, mc1_rsp_push_o,
   input  [31:0]    mc1_rsp_rdctl_e, mc1_rsp_rdctl_o,
   output       mc2_req_ld_e, mc2_req_ld_o,
   output       mc2_req_st_e, mc2_req_st_o,
   output [1:0]     mc2_req_size_e, mc2_req_size_o,
   output [47:0]    mc2_req_vadr_e, mc2_req_vadr_o,
   output [63:0]    mc2_req_wrd_rdctl_e, mc2_req_wrd_rdctl_o,
   output       mc2_rsp_stall_e, mc2_rsp_stall_o,
   input        mc2_rd_rq_stall_e, mc2_rd_rq_stall_o,
   input        mc2_wr_rq_stall_e, mc2_wr_rq_stall_o,
   input  [63:0]    mc2_rsp_data_e, mc2_rsp_data_o,
   input        mc2_rsp_push_e, mc2_rsp_push_o,
   input  [31:0]    mc2_rsp_rdctl_e, mc2_rsp_rdctl_o,
   output       mc3_req_ld_e, mc3_req_ld_o,
   output       mc3_req_st_e, mc3_req_st_o,
   output [1:0]     mc3_req_size_e, mc3_req_size_o,
   output [47:0]    mc3_req_vadr_e, mc3_req_vadr_o,
   output [63:0]    mc3_req_wrd_rdctl_e, mc3_req_wrd_rdctl_o,
   output       mc3_rsp_stall_e, mc3_rsp_stall_o,
   input        mc3_rd_rq_stall_e, mc3_rd_rq_stall_o,
   input        mc3_wr_rq_stall_e, mc3_wr_rq_stall_o,
   input  [63:0]    mc3_rsp_data_e, mc3_rsp_data_o,
   input        mc3_rsp_push_e, mc3_rsp_push_o,
   input  [31:0]    mc3_rsp_rdctl_e, mc3_rsp_rdctl_o,
   output       mc4_req_ld_e, mc4_req_ld_o,
   output       mc4_req_st_e, mc4_req_st_o,
   output [1:0]     mc4_req_size_e, mc4_req_size_o,
   output [47:0]    mc4_req_vadr_e, mc4_req_vadr_o,
   output [63:0]    mc4_req_wrd_rdctl_e, mc4_req_wrd_rdctl_o,
   output       mc4_rsp_stall_e, mc4_rsp_stall_o,
   input        mc4_rd_rq_stall_e, mc4_rd_rq_stall_o,
   input        mc4_wr_rq_stall_e, mc4_wr_rq_stall_o,
   input  [63:0]    mc4_rsp_data_e, mc4_rsp_data_o,
   input        mc4_rsp_push_e, mc4_rsp_push_o,
   input  [31:0]    mc4_rsp_rdctl_e, mc4_rsp_rdctl_o,
   output       mc5_req_ld_e, mc5_req_ld_o,
   output       mc5_req_st_e, mc5_req_st_o,
   output [1:0]     mc5_req_size_e, mc5_req_size_o,
   output [47:0]    mc5_req_vadr_e, mc5_req_vadr_o,
   output [63:0]    mc5_req_wrd_rdctl_e, mc5_req_wrd_rdctl_o,
   output       mc5_rsp_stall_e, mc5_rsp_stall_o,
   input        mc5_rd_rq_stall_e, mc5_rd_rq_stall_o,
   input        mc5_wr_rq_stall_e, mc5_wr_rq_stall_o,
   input  [63:0]    mc5_rsp_data_e, mc5_rsp_data_o,
   input        mc5_rsp_push_e, mc5_rsp_push_o,
   input  [31:0]    mc5_rsp_rdctl_e, mc5_rsp_rdctl_o,
   output       mc6_req_ld_e, mc6_req_ld_o,
   output       mc6_req_st_e, mc6_req_st_o,
   output [1:0]     mc6_req_size_e, mc6_req_size_o,
   output [47:0]    mc6_req_vadr_e, mc6_req_vadr_o,
   output [63:0]    mc6_req_wrd_rdctl_e, mc6_req_wrd_rdctl_o,
   output       mc6_rsp_stall_e, mc6_rsp_stall_o,
   input        mc6_rd_rq_stall_e, mc6_rd_rq_stall_o,
   input        mc6_wr_rq_stall_e, mc6_wr_rq_stall_o,
   input  [63:0]    mc6_rsp_data_e, mc6_rsp_data_o,
   input        mc6_rsp_push_e, mc6_rsp_push_o,
   input  [31:0]    mc6_rsp_rdctl_e, mc6_rsp_rdctl_o,
   output       mc7_req_ld_e, mc7_req_ld_o,
   output       mc7_req_st_e, mc7_req_st_o,
   output [1:0]     mc7_req_size_e, mc7_req_size_o,
   output [47:0]    mc7_req_vadr_e, mc7_req_vadr_o,
   output [63:0]    mc7_req_wrd_rdctl_e, mc7_req_wrd_rdctl_o,
   output       mc7_rsp_stall_e, mc7_rsp_stall_o,
   input        mc7_rd_rq_stall_e, mc7_rd_rq_stall_o,
   input        mc7_wr_rq_stall_e, mc7_wr_rq_stall_o,
   input  [63:0]    mc7_rsp_data_e, mc7_rsp_data_o,
   input        mc7_rsp_push_e, mc7_rsp_push_o,
   input  [31:0]    mc7_rsp_rdctl_e, mc7_rsp_rdctl_o,

   //
   // Write flush
   //
   output       mc0_req_flush_e, mc0_req_flush_o,
   input        mc0_rsp_flush_cmplt_e, mc0_rsp_flush_cmplt_o,
   output       mc1_req_flush_e, mc1_req_flush_o,
   input        mc1_rsp_flush_cmplt_e, mc1_rsp_flush_cmplt_o,
   output       mc2_req_flush_e, mc2_req_flush_o,
   input        mc2_rsp_flush_cmplt_e, mc2_rsp_flush_cmplt_o,
   output       mc3_req_flush_e, mc3_req_flush_o,
   input        mc3_rsp_flush_cmplt_e, mc3_rsp_flush_cmplt_o,
   output       mc4_req_flush_e, mc4_req_flush_o,
   input        mc4_rsp_flush_cmplt_e, mc4_rsp_flush_cmplt_o,
   output       mc5_req_flush_e, mc5_req_flush_o,
   input        mc5_rsp_flush_cmplt_e, mc5_rsp_flush_cmplt_o,
   output       mc6_req_flush_e, mc6_req_flush_o,
   input        mc6_rsp_flush_cmplt_e, mc6_rsp_flush_cmplt_o,
   output       mc7_req_flush_e, mc7_req_flush_o,
   input        mc7_rsp_flush_cmplt_e, mc7_rsp_flush_cmplt_o,

   //
   // AE-to-AE Interface not used
   //

   //
   // Management/Debug Interface
   //
   input  [3:0]     cae_ring_ctl_in,
   input  [15:0]    cae_ring_data_in,
   output [3:0]     cae_ring_ctl_out,
   output [15:0]    cae_ring_data_out,

   input        csr_31_31_intlv_dis
);

initial $display("starting cae personality aeid:%d\n", i_aeid);

`include "pdk_fpga_param.vh"

   //
   // Local clock generation
   //
   (* KEEP = "true" *) wire reset_per;
   cae_clock clock (
      .clk(clk),
      .i_reset(i_reset),
      .ppll_reset(ppll_reset),

      .clk_per(clk_per),
      .ppll_locked(ppll_locked),
      .reset_per(reset_per)
   );


     //
     // Instruction decode
     //
     wire [4:0]   inst_caep;
     wire [17:0]  inst_aeg_idx;
     instdec dec (
        .cae_inst(cae_inst),
        .cae_data(cae_data),
        .cae_inst_vld(cae_inst_vld),

        .inst_val(inst_val),
        .inst_caep(inst_caep),
        .inst_aeg_wr(inst_aeg_wr),
        .inst_aeg_rd(inst_aeg_rd),
        .inst_aeg_idx(inst_aeg_idx),
        .err_unimpl(err_unimpl)
    );


   //**************************************************************************
   //              PERSONALITY SPECIFIC LOGIC
   //**************************************************************************

   //
   // AEG[0..NA-1] Registers
   //
    localparam NA = 2;
    localparam NB = 1;       // Number of bits to represent NAEG

    assign cae_aeg_cnt = NA;

    //output of aeg registers
    wire [63:0]  w_aeg[NA-1:0];
    `include "spmv_opcodes.vh"
    wire [63:0] return_op;
    genvar g;
    generate for (g=0; g<NA; g=g+1) begin : g0
      reg [63:0] c_aeg, r_aeg;

      always @* begin
        case (g)
//TODO: add cases for registers to be written to
            0: begin
                c_aeg = r_aeg;
                if(return_op[OPCODE_ARG_PE - 1:0] == OP_RETURN)
                    c_aeg = return_op;
            end
            default: c_aeg = r_aeg;
        endcase
      end

      wire c_aeg_we = inst_aeg_wr && inst_aeg_idx[NB-1:0] == g;

      always @(posedge clk) begin
        if (c_aeg_we) begin
            r_aeg <= cae_data;
            $display("@verilog: writing: %x", cae_data);
        end
        else
            r_aeg <= c_aeg;
        end
      assign w_aeg[g] = r_aeg;
    end endgenerate

   reg      r_ret_val, r_err_unimpl, r_err_aegidx;
   reg [63:0]   r_ret_data;

   wire c_val_aegidx = inst_aeg_idx < NA;

    //return logic
   always @(posedge clk) begin
      r_ret_val    <= inst_aeg_rd && c_val_aegidx;
      r_ret_data   <= w_aeg[inst_aeg_idx[NB-1:0]];
      r_err_aegidx <= (inst_aeg_wr || inst_aeg_rd) && !c_val_aegidx;
      r_err_unimpl <= err_unimpl || (inst_val && (inst_caep !== 'd0 && inst_caep !== 'd1 && inst_caep !== 'd2)); 
   end
   assign cae_ret_data_vld = r_ret_val;
   assign cae_ret_data     = r_ret_data;

   assign cae_exception[1:0] = {r_err_aegidx, r_err_unimpl};

   // ISE can have issues with global wires attached to D(flop)/I(lut) inputs
   wire r_reset;
   FDSE rst (.C(clk_per),.S(reset_per),.CE(r_reset),.D(!r_reset),.Q(r_reset));

   //
   // default state
   //
assign cae_ring_ctl_out = cae_ring_ctl_in;
assign cae_ring_data_out = cae_ring_data_in;

wire [0:15] req_mem_ld;
wire [0:15] req_mem_st;
wire [47:0] req_mem_addr [0:15];
wire [63:0] req_mem_d_or_tag [0:15];
wire [0:15] req_mem_stall;
wire [0:15] rsp_mem_push;
wire [2:0] rsp_mem_tag [0:15];
wire [63:0] rsp_mem_q [0:15];
wire [0:15] rsp_mem_stall;

assign mc0_req_ld_e = req_mem_ld[0];
assign mc0_req_st_e = req_mem_st[0];
assign mc0_req_size_e = 3;
assign mc0_req_flush_e = 0;
assign mc0_req_vadr_e = req_mem_addr[0];
assign mc0_req_wrd_rdctl_e = req_mem_d_or_tag[0];
assign req_mem_stall[0] = mc0_rd_rq_stall_e || mc0_wr_rq_stall_e;
assign rsp_mem_q[0] = mc0_rsp_data_e;
assign rsp_mem_push[0] = mc0_rsp_push_e;
assign rsp_mem_tag[0] = mc0_rsp_rdctl_e;
assign mc0_rsp_stall_e = rsp_mem_stall[0];
assign mc1_req_ld_e = req_mem_ld[1];
assign mc1_req_st_e = req_mem_st[1];
assign mc1_req_size_e = 3;
assign mc1_req_flush_e = 0;
assign mc1_req_vadr_e = req_mem_addr[1];
assign mc1_req_wrd_rdctl_e = req_mem_d_or_tag[1];
assign req_mem_stall[1] = mc1_rd_rq_stall_e || mc1_wr_rq_stall_e;
assign rsp_mem_q[1] = mc1_rsp_data_e;
assign rsp_mem_push[1] = mc1_rsp_push_e;
assign rsp_mem_tag[1] = mc1_rsp_rdctl_e;
assign mc1_rsp_stall_e = rsp_mem_stall[1];
assign mc2_req_ld_e = req_mem_ld[2];
assign mc2_req_st_e = req_mem_st[2];
assign mc2_req_size_e = 3;
assign mc2_req_flush_e = 0;
assign mc2_req_vadr_e = req_mem_addr[2];
assign mc2_req_wrd_rdctl_e = req_mem_d_or_tag[2];
assign req_mem_stall[2] = mc2_rd_rq_stall_e || mc2_wr_rq_stall_e;
assign rsp_mem_q[2] = mc2_rsp_data_e;
assign rsp_mem_push[2] = mc2_rsp_push_e;
assign rsp_mem_tag[2] = mc2_rsp_rdctl_e;
assign mc2_rsp_stall_e = rsp_mem_stall[2];
assign mc3_req_ld_e = req_mem_ld[3];
assign mc3_req_st_e = req_mem_st[3];
assign mc3_req_size_e = 3;
assign mc3_req_flush_e = 0;
assign mc3_req_vadr_e = req_mem_addr[3];
assign mc3_req_wrd_rdctl_e = req_mem_d_or_tag[3];
assign req_mem_stall[3] = mc3_rd_rq_stall_e || mc3_wr_rq_stall_e;
assign rsp_mem_q[3] = mc3_rsp_data_e;
assign rsp_mem_push[3] = mc3_rsp_push_e;
assign rsp_mem_tag[3] = mc3_rsp_rdctl_e;
assign mc3_rsp_stall_e = rsp_mem_stall[3];
assign mc4_req_ld_e = req_mem_ld[4];
assign mc4_req_st_e = req_mem_st[4];
assign mc4_req_size_e = 3;
assign mc4_req_flush_e = 0;
assign mc4_req_vadr_e = req_mem_addr[4];
assign mc4_req_wrd_rdctl_e = req_mem_d_or_tag[4];
assign req_mem_stall[4] = mc4_rd_rq_stall_e || mc4_wr_rq_stall_e;
assign rsp_mem_q[4] = mc4_rsp_data_e;
assign rsp_mem_push[4] = mc4_rsp_push_e;
assign rsp_mem_tag[4] = mc4_rsp_rdctl_e;
assign mc4_rsp_stall_e = rsp_mem_stall[4];
assign mc5_req_ld_e = req_mem_ld[5];
assign mc5_req_st_e = req_mem_st[5];
assign mc5_req_size_e = 3;
assign mc5_req_flush_e = 0;
assign mc5_req_vadr_e = req_mem_addr[5];
assign mc5_req_wrd_rdctl_e = req_mem_d_or_tag[5];
assign req_mem_stall[5] = mc5_rd_rq_stall_e || mc5_wr_rq_stall_e;
assign rsp_mem_q[5] = mc5_rsp_data_e;
assign rsp_mem_push[5] = mc5_rsp_push_e;
assign rsp_mem_tag[5] = mc5_rsp_rdctl_e;
assign mc5_rsp_stall_e = rsp_mem_stall[5];
assign mc6_req_ld_e = req_mem_ld[6];
assign mc6_req_st_e = req_mem_st[6];
assign mc6_req_size_e = 3;
assign mc6_req_flush_e = 0;
assign mc6_req_vadr_e = req_mem_addr[6];
assign mc6_req_wrd_rdctl_e = req_mem_d_or_tag[6];
assign req_mem_stall[6] = mc6_rd_rq_stall_e || mc6_wr_rq_stall_e;
assign rsp_mem_q[6] = mc6_rsp_data_e;
assign rsp_mem_push[6] = mc6_rsp_push_e;
assign rsp_mem_tag[6] = mc6_rsp_rdctl_e;
assign mc6_rsp_stall_e = rsp_mem_stall[6];
assign mc7_req_ld_e = req_mem_ld[7];
assign mc7_req_st_e = req_mem_st[7];
assign mc7_req_size_e = 3;
assign mc7_req_flush_e = 0;
assign mc7_req_vadr_e = req_mem_addr[7];
assign mc7_req_wrd_rdctl_e = req_mem_d_or_tag[7];
assign req_mem_stall[7] = mc7_rd_rq_stall_e || mc7_wr_rq_stall_e;
assign rsp_mem_q[7] = mc7_rsp_data_e;
assign rsp_mem_push[7] = mc7_rsp_push_e;
assign rsp_mem_tag[7] = mc7_rsp_rdctl_e;
assign mc7_rsp_stall_e = rsp_mem_stall[7];
assign mc0_req_ld_o = req_mem_ld[8];
assign mc0_req_st_o = req_mem_st[8];
assign mc0_req_size_o = 3;
assign mc0_req_flush_o = 0;
assign mc0_req_vadr_o = req_mem_addr[8];
assign mc0_req_wrd_rdctl_o = req_mem_d_or_tag[8];
assign req_mem_stall[8] = mc0_rd_rq_stall_o || mc0_wr_rq_stall_o;
assign rsp_mem_q[8] = mc0_rsp_data_o;
assign rsp_mem_push[8] = mc0_rsp_push_o;
assign rsp_mem_tag[8] = mc0_rsp_rdctl_o;
assign mc0_rsp_stall_o = rsp_mem_stall[8];
assign mc1_req_ld_o = req_mem_ld[9];
assign mc1_req_st_o = req_mem_st[9];
assign mc1_req_size_o = 3;
assign mc1_req_flush_o = 0;
assign mc1_req_vadr_o = req_mem_addr[9];
assign mc1_req_wrd_rdctl_o = req_mem_d_or_tag[9];
assign req_mem_stall[9] = mc1_rd_rq_stall_o || mc1_wr_rq_stall_o;
assign rsp_mem_q[9] = mc1_rsp_data_o;
assign rsp_mem_push[9] = mc1_rsp_push_o;
assign rsp_mem_tag[9] = mc1_rsp_rdctl_o;
assign mc1_rsp_stall_o = rsp_mem_stall[9];
assign mc2_req_ld_o = req_mem_ld[10];
assign mc2_req_st_o = req_mem_st[10];
assign mc2_req_size_o = 3;
assign mc2_req_flush_o = 0;
assign mc2_req_vadr_o = req_mem_addr[10];
assign mc2_req_wrd_rdctl_o = req_mem_d_or_tag[10];
assign req_mem_stall[10] = mc2_rd_rq_stall_o || mc2_wr_rq_stall_o;
assign rsp_mem_q[10] = mc2_rsp_data_o;
assign rsp_mem_push[10] = mc2_rsp_push_o;
assign rsp_mem_tag[10] = mc2_rsp_rdctl_o;
assign mc2_rsp_stall_o = rsp_mem_stall[10];
assign mc3_req_ld_o = req_mem_ld[11];
assign mc3_req_st_o = req_mem_st[11];
assign mc3_req_size_o = 3;
assign mc3_req_flush_o = 0;
assign mc3_req_vadr_o = req_mem_addr[11];
assign mc3_req_wrd_rdctl_o = req_mem_d_or_tag[11];
assign req_mem_stall[11] = mc3_rd_rq_stall_o || mc3_wr_rq_stall_o;
assign rsp_mem_q[11] = mc3_rsp_data_o;
assign rsp_mem_push[11] = mc3_rsp_push_o;
assign rsp_mem_tag[11] = mc3_rsp_rdctl_o;
assign mc3_rsp_stall_o = rsp_mem_stall[11];
assign mc4_req_ld_o = req_mem_ld[12];
assign mc4_req_st_o = req_mem_st[12];
assign mc4_req_size_o = 3;
assign mc4_req_flush_o = 0;
assign mc4_req_vadr_o = req_mem_addr[12];
assign mc4_req_wrd_rdctl_o = req_mem_d_or_tag[12];
assign req_mem_stall[12] = mc4_rd_rq_stall_o || mc4_wr_rq_stall_o;
assign rsp_mem_q[12] = mc4_rsp_data_o;
assign rsp_mem_push[12] = mc4_rsp_push_o;
assign rsp_mem_tag[12] = mc4_rsp_rdctl_o;
assign mc4_rsp_stall_o = rsp_mem_stall[12];
assign mc5_req_ld_o = req_mem_ld[13];
assign mc5_req_st_o = req_mem_st[13];
assign mc5_req_size_o = 3;
assign mc5_req_flush_o = 0;
assign mc5_req_vadr_o = req_mem_addr[13];
assign mc5_req_wrd_rdctl_o = req_mem_d_or_tag[13];
assign req_mem_stall[13] = mc5_rd_rq_stall_o || mc5_wr_rq_stall_o;
assign rsp_mem_q[13] = mc5_rsp_data_o;
assign rsp_mem_push[13] = mc5_rsp_push_o;
assign rsp_mem_tag[13] = mc5_rsp_rdctl_o;
assign mc5_rsp_stall_o = rsp_mem_stall[13];
assign mc6_req_ld_o = req_mem_ld[14];
assign mc6_req_st_o = req_mem_st[14];
assign mc6_req_size_o = 3;
assign mc6_req_flush_o = 0;
assign mc6_req_vadr_o = req_mem_addr[14];
assign mc6_req_wrd_rdctl_o = req_mem_d_or_tag[14];
assign req_mem_stall[14] = mc6_rd_rq_stall_o || mc6_wr_rq_stall_o;
assign rsp_mem_q[14] = mc6_rsp_data_o;
assign rsp_mem_push[14] = mc6_rsp_push_o;
assign rsp_mem_tag[14] = mc6_rsp_rdctl_o;
assign mc6_rsp_stall_o = rsp_mem_stall[14];
assign mc7_req_ld_o = req_mem_ld[15];
assign mc7_req_st_o = req_mem_st[15];
assign mc7_req_size_o = 3;
assign mc7_req_flush_o = 0;
assign mc7_req_vadr_o = req_mem_addr[15];
assign mc7_req_wrd_rdctl_o = req_mem_d_or_tag[15];
assign req_mem_stall[15] = mc7_rd_rq_stall_o || mc7_wr_rq_stall_o;
assign rsp_mem_q[15] = mc7_rsp_data_o;
assign rsp_mem_push[15] = mc7_rsp_push_o;
assign rsp_mem_tag[15] = mc7_rsp_rdctl_o;
assign mc7_rsp_stall_o = rsp_mem_stall[15];

   //logic for using cae IMPORTANT. cae_idle should be 0 when executing a custom instruction and 1 otherwise.
   //cae_stall should be 1 when when exectuting a custom instruction and 0 otherwise.
   reg core_busy;
   assign cae_idle  = !core_busy;
   assign cae_stall = core_busy;
   //assign cae_idle  = core_busy;
   //assign cae_stall = !core_busy;



    always @(posedge clk_per) begin
        if(inst_caep == 5'd0 && inst_val) begin
            //TODO: add start logic for custom instruction
            //TODO: if more than one cycle long add cae_idle and cae_stall logic
            $display("@verilog:Hello World from simulated ae%d", i_aeid);
        end
    end

    reg send_instruction;
    always @(posedge clk_per) begin
        send_instruction <= 0;
        if(inst_caep == 5'd1 && inst_val) begin
            $display("@verilog:the instruction from simulated ae%d", i_aeid);
            send_instruction <= 1;
        end
    end
    localparam MIN_BUSY = 64;
    localparam LOG2_MIN_BUSY = log2(MIN_BUSY - 1);
    reg [LOG2_MIN_BUSY:0] min_busy_counter;
    always @(posedge clk_per) begin
        if(send_instruction)
            min_busy_counter[LOG2_MIN_BUSY] <= 1;
        if(min_busy_counter[LOG2_MIN_BUSY])
            min_busy_counter <= min_busy_counter + 1;
        if(reset_per)
            min_busy_counter <= 64;
    end
    wire [0:16] busy_connections;
    assign busy_connections[0] = 0;
    always @* core_busy = send_instruction || min_busy_counter[LOG2_MIN_BUSY] || busy_connections[16] || (inst_caep == 5'd1 && inst_val);
    always @(posedge clk) begin
        if(core_busy) begin
            $display("@verilog: core_busy");
            $display("@verilog: send_instruction: %d, min_busy_counter[LOG2_MIN_BUSY]: %d, busy_connections[16]: %d", send_instruction, min_busy_counter[LOG2_MIN_BUSY], busy_connections[16]);
        end
    end
    wire [63:0] instruction_connections [0:16];
    reg [63:0] instruction;
    reg [24:0] watch_dog_timer;
    always @(posedge clk) begin
        if(core_busy)
            watch_dog_timer <= watch_dog_timer + 1;
        else
            watch_dog_timer <= 0;
    end
    always @(posedge clk_per) begin
        instruction <= 0;
        if(send_instruction)
            instruction <= w_aeg[0];
        if(reset_per || (min_busy_counter[LOG2_MIN_BUSY] && instruction[OPCODE_ARG_PE:0] == 1) ||  watch_dog_timer[20]) begin
            instruction[OPCODE_ARG_PE - 1:0] <= 1;
            instruction[OPCODE_ARG_1 - 1:OPCODE_ARG_PE] <= 16;
        end
    end
    assign instruction_connections[0] = instruction;

    localparam SCRATCH_PAD_PORTS = 16;
    wire [0:SCRATCH_PAD_PORTS - 1] req_scratch_ld;
    wire [0:SCRATCH_PAD_PORTS - 1] req_scratch_st;
    wire [12:0] req_scratch_addr [0:SCRATCH_PAD_PORTS - 1];
    wire [63:0] req_scratch_d [0:SCRATCH_PAD_PORTS - 1];
    wire [0:SCRATCH_PAD_PORTS - 1] req_scratch_stall;
    wire [0:SCRATCH_PAD_PORTS - 1] rsp_scratch_push;
    wire [63:0] rsp_scratch_q [0:SCRATCH_PAD_PORTS - 1];
    wire [0:SCRATCH_PAD_PORTS - 1] rsp_scratch_stall;
    wire [13*SCRATCH_PAD_PORTS-1:0] req_scratch_addr_unrolled;
    wire [64*SCRATCH_PAD_PORTS-1:0] req_scratch_d_unrolled;
    wire [64*SCRATCH_PAD_PORTS-1:0] rsp_scratch_q_unrolled;
    generate for(g = 0; g < SCRATCH_PAD_PORTS; g = g + 1) begin:scratch_pad_unrolling
        assign req_scratch_addr_unrolled[(SCRATCH_PAD_PORTS-g)*13 - 1 -: 13] = req_scratch_addr[g];
        assign req_scratch_d_unrolled[(SCRATCH_PAD_PORTS-g)*64 - 1 -: 64] = req_scratch_d[g];
        assign rsp_scratch_q[g] = rsp_scratch_q_unrolled[(SCRATCH_PAD_PORTS-g)*64 -1 -:64];
    end endgenerate

    scratch_pad #(SCRATCH_PAD_PORTS, 64, 512, 64) shared_memory(reset_per, clk_per, req_scratch_ld, req_scratch_st, req_scratch_d_unrolled, rsp_scratch_q_unrolled, req_scratch_addr_unrolled, rsp_scratch_stall, rsp_scratch_push, req_scratch_stall);

    localparam PE_COUNT = 16;
    //TODO: add registers to instruction systolic array
    generate for(g = 0; g < PE_COUNT; g = g + 1) begin: gen_pe
        spmv_pe #(g) g_pe(clk_per, instruction_connections[g], instruction_connections[g+1], busy_connections[g], busy_connections[g+1],
            req_mem_ld[g], req_mem_st[g], req_mem_addr[g], req_mem_d_or_tag[g], req_mem_stall[g], rsp_mem_push[g], rsp_mem_tag[g], rsp_mem_q[g], rsp_mem_stall[g],
            req_scratch_ld[g], req_scratch_st[g], req_scratch_addr[g], req_scratch_d[g], req_scratch_stall[g], rsp_scratch_push[g], rsp_scratch_q[g], rsp_scratch_stall[g]);

        // synthesis translate_off
        always @(posedge clk) begin
            $display("@verilog: decoder_busy[%d]: %d", g, g_pe.decoder_busy);
        end
        // synthesis translate_on

    end endgenerate
    assign return_op = instruction_connections[PE_COUNT];

    generate for(g = PE_COUNT; g < 16; g = g + 1) begin: gen_mem_signals
        assign req_mem_ld[g] = 0;
        assign req_mem_st[g] = 0;
        assign req_mem_addr[g] = 0;
        assign req_mem_d_or_tag[g] = 0;
        assign rsp_mem_stall[g] = 0;
        assign busy_connections[g + 1] = busy_connections[g];
    end endgenerate
    generate for(g = PE_COUNT; g < SCRATCH_PAD_PORTS; g = g + 1) begin: gen_scratch_mem_signals
        assign req_scratch_ld[g] = 0;
        assign req_scratch_st[g] = 0;
        assign req_scratch_addr[g] = 0;
        assign req_scratch_d[g] = 0;
        assign rsp_scratch_stall[g] = 0;
    end endgenerate

    // synthesis translate_off
    integer i;
    always @(posedge clk) begin
        $display("@verilog: cae_pers debug %d", $time);
        for(i = 0; i < PE_COUNT + 1; i = i + 1) begin
            $display("@verilog: busy[%d]: %d", i, busy_connections[i]);
            //$display("@verilog: decoder_busy[%d]", i, gen_pe[i].g_pe.decoder_busy);
        end

        //$display("@verilog: request: req_ld: %d req_st: %d req_stall_rd: %d, req_stall_wr: %d", mc0_req_ld_e, mc0_req_st_e, mc0_rd_rq_stall_e, mc0_wr_rq_stall_e);
        //$display("@verilog: request address: %H", mc0_req_vadr_e);
        //$display("@verilog: response: push %d, stall: %d", mc0_rsp_push_e, mc0_rsp_stall_e);
    end
    // synthesis translate_on

    /* ---------- debug & synopsys off blocks  ---------- */

    // synopsys translate_off

    // Parameters: 1-Severity: Don't Stop, 2-start check only after negedge of reset
    //assert_never #(1, 2, "***ERROR ASSERT: unimplemented instruction cracked") a0 (.clk(clk), .reset_n(~reset), .test_expr(r_unimplemented_inst));

    // synopsys translate_on

    `include "common.vh"
endmodule // cae_pers
