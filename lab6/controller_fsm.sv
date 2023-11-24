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
	
	//writing to register after performing operation
	`define write_imm 5'b01111
	`define write_rd_mov 5'b10000
	`define write_rd_add 5'b10001
	`define write_status 5'b10010
	`define write_rd_and 5'b10011
	`define write_rd_mvn 5'b10100
	
	
	//state machine inputs
	input clk, s, reset;
	input[2:0] opcode;
	input[1:0] op;
	
	//state machine outputs that go to datapath
	output w, loada, loadb, loadc, loads, asel, bsel, write;
	output[1:0] vsel;
	
	output[2:0] nsel;//output that goes to the instruction decoder
	
	wire[5:0] fsm_in;//all inputs of fsm except reset
	reg[17:0] next;//this reg involes the next state that the machine jumps to and all the outputs of the module
	reg[`SW-1:0] next_state;
	wire[`SW-1:0] present_state, next_state_reset;//next_state_reset is the state that updates the value of next state depending on value of reset
	
	assign fsm_in = {s, opcode, op};
	assign next_state_reset = reset ? `Wait : next_state;
	vDFF #(`SW) U1(clk, next_state_reset, present_state); //a D-Flip Flop register that updates the value of present state based on the value of next_state_reset
	
	always @(*) begin
		
		//describing all state transitions
		//some instructions have fewer states than others, for instance
		//MOV_imm has 1 intermediate state
		//MOV has 2 intermediate states
		//ADD has 4 intermediate states
		//CMP has 4 intermediate states
		//AND has 4 intermediate states
		//MVN has 3 intermediate states
		
		casex({present_state, fsm_in})
		
			//first stage for every operation; as long as present state is in the Wait state, the value of w will be 1
			//every output is set to 0, the value of nsel is set to dont care
			//when input is set to 1 then the state changes from wait
			//this is the only stage of state transitions when the inputs of the state machine matter
			{`Wait, 6'b0xxxxx}: next = {`Wait, 13'b00xxx00000001};
			{`Wait, 6'b111010}: next = {`write_imm, 13'b00xxx00000001};
			{`Wait, 6'b111000}: next = {`get_rm_mov, 13'b00xxx00000001};
			{`Wait, 6'b110100}: next = {`get_rm_add, 13'b00xxx00000001};
			{`Wait, 6'b110101}: next = {`get_rm_cmp, 13'b00xxx00000001};
			{`Wait, 6'b110110}: next = {`get_rm_and, 13'b00xxx00000001};
			{`Wait, 6'b110111}: next = {`get_rm_mvn, 13'b00xxx00000001};
			
			//second stage of all instruction; from this stage onwards inputs do not matter
			//output is set to inputs necessary to perform operation in datapath
			{`write_imm, 6'bxxxxxx}: next = {`Wait, 13'b1000100000010};
			{`get_rm_mov, 6'bxxxxxx}: next = {`mov_op, 13'b0010001000000};
			{`get_rm_add, 6'bxxxxxx}: next = {`get_rn_add, 13'b0010001000000};
			{`get_rm_cmp, 6'bxxxxxx}: next = {`get_rn_cmp, 13'b0010001000000};
			{`get_rm_and, 6'bxxxxxx}: next = {`get_rn_and, 13'b0010001000000};
			{`get_rm_mvn, 6'bxxxxxx}: next = {`mvn_op, 13'b0010001000000};
			
			//third stage of most instructions (MOV, ADD, CMP, AND, MVN)
			{`mov_op, 6'bxxxxxx}: next = {`write_rd_mov, 13'b00xxx00101000};
			{`get_rn_add, 6'bxxxxxx}: next = {`add_op, 13'b0000110000000};
			{`get_rn_cmp, 6'bxxxxxx}: next = {`cmp_op, 13'b0000110000000};
			{`get_rn_and, 6'bxxxxxx}: next = {`and_op, 13'b0000110000000};
			{`mvn_op, 6'bxxxxxx}: next = {`write_rd_mvn, 13'b00xxx00101000};
		
		   //fouth stage of most instructions (MOV, ADD, CMP, AND, MVN)
			{`write_rd_mov, 6'bxxxxxx}: next = {`Wait, 13'b0001000000010};	
			{`add_op, 6'bxxxxxx}: next = {`write_rd_add, 13'b00xxx00100000};
			{`cmp_op, 6'bxxxxxx}: next = {`write_status, 13'b00xxx00010000};
			{`and_op, 6'bxxxxxx}: next = {`write_rd_and, 13'b00xxx00100000};
			{`write_rd_mvn, 6'bxxxxxx}: next = {`Wait, 13'b0001000000010};
			
			//fifth stage of some instructions (ADD, CMP, AND)
			{`write_rd_add, 6'bxxxxxx}: next = {`Wait, 13'b0001000000010};
			{`write_status, 6'bxxxxxx}: next = {`Wait, 13'b00xxx00010000};
			{`write_rd_and, 6'bxxxxxx}: next = {`Wait, 13'b0001000000010};
			
			default: next = {18{1'bx}};
			
		endcase
		
	end
	
	assign {next_state, vsel, nsel, loada, loadb, loadc, loads, asel, bsel, write, w} = next; //writing all bits of next to necessary wires or outputs
	
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
			
	
	
