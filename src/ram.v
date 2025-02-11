
module ram(
	input wire clk_i,
	input wire r_en,
	input wire w_en,
	input wire[63:0] addr_i,
	input wire[63:0] wdata_i,
	
	output wire [63:0] rdata_o,
	output wire dmem_error_o
);
	reg[7:0] mem[1023:0];//8×1024 共1024个地址
	assign dmem_error_o=(addr_i>1023)?1'b1:1'b0;
	//读取
	assign rdata_o=(r_en==1'b1)?({mem[addr_i+7],mem[addr_i+6],mem[addr_i+5],mem[addr_i+4],
					mem[addr_i+3],mem[addr_i+2],mem[addr_i+1],mem[addr_i+0]}):64'b0;
	//写入
	always@(posedge clk_i)begin
		if(w_en)begin
			{mem[addr_i+7],mem[addr_i+6],mem[addr_i+5],mem[addr_i+4],
					mem[addr_i+3],mem[addr_i+2],mem[addr_i+1],mem[addr_i+0]}<=wdata_i;
		end
	end
	initial begin 
		mem[0]	=8'h00;
		mem[1]	=8'h01;
		mem[2]	=8'h02;
		mem[3]	=8'h03;
		mem[4]	=8'h04;
		mem[5]	=8'h05;
		mem[6]	=8'h06;
		mem[7]	=8'h07;
		mem[8]	=8'h08;
		mem[9]	=8'h09;
		mem[10]	=8'h0a;
		mem[11]	=8'h0b;
		mem[12]	=8'h0c;
		mem[13]	=8'h0d;
		mem[14]	=8'h0e;
		mem[15]	=8'h0f;
		mem[16]	=8'h10;
		mem[17]	=8'h11;
		mem[18]	=8'h12;
		mem[19]	=8'h13;
		
		mem[37] =8'h21;
		mem[38] =8'h43;
		mem[39] =8'h65;
		mem[40] =8'h87;
		mem[41] =8'ha9;
		mem[42] =8'hcb;
		mem[43] =8'hed;		
		mem[44] =8'h0f;
	end

 // 初始化 mem[768:1023]
integer i; // 将循环变量声明移到 for 循环外部
    initial begin
        for (i = 768; i < 1024; i = i + 1) begin
            mem[i] = 8'h00; // 初始化为 0
        end
    end
	
endmodule