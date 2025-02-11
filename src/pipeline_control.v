`include "define.v"
module pipeline_control (
    input clk,
    input rst_n,

    // 输入信号
    input [3:0] D_icode_i,    // 解码阶段的指令码
    input [3:0] d_srcA_i,     // 解码阶段的源寄存器 A
    input [3:0] d_srcB_i,     // 解码阶段的源寄存器 B

    input [3:0] E_icode_i,    // 执行阶段的指令码
    input [3:0] E_dstM_i,     // 执行阶段的目标寄存器（访存）
    input e_Cnd_i,            // 执行阶段的条件码
    
    input  wire [3:0] M_icode_i,
    input  wire [2:0] m_stat_i,

    input wire [2:0] W_stat_i,
   

    // 输出信号
    output wire F_stall_o,     // 取指阶段暂停
    output wire D_stall_o,     // 解码阶段暂停
    output wire W_stall_o,
    output wire D_bubble_o,    // 解码阶段插入气泡
    output wire E_bubble_o,    // 执行阶段插入气泡
    output wire M_bubble_o,    // 取指阶段插入气泡
    output wire set_cc_o
);
// Load/Use Hazard: Stall Fetch and Decode stages if a load instruction is followed by an instruction that uses the loaded value
assign F_stall_o = ((E_icode_i == `IMRMOVQ || E_icode_i == `IPOPQ) && 
                    (E_dstM_i == d_srcA_i || E_dstM_i == d_srcB_i)) || 
                   (D_icode_i == `IRET || E_icode_i == `IRET || M_icode_i == `IRET);

// Stall Decode stage if a load instruction is followed by an instruction that uses the loaded value
assign D_stall_o = (E_icode_i == `IMRMOVQ || E_icode_i == `IPOPQ) && 
                   (E_dstM_i == d_srcA_i || E_dstM_i == d_srcB_i);

// Bubble Decode stage if a branch is mispredicted, but not if there is a Load/Use hazard or RET instruction
assign D_bubble_o = ((E_icode_i == `IJXX) & (~e_Cnd_i)) && 
                    ~((E_icode_i == `IMRMOVQ || E_icode_i == `IPOPQ) && 
                      (E_dstM_i == d_srcA_i || E_dstM_i == d_srcB_i)) && 
                    ~(D_icode_i == `IRET || E_icode_i == `IRET || M_icode_i == `IRET);

// Bubble Execute stage if a branch is mispredicted or there is a Load/Use hazard
assign E_bubble_o = ((E_icode_i == `IJXX) & (~e_Cnd_i)) || 
                    ((E_icode_i == `IMRMOVQ || E_icode_i == `IPOPQ) && 
                     (E_dstM_i == d_srcA_i || E_dstM_i == d_srcB_i));

// Bubble Memory stage if there is a memory error or halt condition
assign M_bubble_o = (m_stat_i == `SADR || m_stat_i == `SINS || m_stat_i == `SHLT) || 
                    (W_stat_i == `SADR || W_stat_i == `SINS || W_stat_i == `SHLT);

// Stall Writeback stage if there is a memory error or halt condition
assign W_stall_o = (W_stat_i == `SADR || W_stat_i == `SINS || W_stat_i == `SHLT);

endmodule