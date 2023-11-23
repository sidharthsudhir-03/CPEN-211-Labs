module controller_fsm(clk, s, reset, opcode, op, nsel, loada, loadb, loadc, loads, asel, bsel, vsel, write, w);

	//state width
	`define SW 5
	
	//initial state
	`define Wait 5'b00000
	
	//reading registers Rm and Rn for different operations
	`define get_rm_mov 5'b00010
	`define get_rm_add 5'b00011
	`define get_rm_cmp 5'b00100
	`define get_rm_and 5'b00101
	`define get_rm_mvn 5'b00110
	`define get_rn_add 5'b00111
	`define get_rn_cmp 5'b01000
	`define get_rn_and 5'b01001
	
	//state operations
	`define mov_op 5'b01010
	`define add_op 5'b01011
	`define cmp_op 5'b01100
	`define and_op 5'b01101
	`define mvn_op 5'b01110
	
	//writing to register Rd after performing operation
	`define write_imm 5'b01111
	`define write_rd_mov 5'b10000
	`define write_rd_add 5'b10001
	`define write_rd_cmp 5'b10010
	`define write_rd_and 5'b10011
	`define write_rd_mvn 5'b10100

	input clk, s, reset;
	input[2:0] opcode;
	input[1:0] op;
	
	output w, loada, loadb, loadc, loads, asel, bsel, write;
	output[1:0] vsel;
	output[2:0] nsel;
	
	wire[5:0] fsm_in;
	reg[17:0] next;
	reg[`SW-1:0] next_state;
	wire[`SW-1:0] present_state, next_state_reset;
	
	assign fsm_in = {s, opcode, op};
	assign next_state_reset = reset ? `Wait : next_state;
	vDFF #(`SW) U1(clk, next_state_reset, present_state);
	
	always @(*) begin
		
		casex({present_state, fsm_in})
		
			{`Wait, 6'b0xxxxx}: next = {`Wait, 13'b00xxx00000001};
			{`Wait, 6'b111010}: next = {`write_imm, 13'b00xxx00000001};
			{`Wait, 6'b111000}: next = {`get_rm_mov, 13'b00xxx00000001};
			{`Wait, 6'b110100}: next = {`get_rm_add, 13'b00xxx00000001};
			{`Wait, 6'b110101}: next = {`get_rm_cmp, 13'b00xxx00000001};
			{`Wait, 6'b110110}: next = {`get_rm_and, 13'b00xxx00000001};
			{`Wait, 6'b110111}: next = {`get_rm_mvn, 13'b00xxx00000001};
			
			{`write_imm, 6'bxxxxxx}: next = {`Wait, 13'b1000100000010};
			{`get_rm_mov, 6'bxxxxxx}: next = {`mov_op, 13'b0010001000000};
			{`get_rm_add, 6'bxxxxxx}: next = {`get_rn_add, 13'b0010001000000};
			{`get_rm_cmp, 6'bxxxxxx}: next = {`get_rn_cmp, 13'b0010001000000};
			{`get_rm_and, 6'bxxxxxx}: next = {`get_rn_and, 13'b0010001000000};
			{`get_rm_mvn, 6'bxxxxxx}: next = {`mvn_op, 13'b0010001000000};
			
			{`mov_op, 6'bxxxxxx}: next = {`write_rd_mov, 13'b00xxx00101000};
			{`get_rn_add, 6'bxxxxxx}: next = {`add_op, 13'b0000110000000};
			{`get_rn_cmp, 6'bxxxxxx}: next = {`cmp_op, 13'b0000110000000};
			{`get_rn_and, 6'bxxxxxx}: next = {`and_op, 13'b0000110000000};
			{`mvn_op, 6'bxxxxxx}: next = {`write_rd_mvn, 13'b00xxx00101000};
		
			{`write_rd_mov, 6'bxxxxxx}: next = {`Wait, 13'b1001000000010};	
			{`add_op, 6'bxxxxxx}: next = {`write_rd_add, 13'b00xxx00100000};
			{`cmp_op, 6'bxxxxxx}: next = {`write_rd_cmp, 13'b00xxx00100000};
			{`and_op, 6'bxxxxxx}: next = {`write_rd_and, 13'b00xxx00100000};
			{`write_rd_mvn, 6'bxxxxxx}: next = {`Wait, 13'b1000100000010};
			
			{`write_rd_add, 6'bxxxxxx}: next = {`Wait, 13'b1001000000010};
			{`write_rd_cmp, 6'bxxxxxx}: next = {`Wait, 13'b1001000000010};
			{`write_rd_and, 6'bxxxxxx}: next = {`Wait, 13'b1001000000010};
			
			default: next = {18{1'bx}};
			
		endcase
		
	end
	
	assign {next_state, vsel, nsel, loada, loadb, loadc, loads, asel, bsel, write, w} = next;
	
endmodule 
		
// n-bit D-Flip Flop module declaration 

module vDFF(clk, in, out);
	parameter n = 1;
	input clk;
	input [n-1:0] in;
	output reg [n-1:0] out;

	always_ff @ (posedge clk)
		out <= in;
endmodule
			
	
	
