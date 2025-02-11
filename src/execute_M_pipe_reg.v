// Include the definitions from "define.v" file
`include "define.v"

module execute_M_pipe_reg(
    // Inputs
    input wire clk_i,             // Clock input
    input wire M_stall_i,         // Stall signal for the M stage
    input wire M_bubble_i,        // Bubble signal for the M stage
    input wire [2:0] e_stat_i,    // Status from the E stage
    input wire [63:0] e_pc_i,     // Program counter from the E stage
    input wire [3:0] e_icode_i,   // Instruction code from the E stage
    input wire [3:0] e_ifun_i,    // Instruction function from the E stage
    input wire e_Cnd_i,           // Condition signal from the E stage
    input wire [63:0] e_valE_i,   // Value E from the E stage
    input wire [63:0] e_valA_i,   // Value A from the E stage
    input wire [3:0] e_dstE_i,    // Destination E from the E stage
    input wire [3:0] e_dstM_i,    // Destination M from the E stage

    // Outputs
    output reg [2:0] M_stat_o,    // Status to the M stage
    output reg [63:0] M_pc_o,     // Program counter to the M stage
    output reg [3:0] M_icode_o,   // Instruction code to the M stage
    output reg [3:0] M_ifun_o,    // Instruction function to the M stage
    output reg M_Cnd_o,           // Condition signal to the M stage
    output reg [63:0] M_valE_o,   // Value E to the M stage
    output reg [63:0] M_valA_o,   // Value A to the M stage
    output reg [3:0] M_dstE_o,    // Destination E to the M stage
    output reg [3:0] M_dstM_o     // Destination M to the M stage
);

// Module logic and register assignments would go here
always @(posedge clk_i) begin
    if (M_bubble_i) begin
        // Insert a bubble (stall) into the pipeline
        M_stat_o <= e_stat_i; 
        M_pc_o <= 64'b0;
        M_icode_o <= `INOP; // Assuming INOP is defined in "define.v"
        M_ifun_o <= 4'b0;
        M_Cnd_o <= 1'b0;
        M_valE_o <= 64'b0;
        M_valA_o <= 64'b0;
        M_dstE_o <= `RNONE; // Assuming RNONE is defined in "define.v"
        M_dstM_o <= `RNONE; // Assuming RNONE is defined in "define.v"
    end
    else if (~M_stall_i) begin
        // No stall, so pass the values through the pipeline
        M_stat_o <= e_stat_i;
        M_pc_o <= e_pc_i;
        M_icode_o <= e_icode_i;
        M_ifun_o <= e_ifun_i;
        M_Cnd_o <= e_Cnd_i;
        M_valE_o <= e_valE_i;
        M_valA_o <= e_valA_i;
        M_dstE_o <= e_dstE_i;
        M_dstM_o <= e_dstM_i;
    end
end

endmodule