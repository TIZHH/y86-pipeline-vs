module fwd(
 // Inputs
    input wire [3:0] d_srcB_i,         // 4-bit source A register address input for D stage
    
    input wire [3:0] e_dstE_i,         // 4-bit destination register address input for E stage
    input wire [63:0] e_valE_i,        // 64-bit value to be written back from E stage
    
    input wire [3:0] M_dstM_i,         // 4-bit destination register address input for M stage
    input wire [63:0] m_valM_i,        // 64-bit value to be written back from M stage
    
    input wire [3:0] M_dstE_i,         // 4-bit destination register address input for M stage
    input wire [63:0] M_valE_i,        // 64-bit value to be written back from M stage
    
    input wire [3:0] W_dstM_i,         // 4-bit destination register address input for W stage
    input wire [63:0] W_valM_i,        // 64-bit value to be written back from W stage
    
    input wire [3:0] W_dstE_i,         // 4-bit destination register address input for W stage
    input wire [63:0] W_valE_i,        // 64-bit value to be written back from W stage
    
    input wire [63:0] d_rvalB_i,       // 64-bit value of source A register from D stage

    // Output
    output wire [63:0] fwdB_valA_o     // 64-bit forwarded value for A operand
);
    //这里是有优先级的
assign fwdA_valA_o =((d_srcB_i==e_dstE_i)?e_valE_i:
                    (d_srcB_i==M_dstM_i)?m_valM_i:
                    (d_srcA_i==M_dstE_i)?M_valE_i:
                    (d_srcB_i==W_dstM_i)?W_valM_i:
                    (d_srcB_i==W_dstE_i)?W_valE_i:d_rvalB_i);

endmodule