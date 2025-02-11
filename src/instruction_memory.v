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

        // 初始化 instr_mem 中的指令，后 8 位立即数部分按照 regfile 给定的值

    // IRMOVQ 指令 1: 将 regfile[1] (值为 64'd1) 加载到 regfile[1]
    instr_mem[0]  = 8'h30; // icode=3, ifun=0 (IRMOVQ)
    instr_mem[1]  = 8'hF1; // rA=F, rB=1
    instr_mem[2]  = 8'h01; // valC=0x0000000000000001 (little-endian)
    instr_mem[3]  = 8'h00;
    instr_mem[4]  = 8'h00;
    instr_mem[5]  = 8'h00;
    instr_mem[6]  = 8'h00;
    instr_mem[7]  = 8'h00;
    instr_mem[8]  = 8'h00;
    instr_mem[9]  = 8'h00;

    // IRMOVQ 指令 2: 将 regfile[2] (值为 64'd2) 加载到 regfile[2]
    instr_mem[10] = 8'h30; // icode=3, ifun=0 (IRMOVQ)
    instr_mem[11] = 8'hF2; // rA=F, rB=2
    instr_mem[12] = 8'h02; // valC=0x0000000000000002 (little-endian)
    instr_mem[13] = 8'h00;
    instr_mem[14] = 8'h00;
    instr_mem[15] = 8'h00;
    instr_mem[16] = 8'h00;
    instr_mem[17] = 8'h00;
    instr_mem[18] = 8'h00;
    instr_mem[19] = 8'h00;

    // IRMOVQ 指令 3: 将 regfile[3] (值为 64'd3) 加载到 regfile[3]
    instr_mem[20] = 8'h30; // icode=3, ifun=0 (IRMOVQ)
    instr_mem[21] = 8'hF3; // rA=F, rB=3
    instr_mem[22] = 8'h03; // valC=0x0000000000000003 (little-endian)
    instr_mem[23] = 8'h00;
    instr_mem[24] = 8'h00;
    instr_mem[25] = 8'h00;
    instr_mem[26] = 8'h00;
    instr_mem[27] = 8'h00;
    instr_mem[28] = 8'h00;
    instr_mem[29] = 8'h00;

    // IRMOVQ 指令 4: 将 regfile[4] (值为 64'h0000000000000400) 加载到 regfile[4]
    instr_mem[30] = 8'h30; // icode=3, ifun=0 (IRMOVQ)
    instr_mem[31] = 8'hF4; // rA=F, rB=4
    instr_mem[32] = 8'h00; // valC=0x0000000000000400 (little-endian)
    instr_mem[33] = 8'h04;
    instr_mem[34] = 8'h00;
    instr_mem[35] = 8'h00;
    instr_mem[36] = 8'h00;
    instr_mem[37] = 8'h00;
    instr_mem[38] = 8'h00;
    instr_mem[39] = 8'h00;

    // IRMOVQ 指令 5: 将 regfile[5] (值为 64'd5) 加载到 regfile[5]
    instr_mem[40] = 8'h30; // icode=3, ifun=0 (IRMOVQ)
    instr_mem[41] = 8'hF5; // rA=F, rB=5
    instr_mem[42] = 8'h05; // valC=0x0000000000000005 (little-endian)
    instr_mem[43] = 8'h00;
    instr_mem[44] = 8'h00;
    instr_mem[45] = 8'h00;
    instr_mem[46] = 8'h00;
    instr_mem[47] = 8'h00;
    instr_mem[48] = 8'h00;
    instr_mem[49] = 8'h00;

    // IRMOVQ 指令 6: 将 regfile[6] (值为 64'd6) 加载到 regfile[6]
    instr_mem[50] = 8'h30; // icode=3, ifun=0 (IRMOVQ)
    instr_mem[51] = 8'hF6; // rA=F, rB=6
    instr_mem[52] = 8'h06; // valC=0x0000000000000006 (little-endian)
    instr_mem[53] = 8'h00;
    instr_mem[54] = 8'h00;
    instr_mem[55] = 8'h00;
    instr_mem[56] = 8'h00;
    instr_mem[57] = 8'h00;
    instr_mem[58] = 8'h00;
    instr_mem[59] = 8'h00;

    // IRMOVQ 指令 7: 将 regfile[7] (值为 64'd7) 加载到 regfile[7]
    instr_mem[60] = 8'h30; // icode=3, ifun=0 (IRMOVQ)
    instr_mem[61] = 8'hF7; // rA=F, rB=7
    instr_mem[62] = 8'h07; // valC=0x0000000000000007 (little-endian)
    instr_mem[63] = 8'h00;
    instr_mem[64] = 8'h00;
    instr_mem[65] = 8'h00;
    instr_mem[66] = 8'h00;
    instr_mem[67] = 8'h00;
    instr_mem[68] = 8'h00;
    instr_mem[69] = 8'h00;

    // IRMOVQ 指令 8: 将 regfile[8] (值为 64'h0000000000000111) 加载到 regfile[8]
    instr_mem[70] = 8'h30; // icode=3, ifun=0 (IRMOVQ)
    instr_mem[71] = 8'hF8; // rA=F, rB=8
    instr_mem[72] = 8'h11; // valC=0x0000000000000111 (little-endian)
    instr_mem[73] = 8'h11;
    instr_mem[74] = 8'h00;
    instr_mem[75] = 8'h00;
    instr_mem[76] = 8'h00;
    instr_mem[77] = 8'h00;
    instr_mem[78] = 8'h00;
    instr_mem[79] = 8'h00;

    // IRMOVQ 指令 9: 将 regfile[9] (值为 64'd9) 加载到 regfile[9]
    instr_mem[80] = 8'h30; // icode=3, ifun=0 (IRMOVQ)
    instr_mem[81] = 8'hF9; // rA=F, rB=9
    instr_mem[82] = 8'h09; // valC=0x0000000000000009 (little-endian)
    instr_mem[83] = 8'h00;
    instr_mem[84] = 8'h00;
    instr_mem[85] = 8'h00;
    instr_mem[86] = 8'h00;
    instr_mem[87] = 8'h00;
    instr_mem[88] = 8'h00;
    instr_mem[89] = 8'h00;

    // IRMOVQ 指令 10: 将 regfile[10] (值为 64'd10) 加载到 regfile[10]
    instr_mem[90] = 8'h30; // icode=3, ifun=0 (IRMOVQ)
    instr_mem[91] = 8'hFA; // rA=F, rB=A
    instr_mem[92] = 8'h0A; // valC=0x000000000000000A (little-endian)
    instr_mem[93] = 8'h00;
    instr_mem[94] = 8'h00;
    instr_mem[95] = 8'h00;
    instr_mem[96] = 8'h00;
    instr_mem[97] = 8'h00;
    instr_mem[98] = 8'h00;
    instr_mem[99] = 8'h00;

     // IRMOVQ 指令 11: 将 regfile[11] (值为 64'd11) 加载到 regfile[11]
    instr_mem[100] = 8'h30; // icode=3, ifun=0 (IRMOVQ)
    instr_mem[101] = 8'hFB; // rA=F, rB=B
    instr_mem[102] = 8'h0B; // valC=0x000000000000000B (little-endian)
    instr_mem[103] = 8'h00;
    instr_mem[104] = 8'h00;
    instr_mem[105] = 8'h00;
    instr_mem[106] = 8'h00;
    instr_mem[107] = 8'h00;
    instr_mem[108] = 8'h00;
    instr_mem[109] = 8'h00;

    // IRMOVQ 指令 12: 将 regfile[12] (值为 64'd12) 加载到 regfile[12]
    instr_mem[110] = 8'h30; // icode=3, ifun=0 (IRMOVQ)
    instr_mem[111] = 8'hFC; // rA=F, rB=C
    instr_mem[112] = 8'h0C; // valC=0x000000000000000C (little-endian)
    instr_mem[113] = 8'h00;
    instr_mem[114] = 8'h00;
    instr_mem[115] = 8'h00;
    instr_mem[116] = 8'h00;
    instr_mem[117] = 8'h00;
    instr_mem[118] = 8'h00;
    instr_mem[119] = 8'h00;

    // IRMOVQ 指令 13: 将 regfile[13] (值为 64'd13) 加载到 regfile[13]
    instr_mem[120] = 8'h30; // icode=3, ifun=0 (IRMOVQ)
    instr_mem[121] = 8'hFD; // rA=F, rB=D
    instr_mem[122] = 8'h0D; // valC=0x000000000000000D (little-endian)
    instr_mem[123] = 8'h00;
    instr_mem[124] = 8'h00;
    instr_mem[125] = 8'h00;
    instr_mem[126] = 8'h00;
    instr_mem[127] = 8'h00;
    instr_mem[128] = 8'h00;
    instr_mem[129] = 8'h00;

    // IRMOVQ 指令 14: 将 regfile[14] (值为 64'd14) 加载到 regfile[14]
    instr_mem[130] = 8'h30; // icode=3, ifun=0 (IRMOVQ)
    instr_mem[131] = 8'hFE; // rA=F, rB=E
    instr_mem[132] = 8'h0E; // valC=0x000000000000000E (little-endian)
    instr_mem[133] = 8'h00;
    instr_mem[134] = 8'h00;
    instr_mem[135] = 8'h00;
    instr_mem[136] = 8'h00;
    instr_mem[137] = 8'h00;
    instr_mem[138] = 8'h00;
    instr_mem[139] = 8'h00;

    // IRMOVQ 指令 15: 将 regfile[15] (值为 64'd15) 加载到 regfile[15]
    instr_mem[140] = 8'h30; // icode=3, ifun=0 (IRMOVQ)
    instr_mem[141] = 8'hFF; // rA=F, rB=F
    instr_mem[142] = 8'h0F; // valC=0x000000000000000F (little-endian)
    instr_mem[143] = 8'h00;
    instr_mem[144] = 8'h00;
    instr_mem[145] = 8'h00;
    instr_mem[146] = 8'h00;
    instr_mem[147] = 8'h00;
    instr_mem[148] = 8'h00;
    instr_mem[149] = 8'h00;

    //IRMOVQ
    instr_mem[150] = 8'h30; // icode=3, ifun=0
    instr_mem[151] = 8'hF1; // rA=F, rB=1
    instr_mem[152] = 8'hF0; // valC=0x123456789ABCDEF0 (little-endian)
    instr_mem[153] = 8'hDE;
    instr_mem[154] = 8'hBC;
    instr_mem[155] = 8'h9A;
    instr_mem[156] = 8'h78;
    instr_mem[157] = 8'h56;
    instr_mem[158] = 8'h34;
    instr_mem[159] = 8'h12;
		
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
		
		// //MRMOVQ
		// instr_mem[20] = 8'h50; // icode=5, ifun=0
		// instr_mem[21] = 8'h25; // rA=2, rB=5
		// instr_mem[22] = 8'h20; // valC=0x0020 (little-endian) 
		// instr_mem[23] = 8'h00;
		// instr_mem[24] = 8'h00;
		// instr_mem[25] = 8'h00;
		// instr_mem[26] = 8'h00;
		// instr_mem[27] = 8'h00;
		// instr_mem[28] = 8'h00;
		// instr_mem[29] = 8'h00;

		// //OPQ
		// instr_mem[30] = 8'h60; // icode=6, ifun=0 
		// instr_mem[31] = 8'h35; // rA=3, rB=5

		// //push
		// instr_mem[32] = 8'hA0; // icode=A, ifun=0 (push)
		// instr_mem[33] = 8'h8F; //regfile[8]=h0000000000000111

		// //pop
		// instr_mem[34] = 8'hB0; // icode=B, ifun=0 (pop)
		// instr_mem[35] = 8'h9F; //regfile[9] should be 111

		// //OPQ
		// instr_mem[36] = 8'h60; // icode=6, ifun=0 
		// instr_mem[37] = 8'h35; // rA=3, rB=5
		
		// //JXX
		// instr_mem[38] = 8'h70; // icode=7, ifun=0 
		// instr_mem[39] = 8'h30; // valC=0x30 (little-endian) 48
		// instr_mem[40] = 8'h00;
		// instr_mem[41] = 8'h00;
		// instr_mem[42] = 8'h00;
		// instr_mem[43] = 8'h00;
		// instr_mem[44] = 8'h00;
		// instr_mem[45] = 8'h00;
		// instr_mem[46] = 8'h00;

		// // jle 
		// instr_mem[48] = 8'h71; // icode=7, ifun=1 (jle)
		// instr_mem[49] = 8'h3a; // valC=0x3a (little-endian)
		// instr_mem[50] = 8'h00;
		// instr_mem[51] = 8'h00;
		// instr_mem[52] = 8'h00;
		// instr_mem[53] = 8'h00;
		// instr_mem[54] = 8'h00;
		// instr_mem[55] = 8'h00;
		// instr_mem[56] = 8'h00;

		// // jne 
		// instr_mem[57] = 8'h72; // icode=7, ifun=2 (jne)
		// instr_mem[58] = 8'h43; // valC=0x43 (little-endian)
		// instr_mem[59] = 8'h00;
		// instr_mem[60] = 8'h00;
		// instr_mem[61] = 8'h00;
		// instr_mem[62] = 8'h00;
		// instr_mem[63] = 8'h00;
		// instr_mem[64] = 8'h00;
		// instr_mem[65] = 8'h00;
		
		// // call 
		// instr_mem[67] = 8'h80; // icode=8 (call)
		// instr_mem[68] = 8'h00; // valC=0x100 (little-endian)
		// instr_mem[69] = 8'h01;
		// instr_mem[70] = 8'h00;
		// instr_mem[71] = 8'h00;
		// instr_mem[72] = 8'h00;
		// instr_mem[73] = 8'h00;
		// instr_mem[74] = 8'h00;
		// instr_mem[75] = 8'h00;

		// // ret
		// instr_mem[256] = 8'h90; // icode=9 (ret)

	end
endmodule