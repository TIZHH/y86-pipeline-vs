module instruction_memory(
    input wire [63:0] raddr_i,
    output wire [79:0] rdata_o,
    output wire imem_error_o
);
    reg[7:0] instr_mem[1024:0];
    assign imem_error_o=(raddr_i>64'd1023);
    assign rdata_o=(raddr_i <= 64'd1016) ?
    {instr_mem[raddr_i+9],
	instr_mem[raddr_i+8],
	instr_mem[raddr_i+7],
	instr_mem[raddr_i+6],
	instr_mem[raddr_i+5],
	instr_mem[raddr_i+4],
	instr_mem[raddr_i+3],
	instr_mem[raddr_i+2],
	instr_mem[raddr_i+1],
	instr_mem[raddr_i]}: 
        80'h00000000000000000000;
    initial begin
		//IRMOVQ
		instr_mem[0] = 8'h30; // icode=3, ifun=0
		instr_mem[1] = 8'hF1; // rA=F, rB=1
		instr_mem[2] = 8'hF0; // valC=0x123456789ABCDEF0 (little-endian)
		instr_mem[3] = 8'hDE;
		instr_mem[4] = 8'hBC;
		instr_mem[5] = 8'h9A;
		instr_mem[6] = 8'h78;
		instr_mem[7] = 8'h56;
		instr_mem[8] = 8'h34;
		instr_mem[9] = 8'h12;
		
		//RMMOVQ
		instr_mem[10] = 8'h40; // icode=4, ifun=0
		instr_mem[11] = 8'h12; // rA=1, rB=2
		instr_mem[12] = 8'h10; // valC=0x0010 (little-endian)
		instr_mem[13] = 8'h00;
		instr_mem[14] = 8'h00;
		instr_mem[15] = 8'h00;
		instr_mem[16] = 8'h00;
		instr_mem[17] = 8'h00;
		instr_mem[18] = 8'h00;
		instr_mem[19] = 8'h00;
		
		//MRMOVQ
		instr_mem[20] = 8'h50; // icode=5, ifun=0
		instr_mem[21] = 8'h25; // rA=2, rB=5
		instr_mem[22] = 8'h20; // valC=0x0020 (little-endian) 
		instr_mem[23] = 8'h00;
		instr_mem[24] = 8'h00;
		instr_mem[25] = 8'h00;
		instr_mem[26] = 8'h00;
		instr_mem[27] = 8'h00;
		instr_mem[28] = 8'h00;
		instr_mem[29] = 8'h00;

		//OPQ
		instr_mem[30] = 8'h60; // icode=6, ifun=0 
		instr_mem[31] = 8'h35; // rA=3, rB=5

		//push
		instr_mem[32] = 8'hA0; // icode=A, ifun=0 (push)
		instr_mem[33] = 8'h8F; //regfile[8]=h0000000000000111

		//pop
		instr_mem[34] = 8'hB0; // icode=B, ifun=0 (pop)
		instr_mem[35] = 8'h9F; //regfile[9] should be 111

		//OPQ
		instr_mem[36] = 8'h60; // icode=6, ifun=0 
		instr_mem[37] = 8'h35; // rA=3, rB=5
		
		//JXX
		instr_mem[38] = 8'h70; // icode=7, ifun=0 
		instr_mem[39] = 8'h30; // valC=0x30 (little-endian) 48
		instr_mem[40] = 8'h00;
		instr_mem[41] = 8'h00;
		instr_mem[42] = 8'h00;
		instr_mem[43] = 8'h00;
		instr_mem[44] = 8'h00;
		instr_mem[45] = 8'h00;
		instr_mem[46] = 8'h00;

		// jle 
		instr_mem[48] = 8'h71; // icode=7, ifun=1 (jle)
		instr_mem[49] = 8'h3a; // valC=0x3a (little-endian)
		instr_mem[50] = 8'h00;
		instr_mem[51] = 8'h00;
		instr_mem[52] = 8'h00;
		instr_mem[53] = 8'h00;
		instr_mem[54] = 8'h00;
		instr_mem[55] = 8'h00;
		instr_mem[56] = 8'h00;

		// jne 
		instr_mem[57] = 8'h72; // icode=7, ifun=2 (jne)
		instr_mem[58] = 8'h43; // valC=0x43 (little-endian)
		instr_mem[59] = 8'h00;
		instr_mem[60] = 8'h00;
		instr_mem[61] = 8'h00;
		instr_mem[62] = 8'h00;
		instr_mem[63] = 8'h00;
		instr_mem[64] = 8'h00;
		instr_mem[65] = 8'h00;
		
		// call 
		instr_mem[67] = 8'h80; // icode=8 (call)
		instr_mem[68] = 8'h00; // valC=0x100 (little-endian)
		instr_mem[69] = 8'h01;
		instr_mem[70] = 8'h00;
		instr_mem[71] = 8'h00;
		instr_mem[72] = 8'h00;
		instr_mem[73] = 8'h00;
		instr_mem[74] = 8'h00;
		instr_mem[75] = 8'h00;

		// ret
		instr_mem[256] = 8'h90; // icode=9 (ret)

	end
endmodule