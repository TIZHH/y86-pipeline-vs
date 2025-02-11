`timescale 1ns/1ps
`include "define.v"
`include "fetch.v"
`include "fetch_D_pipe_reg.v"
`include "decode.v"
`include "decode_E_pipe_reg.v"
module decode_tb;
reg clk;

initial begin
    clk = 0; 
    forever #5 clk = ~clk; 
end
reg rst_n; // 声明 rst_n 为一个寄存器

initial begin
    rst_n = 1'b0; // 初始化 rst_n 为低电平
    // ... 其他初始化代码 ...
    #1 rst_n = 1'b1; // 在某个时间点将 rst_n 设置为高电平，例如复位后
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
always @(posedge clk) begin
    // 假设这里有代码在每个时钟上升沿改变D_pc或其他信号
    f_pc <= f_valP;
end
	initial begin
         $dumpfile("./wave/decode.vcd");  
	    $dumpvars(0, decode_tb );  
		f_pc=64'h0;
		#40  $finish; // 假设你想在仿真开始后45ns结束
	end
	
    	initial
        $monitor("Time=%0t, fetch:D_PC=%h, D_icode=%h, D_ifun=%h, D_rA=%h, D_rB=%h, D_valC=%h, D_valP=%h,\n\tdecode:e_icode=%h, e_ifun=%h, d_srcA=%h, d_srcB=%h, d_valA=%h, d_valB=%h, e_srcA=%h, e_srcB=%h",$time, D_pc, D_icode, D_ifun, D_rA, D_rB, D_valC, D_valP,E_icode, E_ifun, d_srcA, d_srcB, d_valA, d_valB, E_srcA, E_srcB);

endmodule