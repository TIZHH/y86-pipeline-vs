`include "define.v"
`include "ram.v"

module memory_access (
    input wire clk_i,
    input wire [3:0] M_icode_i,
    input wire [63:0] M_valE_i,  // ALU 计算的地址
    input wire [63:0] M_valA_i,  // 要写入内存的数据
    input wire [2:0] M_stat_i,

    output wire [63:0] m_valM_o,  // 从内存读取的数据
    output wire [2:0] m_stat_o
);

    reg r_en;
    reg w_en;
    wire dmem_error;
    reg [63:0] mem_addr;

    always @(*) begin
        r_en = 1'b0;
        w_en = 1'b0;
        mem_addr = 64'b0;

        case (M_icode_i)
            `IRMMOVQ: begin
                r_en = 1'b0;
                w_en = 1'b1;
                mem_addr = M_valE_i;
            end
            `IMRMOVQ: begin
                r_en = 1'b1;
                w_en = 1'b0;
                mem_addr = M_valE_i;
            end
            `IPUSHQ: begin
                r_en = 1'b0;
                w_en = 1'b1;
                mem_addr = M_valE_i;
            end
            `IPOPQ: begin
                r_en = 1'b1;
                w_en = 1'b0;
                mem_addr = M_valA_i;
            end
            `ICALL: begin
                r_en = 1'b0;
                w_en = 1'b1;
                mem_addr = M_valE_i;
            end
            `IRET: begin
                r_en = 1'b1;
                w_en = 1'b0;
                mem_addr = M_valA_i;
            end

            default: begin
                r_en = 1'b0;
                w_en = 1'b0;
                mem_addr = 64'b0;
            end
        endcase
    end

    assign m_stat_o=dmem_error?`SADR:M_stat_i;
    ram memory_module(
    .clk_i(clk_i),       // 时钟信号输入
    .r_en(r_en),         // 读使能信号
    .w_en(w_en),         // 写使能信号
    .addr_i(mem_addr),   // 访问的内存地址
    .wdata_i(M_valA_i),  // 要写入内存的数据
    .rdata_o(m_valM_o),  // 从内存读取的数据
    .dmem_error_o(dmem_error) // 内存访问错误信号
);

endmodule