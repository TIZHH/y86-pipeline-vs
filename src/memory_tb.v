`timescale 1ns/1ps
`include "define.v"
`include "F_pipe_reg.v"
`include "select_pc.v"
`include "fetch.v"
`include "fetch_D_pipe_reg.v"
`include "decode.v"
`include "decode_E_pipe_reg.v"
`include "execute.v"
`include "execute_M_pipe_reg.v"
`include "memory_access.v"
`include "memory_access_W_pipe_reg.v"
module memory_tb;



    reg clk;
    initial begin
        clk = 0; 
        forever #5 clk = ~clk; 
    end
    reg rst_n; 

    wire F_stall;
    wire F_bubble;
    assign F_stall=1'b0;
    assign F_bubble=1'b0;
	
    wire [63:0] f_predPC;  // 可以设置为常数或者其他值来模拟预测程序计数器
    wire[63:0] F_predPC;
    wire[63:0] f_pc;

    F_pipe_reg Freg(
            .clk_i(clk),                // 时钟信号
            .rst_i(rst_n),
            .F_stall_i(F_stall),        // 取指阶段的流水线暂停信号
            .F_bubble_i(F_bubble),      // 取指阶段的流水线气泡信号
            .f_predPC_i(f_predPC),
            .F_predPC_o(F_predPC)
    );

    wire [3:0] M_dstM;
    wire [63:0] m_valM;
    wire [3:0] M_dstE;
    wire [63:0] M_valE;
    wire [3:0] W_dstM;
    wire [63:0] W_valM;
    wire [3:0] W_dstE;
    wire [63:0] W_valE;

    wire [2:0] M_stat;
    wire [63:0] M_pc;
    wire [3:0] M_icode;
    wire [3:0] M_ifun;
    wire M_Cnd;
    wire [63:0] M_valA;

    wire [3:0] W_icode;
    select_pc select_stage(
        .F_predPC_i(F_predPC),
        .M_icode_i(M_icode),
        .W_icode_i(W_icode),
        .M_valA_i(M_valA),
        .W_valM_i(W_valM),
        .M_Cnd_i(M_Cnd),
        .f_pc_o(f_pc)
    );

    wire[2:0] f_stat;
    wire[3:0] f_icode;
    wire[3:0] f_ifun;
	wire[3:0] f_rA;
	wire[3:0] f_rB;
	wire[63:0] f_valC;
	wire[63:0] f_valP;


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

    fetch fetch_stage(
        .PC_i(f_pc),                // 取指阶段的程序计数器值
        .icode_o(f_icode),          // 取指阶段的指令代码
        .ifun_o(f_ifun),            // 取指阶段的指令功能码
        .rA_o(f_rA),                // 取指阶段的寄存器A
        .rB_o(f_rB),                // 取指阶段的寄存器B
        .valC_o(f_valC),            // 取指阶段的C操作数值
        .valP_o(f_valP),            // 取指阶段的下一条指令地址
        .predPC_o(f_predPC),        // 取指阶段的预测程序计数器值
        .stat_o(f_stat)             // 取指阶段的状态信号
    );
    assign D_stall=1'b0;
    assign D_bubble=1'b0;
    fetch_D_pipe_reg Dreg(
        .clk_i(clk),                // 时钟信号
        .D_stall_i(D_stall),        // 取指-解码阶段的流水线暂停信号
        .D_bubble_i(D_bubble),      // 取指-解码阶段的流水线气泡信号
        
        .f_stat_i(f_stat),          // 取指阶段的状态信号
        .f_pc_i(f_pc),              // 取指阶段的程序计数器值
        .f_icode_i(f_icode),        // 取指阶段的指令代码
        .f_ifun_i(f_ifun),          // 取指阶段的指令功能码
        .f_rA_i(f_rA),              // 取指阶段的寄存器A
        .f_rB_i(f_rB),              // 取指阶段的寄存器B
        .f_valC_i(f_valC),          // 取指阶段的C操作数值
        .f_valP_i(f_valP),          // 取指阶段的下一条指令地址

        .D_stat_o(D_stat),          // 解码阶段的状态信号
        .D_pc_o(D_pc),              // 解码阶段的程序计数器值
        .D_icode_o(D_icode),        // 解码阶段的指令代码
        .D_ifun_o(D_ifun),          // 解码阶段的指令功能码
        .D_rA_o(D_rA),              // 解码阶段的寄存器A
        .D_rB_o(D_rB),              // 解码阶段的寄存器B
        .D_valC_o(D_valC),          // 解码阶段的C操作数值
        .D_valP_o(D_valP)           // 解码阶段的下一条指令地址
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

    wire [63:0] d_valA;
    wire [63:0] d_valB;
    wire [3:0] d_dstE;
    wire [3:0] d_dstM;
    wire [3:0] d_srcA;
    wire [3:0] d_srcB;

    decode decode_stage(
    .clk_i(clk),                // 时钟信号
    .D_icode_i(D_icode),        // 解码阶段的指令代码
    .D_rA_i(D_rA),              // 解码阶段的寄存器A
    .D_rB_i(D_rB),              // 解码阶段的寄存器B
    .D_valP_i(D_valP),          // 解码阶段的下一条指令地址

    .e_dstE_i(e_dstE),          // 执行阶段的目标寄存器E
    .e_valE_i(e_valE),          // 执行阶段的计算结果值
    .M_dstM_i(M_dstM),          // 访存阶段的目标寄存器M
    .m_valM_i(m_valM),          // 访存阶段的访存读取值
    .M_dstE_i(M_dstE),          // 访存阶段的目标寄存器E
    .M_valE_i(M_valE),          // 访存阶段的计算结果值
    .W_dstM_i(W_dstM),          // 写回阶段的目标寄存器M
    .W_valM_i(W_valM),          // 写回阶段的访存读取值
    .W_dstE_i(W_dstE),          // 写回阶段的目标寄存器E
    .W_valE_i(W_valE),          // 写回阶段的计算结果值

    .d_valA_o(d_valA),          // 解码阶段的A操作数值
    .d_valB_o(d_valB),          // 解码阶段的B操作数值
    .d_dstE_o(d_dstE),          // 解码阶段的目标寄存器E
    .d_dstM_o(d_dstM),          // 解码阶段的目标寄存器M
    .d_srcA_o(d_srcA),          // 解码阶段的源寄存器A
    .d_srcB_o(d_srcB)           // 解码阶段的源寄存器B
    );

    wire [63:0] E_pc;

    decode_E_pipe_reg Ereg(
    .clk_i(clk),                // 时钟信号
    .E_stall_i(E_stall),        // 解码-执行阶段的流水线暂停信号
    .E_bubble_i(E_bubble),      // 解码-执行阶段的流水线气泡信号
    
    .d_stat_i(D_stat),          // 解码阶段的状态信号
    .d_pc_i(D_pc),              // 解码阶段的程序计数器值
    .d_icode_i(D_icode),        // 解码阶段的指令代码
    .d_ifun_i(D_ifun),          // 解码阶段的指令功能码
    .d_valC_i(D_valC),          // 解码阶段的C操作数值
    .d_valA_i(d_valA),          // 解码阶段的A操作数值
    .d_valB_i(d_valB),          // 解码阶段的B操作数值
    .d_dstM_i(d_dstM),          // 解码阶段的目标寄存器M
    .d_dstE_i(d_dstE),          // 解码阶段的目标寄存器E
    .d_srcA_i(d_srcA),          // 解码阶段的源寄存器A
    .d_srcB_i(d_srcB),          // 解码阶段的源寄存器B
    
    .E_stat_o(E_stat),          // 执行阶段的状态信号
    .E_pc_o(E_pc),              // 执行阶段的程序计数器值
    .E_icode_o(E_icode),        // 执行阶段的指令代码
    .E_ifun_o(E_ifun),          // 执行阶段的指令功能码
    .E_valC_o(E_valC),          // 执行阶段的C操作数值
    .E_valA_o(E_valA),          // 执行阶段的A操作数值
    .E_valB_o(E_valB),          // 执行阶段的B操作数值
    .E_dstE_o(E_dstE),          // 执行阶段的目标寄存器E
    .E_dstM_o(E_dstM),          // 执行阶段的目标寄存器M
    .E_srcA_o(E_srcA),          // 执行阶段的源寄存器A
    .E_srcB_o(E_srcB)           // 执行阶段的源寄存器B
    );
    wire [2:0] W_stat;
    wire [2:0] m_stat;
    execute execute_stage (
        .clk_i(clk),                // 时钟信号
        .rst_n_i(e_rst),            // 复位信号（低电平有效）

        .icode_i(E_icode),          // 执行阶段的指令代码
        .ifun_i(E_ifun),            // 执行阶段的指令功能码
        .E_dstE_i(E_dstE),          // 执行阶段的目标寄存器E
        .valA_i(E_valA),            // 执行阶段的A操作数值
        .valB_i(E_valB),            // 执行阶段的B操作数值
        .valC_i(E_valC),            // 执行阶段的C操作数值
        .m_stat_i(m_stat),          // 访存阶段的状态信号
        .W_stat_i(W_stat),          // 写回阶段的状态信号

        .valE_o(e_valE),            // 执行阶段计算的结果值
        .dstE_o(e_dstE),            // 执行阶段的目标寄存器E
        .e_Cnd_o(e_Cnd)             // 执行阶段的条件码
    );

    wire M_stall;
    wire M_bubble;
    assign M_stall = 1'b0;
    assign M_bubble = 1'b0;


// 执行-访存阶段的流水线寄存器实例化
execute_M_pipe_reg Mreg (
    // 时钟信号，用于同步所有寄存器
    .clk_i(clk),  // 输入时钟信号

    // 流水线暂停和气泡控制信号
    .M_stall_i(M_stall),  // 指示流水线是否暂停（防止流水线继续执行）
    .M_bubble_i(M_bubble),  // 指示是否在流水线中插入气泡（即空操作）

    // 从执行阶段（E阶段）传入的输入信号
    .e_stat_i(E_stat),  // 执行阶段的状态信号（例如错误标志或条件）
    .e_pc_i(E_pc),  // 执行阶段的程序计数器值
    .e_icode_i(E_icode),  // 执行阶段的指令码
    .e_ifun_i(E_ifun),  // 执行阶段的功能码（指令的附加功能）
    .e_Cnd_i(e_Cnd),  // 执行阶段的条件标志（例如分支是否成立）
    .e_valE_i(e_valE),  // 执行阶段计算的结果（ALU计算结果）
    .e_valA_i(E_valA),  // 执行阶段的另一个值，可能是寄存器的值或操作数
    .e_dstE_i(e_dstE),  // 执行阶段的目标寄存器（存储ALU计算结果的寄存器）
    .e_dstM_i(E_dstM),  // 传递给访存阶段的目标寄存器（可能用于访存写操作）

    // 从执行阶段传递到访存阶段（M阶段）的输出信号
    .M_stat_o(M_stat),  // 传递到访存阶段的状态信号
    .M_pc_o(M_pc),  // 传递到访存阶段的程序计数器值
    .M_icode_o(M_icode),  // 传递到访存阶段的指令码
    .M_ifun_o(M_ifun),  // 传递到访存阶段的功能码
    .M_Cnd_o(M_Cnd),  // 传递到访存阶段的条件标志
    .M_valE_o(M_valE),  // 传递到访存阶段的计算结果（ALU的计算值）
    .M_valA_o(M_valA),  // 传递到访存阶段的值（可能用于访存地址计算）
    .M_dstE_o(M_dstE),  // 从执行阶段传递到访存阶段的目标寄存器
    .M_dstM_o(M_dstM)   // 传递到访存阶段的目标寄存器（用于写回寄存器）
);

// Memory stage
memory_access memory_access_stage (
    .clk_i(clk),                // 时钟信号
    .M_icode_i(M_icode),        // 从执行阶段传来的指令编码
    .M_valE_i(M_valE),          // 从执行阶段传来的执行结果（ALU计算结果）
    .M_valA_i(M_valA),          // 从执行阶段传来的第二个操作数（通常是寄存器的值）
    .M_stat_i(M_stat),          // 从执行阶段传来的状态信息（用于错误检查等）
    
    .m_valM_o(m_valM),          // 访存阶段输出的访存读取结果
    .m_stat_o(m_stat)           // 访存阶段输出的状态信息
);


// Assign stall and bubble signals
wire W_stall;
wire W_bubble;
assign W_stall = 1'b0;
assign W_bubble = 1'b0;
wire[63:0] W_pc;

// Memory-Writeback Pipeline Register
memory_access_W_pipe_reg Wreg (
    .clk_i(clk),                  // 时钟信号
    .W_stall_i(W_stall),          // 写回阶段的停顿信号，指示是否暂停流水线
    .W_bubble_i(W_bubble),        // 写回阶段的气泡信号，用于引入流水线气泡，避免冲突

    .m_stat_i(m_stat),            // 从访存阶段传来的状态信息（用于错误检查等）
    .m_pc_i(M_pc),                // 从访存阶段传来的程序计数器值
    .m_icode_i(M_icode),          // 从访存阶段传来的指令编码
    .M_valE_i(M_valE),            // 从访存阶段传来的执行结果（ALU计算结果）
    .m_valM_i(m_valM),            // 从访存阶段传来的访存读取结果
    .M_dstE_i(M_dstE),            // 从访存阶段传来的执行结果目标寄存器编号
    .M_dstM_i(M_dstM),            // 从访存阶段传来的访存操作目标寄存器编号

    .W_stat_o(W_stat),            // 写回阶段的状态输出信号
    .W_pc_o(W_pc),                // 写回阶段的程序计数器输出
    .W_icode_o(W_icode),          // 写回阶段的指令编码输出
    .W_valE_o(W_valE),            // 写回阶段的执行结果输出f_pF
    .W_valM_o(W_valM),            // 写回阶段的访存读取结果输出
    .W_dstE_o(W_dstE),            // 写回阶段的执行结果目标寄存器输出
    .W_dstM_o(W_dstM)             // 写回阶段的访存操作目标寄存器输出
);

initial begin
    $dumpfile("./wave/memory.vcd");  // 指定VCD文件的名字为wave.vcd，仿真信息将记录到此文件
    $dumpvars(0, memory_tb );  // 指定层次数为0，则tb_code 模块及其下面各层次的所有信号将被记录

    #1 clk=0;
    #1 rst_n=0;
    
    #1 clk=1;
    #1 rst_n=1;
    #1 clk=0;

    
    #120  $finish;
end

initial begin
    // $monitor("Time=%0t, fetch: D_PC=%d, D_icode=%h, D_ifun=%h, D_rA=%h, D_rB=%h, D_valC=%h, D_valP=%h,",$time, D_pc, D_icode, D_ifun, D_rA, D_rB, D_valC, D_valP);
    // $monitor("decode: E_pc=%d, E_icode=%h, E_ifun=%h, E_valC=%h, E_valA=%h, E_valB=%h, E_srcA=%h, E_srcB=%h,",E_pc, E_icode, E_ifun, E_valC, E_valA, E_valB, E_srcA, E_srcB);
    // $monitor("execute: M_pc=%d, M_icode=%h, M_ifun=%h, M_valE=%h, M_valA=%h,",M_pc, M_icode, M_ifun, M_valE, M_valA);
    // $monitor("memory: W_pc=%d, W_icode=%h, W_valE=%h, W_valM=%h",W_pc, W_icode, W_valE, W_valM);
    $monitor("Time=%0t,\n\tfetch  : D_PC=%4d, D_icode=%h, D_ifun=%h, D_rA=%h, D_rB=%h, D_valC=%h, D_valP=%h\n\tdecode : E_pc=%4d, E_icode=%h, E_ifun=%h, E_valC=%h, E_valA=%h, E_valB=%h, E_srcA=%h, E_srcB=%h\n\texecute: M_pc=%4d, M_icode=%h, M_ifun=%h, M_valE=%h, M_valA=%h\n\tmemory : W_pc=%4d, W_icode=%h, W_valE=%h, W_valM=%h",$time, D_pc, D_icode, D_ifun, D_rA, D_rB, D_valC, D_valP,E_pc, E_icode, E_ifun, E_valC, E_valA, E_valB, E_srcA, E_srcB,M_pc, M_icode, M_ifun, M_valE, M_valA,W_pc, W_icode, W_valE, W_valM);
end
endmodule