`include"define.v"
module decode(
    input wire clk_i,
    input wire [3:0] D_icode_i,
    input wire [3:0] D_rA_i,
    input wire [3:0] D_rB_i,
    input wire [63:0] D_valP_i,

    input wire [3:0] e_dstE_i,
    input wire [63:0] e_valE_i,
    input wire [3:0] M_dstM_i,
    input wire [63:0] m_valM_i,
    input wire [3:0] M_dstE_i,
    input wire [63:0] M_valE_i,
    input wire [3:0] W_dstM_i,
    input wire [63:0] W_valM_i,
    input wire [3:0] W_dstE_i,
    input wire [63:0] W_valE_i,

    output wire [63:0] d_valA_o,
    output wire [63:0] d_valB_o,
    output wire [3:0] d_dstE_o,
    output wire [3:0] d_dstM_o,
    output wire [3:0] d_srcA_o,
    output wire [3:0] d_srcB_o
);

    wire[63:0] d_rvalA;
    wire[63:0] d_rvalB;
    reg [63:0] regfile[0:14];

assign d_srcA_o=(D_icode_i==`IRRMOVQ || D_icode_i==`IRMMOVQ ||
                D_icode_i==`IOPQ ||D_icode_i==`IPUSHQ||D_icode_i==`ICMOVQ )?D_rA_i:
                (D_icode_i==`IPOPQ || D_icode_i==`IRET)?`RRSP:`RNONE;
assign d_srcB_o=(D_icode_i==`IIRMOVQ ||D_icode_i==`IOPQ ||D_icode_i==`IRMMOVQ ||D_icode_i==`IMRMOVQ||D_icode_i==`ICMOVQ)?D_rB_i:
                (D_icode_i==`ICALL||D_icode_i==`IPUSHQ||D_icode_i==`IRET||D_icode_i==`IPOPQ)?`RRSP:`RNONE;
assign d_dstE_o=(D_icode_i==`IRRMOVQ||D_icode_i==`IIRMOVQ||D_icode_i==`IOPQ)?D_rB_i:
                (D_icode_i==`IPUSHQ||D_icode_i==`IPOPQ||
                D_icode_i==`ICALL||D_icode_i==`IRET)?`RRSP:`RNONE;
assign d_dstM_o=(D_icode_i==`IMRMOVQ||D_icode_i==`IPOPQ)?D_rA_i:`RNONE;
assign d_rvalA=(d_srcA_o==`RNONE)?64'b0:regfile[d_srcA_o];
assign d_rvalB=(d_srcB_o==`RNONE)?64'b0:regfile[d_srcB_o];
    
    assign d_valA_o=d_rvalA;
    assign d_valB_o=d_rvalB;

    always@(posedge clk_i)begin
        if(W_dstE_i!=4'HF)begin
            regfile[W_dstE_i]<=W_valE_i;
        end
        if(W_dstM_i!=4'HF)begin
            regfile[W_dstE_i]<=W_valM_i;
        end
    end
/*
	always@(*)begin
		$display($time," decode:D_icode_i:%h,D_rA_i=%h,D_rB_i=%h d_srcA_o:%h,d_srcB_o:%h, srcAj:%h, srcBj:%h",D_icode_i,D_rA_i,D_rB_i,d_srcA_o,d_srcB_o,(D_icode_i==`IRRMOVQ || D_icode_i==`IRMMOVQ ||
                D_icode_i==`IOPQ ||D_icode_i==`IPUSHQ ),(D_icode_i==`IOPQ ||D_icode_i==`IRMMOVQ ||D_icode_i==`IMRMOVQ));
	end*/
initial begin
		regfile[0]=64'd0;
		regfile[1]=64'd1;
		regfile[2]=64'd2;
		regfile[3]=64'd3;
		regfile[4]=64'h0000000000000400;//rsp 768?1023
		regfile[5]=64'd5;
		regfile[6]=64'd6;
		regfile[7]=64'd7;
		regfile[8]=64'h0000000000000111;
		regfile[9]=64'd9;
		regfile[10]=64'd10;
		regfile[11]=64'd11;
		regfile[12]=64'd12;
		regfile[13]=64'd13;
		regfile[14]=64'd14;
	end
endmodule