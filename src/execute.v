`include"define.v"
module execute(
    input wire clk_i,
    input wire rst_n_i,
    input wire [3:0] icode_i,
    input wire [3:0] ifun_i,
    input wire [3:0] E_dstE_i,

    input wire signed [63:0] valA_i,
    input wire signed [63:0] valB_i,
    input wire signed [63:0] valC_i,

    input wire [2:0] m_stat_i,
    input wire [2:0] W_stat_i,

    output wire signed [63:0] valE_o,
    output wire [3:0] dstE_o,
    output wire  e_Cnd_o
);

        // Wires and registers for ALU operations
    wire [63:0] aluA;
    wire [63:0] aluB; // Corrected the size from [63:8] to [63:0]
    wire [3:0] alu_fun;
    reg [2:0] new_cc; // zf, sf, of
    reg [2:0] cc; // zf, sf, of
    wire zf = cc[2];
    wire sf = cc[1];
    wire of = cc[0];

    // Assigning values to aluA based on the icode
    assign aluA = (icode_i == `IRRMOVQ || icode_i == `IOPQ) ? valA_i :
                (icode_i == `IIRMOVQ || icode_i == `IRMMOVQ || icode_i == `IMRMOVQ) ? valC_i :
                (icode_i == `ICALL || icode_i == `IPUSHQ) ? -8 :
                (icode_i == `IRET || icode_i == `IPOPQ) ? 8 : 0;

    // Assigning values to aluB based on the icode
    assign aluB = (icode_i == `IRMMOVQ || icode_i == `IMRMOVQ || icode_i == `IOPQ ||
                icode_i == `ICALL || icode_i == `IPUSHQ || icode_i == `IRET ||
                icode_i == `IPOPQ) ? valB_i :
                (icode_i == `IRRMOVQ || icode_i == `IIRMOVQ) ? 0 : 0; // The last 0 is redundant

    // Assigning ALU function based on the icode
    assign alu_fun = (icode_i == `IOPQ) ? ifun_i : `ALUADD; 

    // ALU operation and result assignment
    assign valE_o = (alu_fun == `ALUSUB) ? (aluB - aluA) :
                    (alu_fun == `ALUAND) ? (aluB & aluA) :
                    (alu_fun == `ALUXOR) ? (aluB ^ aluA) :
                    (aluB + aluA); // Assuming ALUSUB, ALUAND, ALUXOR are defined constants
    //?存版?蹇浣
	always@(posedge clk_i) begin
		if(~rst_n_i) begin
			new_cc[2]=0;//zf
			new_cc[1]=0;//sf
			new_cc[0]=0;//of
		end	
		else if (icode_i == `IOPQ) begin
				new_cc[2]=(valE_o==0)?1:0;
				new_cc[1]=valE_o[63];
				new_cc[0]=(alu_fun==`ALUADD)?
						(aluA[63]==aluB[63])&(aluA[63]!=valE_o[63]):
						(alu_fun==`ALUSUB)?
						(~aluA[63]==aluB[63])&(aluB[63]!=valE_o[63]):0;
		end
	end
	wire set_cc;
	assign set_cc=(icode_i==`IOPQ||icode_i==`ICMOVQ);
	
	always@(posedge clk_i)begin
		if(~rst_n_i)
			cc<=3'b000;
		else if(set_cc)
			cc<=new_cc;
	end
	assign e_Cnd_o=(icode_i==`IJXX)&&
		(
		(ifun_i==`C_YES)|
		(ifun_i==`C_E)&new_cc[2]|
		(ifun_i==`C_NE)&~new_cc[2]|
		(ifun_i==`C_S)&new_cc[1]|
		(ifun_i==`C_NS)&~new_cc[1]|
		(ifun_i==`C_G)&(~(new_cc[1]^new_cc[0])&~new_cc[2])|
		(ifun_i==`C_GE)&~(new_cc[1]^new_cc[0])|
		(ifun_i==`C_L)&(new_cc[1]^new_cc[0])|
		(ifun_i==`C_LE)&((new_cc[1]^new_cc[0])|new_cc[2])
		);
        //cmov
        assign dstE_o=((icode_i==`IRRMOVQ)&&!e_Cnd_o)?`RNONE:E_dstE_i;
endmodule