`include"define.v"
`include "instruction_memory.v"
module fetch(
    input wire [63:0] PC_i,

    output wire [3:0] icode_o,
    output wire [3:0] ifun_o,
    output wire [3:0] rA_o,
    output wire [3:0] rB_o,
    output wire [63:0] valC_o,
    output wire [63:0] valP_o,
    output wire [63:0] predPC_o,
    output wire [2:0] stat_o
);
wire [79:0] instr;
wire imem_error;
wire instr_valid;

instruction_memory instr_mem(
    .raddr_i(PC_i),
    .rdata_o(instr),
    .imem_error_o(imem_error)
);

assign icode_o=instr[7:4];
	
	
	assign icode_o=instr[7:4];
	assign ifun_o=instr[3:0];
	
    assign instr_valid=(icode_o>4'hb||icode_o<4'h0);
    
assign need_regids=(icode_o==`ICMOVQ)||(icode_o==`IIRMOVQ)||(icode_o==`IRMMOVQ)||
(icode_o==`IMRMOVQ)||(icode_o==`IOPQ)||(icode_o==`IPUSHQ)||(icode_o==`IPOPQ);
	
assign need_valC=(icode_o==`IIRMOVQ)||(icode_o==`IRMMOVQ)||
        (icode_o==`IMRMOVQ)||(icode_o==`IJXX)||(icode_o==`ICALL);
	
	assign rA_o=need_regids?instr[15:12]:4'hf;
	assign rB_o=need_regids?instr[11:8]:4'hf;
	
	assign valC_o=need_valC?(need_regids?instr[79:16]:instr[71:8]):64'h0;
	
	assign valP_o=PC_i+1+8*need_valC+need_regids;
    assign stat_o=imem_error?`SADR:
                (instr_valid)?`SINS:
                (icode_o==`IHALT)?`SHLT:
                                `SAOK;
    assign predPC_o=(icode_o==`IJXX||icode_o==`ICALL)?valC_o:valP_o;
	/*
always@(*)begin
		$display($time," fetch:PC_i:%d, icode_o:%h %b===%b, need_valC:%h, need_regids:%h, instr:%h",PC_i,icode_o,instr[7:4],`IRMMOVQ,need_valC,need_regids,instr);
	end*/
endmodule