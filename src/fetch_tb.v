`timescale 1ns/1ps
`include "define.v"
`include "fetch.v"
`include "fetch_D_pipe_reg.v"

module fetch_tb;
	reg clk;
initial begin
    clk = 0; // ????????
    forever #5 clk = ~clk; // ????????10ns
end

    wire F_stall;
    wire F_bubble;
    wire F_predPC;
	
    reg[63:0] f_pc;

    wire[2:0] f_stat;
    wire[3:0] f_icode;
    wire[3:0] f_ifun;
	wire[3:0] f_rA;
	wire[3:0] f_rB;
	wire[63:0] f_valC;
	wire[63:0] f_valP;
    wire[63:0] f_predPC;

    wire D_stall;
    wire D_bubble;
    wire [2:0] D_stat;
    wire [63:0] D_pc;
    wire [3:0] D_icode;
    wire [3:0] D_ifun;
    wire [3:0] D_rA;
    wire [3:0] D_rB;
    wire[63:0] D_valC;
	wire[63:0] D_valP;

	fetch fetch_tb(
		.PC_i(f_pc),
		.icode_o(f_icode),
		.ifun_o(f_ifun),
		.rA_o(f_rA),
		.rB_o(f_rB),
		.valC_o(f_valC),
		.valP_o(f_valP),
		.predPC_o(f_predPC),
		.stat_o(f_stat)
	);

    assign D_stall=1'b0;
    assign D_bubble=1'b0;

    fetch_D_pipe_reg dreg(
        .clk_i(clk),
        .D_stall_i(D_stall),
        .D_bubble_i(D_bubble),
        
        .f_stat_i(f_stat),
        .f_pc_i(f_pc),
        .f_icode_i(f_icode),
        .f_ifun_i(f_ifun),
        .f_rA_i(f_rA),
        .f_rB_i(f_rB),
        .f_valC_i(f_valP),
        .f_valP_i(f_valP),

        .D_stat_o(D_stat),
        .D_pc_o(D_pc),
        .D_icode_o(D_icode),
        .D_ifun_o(D_ifun),
        .D_rA_o(D_rA),
        .D_rB_o(D_rB),
        .D_valC_o(D_valC),
        .D_valP_o(D_valP)
    );
always @(posedge clk) begin
    // ?????????§Õ???????????????????D_pc?????????
    f_pc <= f_valP;
end

	initial begin
        $dumpfile("./wave/fetch.vcd");  // ???VCD??????????wave.vcd?????????????????????
	    $dumpvars(0, fetch_tb );  // ?????????0????tb_code ??üŸ?????????¦Å??????????????
		f_pc=64'b0;
		#50 $finish;
	end
	initial
		$monitor("Time=%0t,PC=%d\t,icode=%h\t,ifun=%h\t,rA=%h\t,rB=%h\t,valC=%h\t,valP=%d\t",
			$time,D_pc,D_icode,D_ifun,D_rA,D_rB,D_valC,f_valP);
endmodule