module F_pipe_reg (
    input wire clk_i,               // 时钟信号
    input wire rst_i,
    input wire F_stall_i,           // 取指阶段的流水线暂停信号
    input wire F_bubble_i,          // 取指阶段的流水线气泡信号
    input wire [63:0] f_predPC_i,  // 预测的程序计数器输入
    output wire [63:0] F_predPC_o // 预测的程序计数器输出
);
    reg[63:0] predPC;
    // 时钟上升沿触发
    always @(posedge clk_i) begin
        if(~rst_i)begin
            predPC<=64'h0;
        end
        // 如果流水线暂停或气泡信号有效
        else if (F_stall_i) begin
            predPC <= predPC;  // 保持当前值
        end else if(F_bubble_i)begin
            predPC <= 64'b0;
        end else begin
            predPC <= f_predPC_i;  // 更新为输入的预测程序计数器值
        end
    end
    assign F_predPC_o=predPC;
endmodule
