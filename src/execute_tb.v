`timescale 1ns/1ps
`include "define.v"
`include "fetch.v"
`include "fetch_D_pipe_reg.v"
`include "decode.v"
`include "decode_E_pipe_reg.v"
`include "execute.v"
`include "execute_M_pipe_reg.v"
module execute_tb;
reg clk;

initial begin
    clk = 0; 
    forever #5 clk = ~clk; 
end
reg rst_n; 

initial begin
    rst_n = 1'b0; 
   
    #1 rst_n = 1'b1; 
end


    wire F_stall;
    wire F_bubble;
    wire F_predPC;
	
    reg[63:0] f_pc;

    wire[2:0] f_stat;
    wire[3:0] f_icode;
    wire[3:0] f_ifun;
	wire[3:0] f_rA;
	wire[3:0] f_rB;
	wire[63:0] f_valC;
	wire[63:0] f_valP;
    wire[63:0] f_predPC;

    wire D_stall;
    wire D_bubble;
    wire [2:0] D_stat;
    wire [63:0] D_pc;
    wire [3:0] D_icode;
    wire [3:0] D_ifun;
    wire [3:0] D_rA;
    wire [3:0] D_rB;
    wire[63:0] D_valC;
	wire[63:0] D_valP;

	fetch fetch_tb(
		.PC_i(f_pc),
		.icode_o(f_icode),
		.ifun_o(f_ifun),
		.rA_o(f_rA),
		.rB_o(f_rB),
		.valC_o(f_valC),
		.valP_o(f_valP),
		.predPC_o(f_predPC),
		.stat_o(f_stat)
	);

    assign D_stall=1'b0;
    assign D_bubble=1'b0;

    fetch_D_pipe_reg dreg(
        .clk_i(clk),
        .D_stall_i(D_stall),
        .D_bubble_i(D_bubble),
        
        .f_stat_i(f_stat),
        .f_pc_i(f_pc),
        .f_icode_i(f_icode),
        .f_ifun_i(f_ifun),
        .f_rA_i(f_rA),
        .f_rB_i(f_rB),
        .f_valC_i(f_valC),
        .f_valP_i(f_valP),

        .D_stat_o(D_stat),
        .D_pc_o(D_pc),
        .D_icode_o(D_icode),
        .D_ifun_o(D_ifun),
        .D_rA_o(D_rA),
        .D_rB_o(D_rB),
        .D_valC_o(D_valC),
        .D_valP_o(D_valP)
    );

    wire E_stall;
    wire E_bubble;

    assign E_stall=1'b0;
    assign E_bubble=1'b0;

    wire[2:0] E_stat;
    wire[3:0] E_icode;
    wire[3:0] E_ifun;
	wire[63:0] E_valA;
	wire[63:0] E_valB;
    wire[63:0] E_valC;
	wire[3:0] E_dstE;
	wire[3:0] E_dstM;
    wire[3:0] E_srcA;
    wire[3:0] E_srcB;

    wire [63:0] e_valE;
    wire [3:0] e_dstE;
    wire e_Cnd;

    wire e_rst=rst_n;

wire [3:0] M_dstM;
wire [63:0] m_valM;
wire [3:0] M_dstE;
wire [63:0] M_valE;
wire [3:0] W_dstM;
wire [63:0] W_valM;
wire [3:0] W_dstE;
wire [63:0] W_valE;


wire [63:0] d_valA;
wire [63:0] d_valB;
wire [3:0] d_dstE;
wire [3:0] d_dstM;
wire [3:0] d_srcA;
wire [3:0] d_srcB;

    decode decode_stage(
        .clk_i(clk), 
        .D_icode_i(D_icode), 
        .D_rA_i(D_rA),
        .D_rB_i(D_rB), 
        .D_valP_i(D_valP), 

        .e_dstE_i(e_dstE), 
        .e_valE_i(e_valE), 
        .M_dstM_i(M_dstM), 
        .m_valM_i(m_valM), 
        .M_dstE_i(M_dstE), 
        .M_valE_i(M_valE), 
        .W_dstM_i(W_dstM), 
        .W_valM_i(W_valM), 
        .W_dstE_i(W_dstE), 
        .W_valE_i(W_valE),

        .d_valA_o(d_valA), 
        .d_valB_o(d_valB), 
        .d_dstE_o(d_dstE), 
        .d_dstM_o(d_dstM), 
        .d_srcA_o(d_srcA), 
        .d_srcB_o(d_srcB)  
    );


    decode_E_pipe_reg ereg(
        .clk_i(clk),
        .E_stall_i(E_stall),
        .E_bubble_i(E_bubble),
        
        .d_stat_i(D_stat),
        .d_pc_i(D_pc),
        .d_icode_i(D_icode),
        .d_ifun_i(D_ifun),
        .d_valC_i(D_valC),
        .d_valA_i(d_valA),
        .d_valB_i(d_valB),
        .d_dstM_i(d_dstM),
        .d_dstE_i(d_dstE),
        .d_srcA_i(d_srcA),
        .d_srcB_i(d_srcB),
        
        .E_stat_o(E_stat),
        .E_pc_o(E_pc),
        .E_icode_o(E_icode),
        .E_ifun_o(E_ifun),
        .E_valC_o(E_valC),
        .E_valA_o(E_valA),
        .E_valB_o(E_valB),
        .E_dstE_o(E_dstE),
        .E_dstM_o(E_dstM),
        .E_srcA_o(E_srcA),
        .E_srcB_o(E_srcB)
    );

    // Instantiation of the execute stage module
    execute execute_stage (
        .clk_i(clk),
        .rst_n_i(e_rst),

        .icode_i(E_icode),
        .ifun_i(E_ifun),
        .E_dstE_i(E_dstE),
        .valA_i(E_valA),
        .valB_i(E_valB),
        .valC_i(E_valC),
        .m_stat_i(m_stat),
        .W_stat_i(W_stat),

        .valE_o(e_valE),
        .dstE_o(e_dstE),
        .e_Cnd_o(e_Cnd)
    );

wire M_stall;
wire M_bubble;
assign M_stall = 1'b0;
assign M_bubble = 1'b0;

wire [2:0] M_stat;
wire [63:0] M_pc;
wire [3:0] M_icode;
wire [3:0] M_ifun;
wire M_Cnd;
wire [63:0] M_valA;

    // Instantiation of the pipeline register for the execute-Memory stage
    execute_M_pipe_reg mreg (
        .clk_i(clk),
        .M_stall_i(M_stall),
        .M_bubble_i(M_bubble),

        .e_stat_i(E_stat),
        .e_pc_i(E_pc),
        .e_icode_i(E_icode),
        .e_ifun_i(E_ifun),
        .e_Cnd_i(e_Cnd),
        .e_valE_i(e_valE),
        .e_valA_i(E_valA),
        .e_dstE_i(e_dstE),
        .e_dstM_i(E_dstM),

        .M_stat_o(M_stat),
        .M_pc_o(M_pc),
        .M_icode_o(M_icode),         
	    .M_ifun_o(M_ifun),
        .M_Cnd_o(M_Cnd),
        .M_valE_o(M_valE),
        .M_valA_o(M_valA),
        .M_dstE_o(M_dstE),
        .M_dstM_o(M_dstM)
    );


always @(posedge clk) begin
    f_pc <= f_valP;
end
	initial begin
        $dumpfile("./wave/execute.vcd");  // 指定VCD文件的名字为wave.vcd，仿真信息将记录到此文件
	    $dumpvars(0, execute_tb );  // 指定层次数为0，则tb_code 模块及其下面各层次的所有信号将被记录
		f_pc=64'h0;
		#40  $finish; 
	end
	
    	initial
        $monitor("Time=%0t,fetch: D_PC=%h, D_icode=%h, D_ifun=%h, D_rA=%h, D_rB=%h, D_valC=%h, D_valP=%h,\n\tdecode:e_icode=%h, e_ifun=%h, d_srcA=%h, d_srcB=%h, d_valA=%h, d_valB=%h, e_srcA=%h, e_srcB=%h,\n\texecute: M_icode=%h, M_ifun_o=%h, M_valE=%h, M_valA=%h",$time, D_pc, D_icode, D_ifun, D_rA, D_rB, D_valC, D_valP,E_icode, E_ifun, d_srcA, d_srcB, d_valA, d_valB, E_srcA, E_srcB,M_icode,M_ifun,M_valE,M_valA);
endmodule