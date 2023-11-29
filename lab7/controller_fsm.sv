module controller_fsm(clk, reset, opcode, op, nsel, loada, loadb, loadc, loads, asel, bsel, vsel, write, reset_pc, load_pc, load_ir, mem_cmd, addr_sel, load_addr);

	//state width
	`define SW 6
	
	//initial states
	`define RST 6'b000000
	`define IF1 6'b000001
	`define IF2 6'b000010
	`define UpdatePC 6'b000011
	`define Decode 6'b111111
	
	//define different mem_cmds
	`define MREAD 2'b10
	`define MWRITE 2'b11
	`define MNONE 2'b00
	
	//reading registers Rm and Rn for different operations
	`define get_rm_mov 6'b000100
	`define get_rm_add 6'b000101
	`define get_rm_cmp 6'b000110
	`define get_rm_and 6'b000111
	`define get_rm_mvn 6'b001000
	`define get_rn_add 6'b001001
	`define get_rn_cmp 6'b001010
	`define get_rn_and 6'b001011
	
	//state operations
	`define mov_op 6'b001100
	`define add_op 6'b001101
	`define cmp_op 6'b001110
	`define and_op 6'b001111
	`define mvn_op 6'b010000
	
	//writing to register after performing operation
	`define write_imm 6'b010001
	`define write_rd_mov 6'b010010
	`define write_rd_add 6'b010011
	`define write_status 6'b010100
	`define write_rd_and 6'b010101
	`define write_rd_mvn 6'b010110
	
	//ldr states
	`define get_rn_ldr 6'b010111
	`define get_ldr_addr 6'b011000
	`define get_data_addr_ldr 6'b011001
	`define read_addr_ldr 6'b011010
	`define write_rd_ldr 6'b011011
	
	//str states
	`define get_rn_str 6'b011100
	`define get_str_addr 6'b011101
	`define get_data_addr_str 6'b011110
	`define write_addr_str 6'b011111
	`define get_rd_str 6'b100000
	`define get_rd_out 6'b100001
	`define write_rd_str 6'b100010
	
	//halt operation
	`define HALT 6'b111110
	
	//state machine inputs
	input clk, reset;
	input[2:0] opcode;
	input[1:0] op;
	
	//state machine outputs
	output loada, loadb, loadc, loads, asel, bsel, write, reset_pc, load_pc, load_ir, addr_sel, load_addr;
	output[1:0] vsel, mem_cmd;
	
	output[2:0] nsel;//output that goes to the instruction decoder
	
	wire[4:0] fsm_in;//all inputs of fsm except reset
	reg[24:0] next;//this reg involes the next state that the machine jumps to and all the outputs of the module
	reg[`SW-1:0] next_state;
	wire[`SW-1:0] present_state, next_state_reset;//next_state_reset is the state that updates the value of next state depending on value of reset
	
	assign fsm_in = {opcode, op};
	assign next_state_reset = reset ? `RST : next_state;
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
		//LDR has 5 intermediate states
		//STR has 7 intermediate states
		
		casex({present_state, fsm_in})
		
			//first stage for every operation; as long as present state is in the Wait state, the value of w will be 1
			//every output is set to 0, the value of nsel is set to dont care
			//when input is set to 1 then the state changes from wait
			
			{`RST, 5'bxxxxx}: next = {`IF1, `MNONE, 17'b00xxx000000011000};
			{`IF1, 5'bxxxxx}: next = {`IF2, `MREAD, 17'b00xxx000000000010};
			{`IF2, 5'bxxxxx}: next = {`UpdatePC, `MREAD, 17'b00xxx000000000110};
			{`UpdatePC, 5'bxxxxx}: next = {`Decode, `MNONE, 17'b00xxx000000001000};
			
			//this is the only stage of state transitions when the inputs of the state machine matter
			
			{`Decode, 5'b11010}: next = {`write_imm, `MNONE, 17'b00xxx000000000000};
			{`Decode, 5'b11000}: next = {`get_rm_mov, `MNONE, 17'b00xxx000000000000};
			{`Decode, 5'b10100}: next = {`get_rm_add, `MNONE, 17'b00xxx000000000000};
			{`Decode, 5'b10101}: next = {`get_rm_cmp, `MNONE, 17'b00xxx000000000000};
			{`Decode, 5'b10110}: next = {`get_rm_and, `MNONE, 17'b00xxx000000000000};
			{`Decode, 5'b10111}: next = {`get_rm_mvn, `MNONE, 17'b00xxx000000000000};
			{`Decode, 5'b01100}: next = {`get_rn_ldr, `MNONE, 17'b00xxx000000000000};
			{`Decode, 5'b10000}: next = {`get_rn_str, `MNONE, 17'b00xxx000000000000};
			{`Decode, 5'b11100}: next = {`HALT, `MNONE, 17'b00xxx000000000000};
			
			//second stage of all instruction; from this stage onwards inputs do not matter
			//output is set to inputs necessary to perform operation in datapath
			{`write_imm, 5'bxxxxx}: next = {`IF1, `MNONE, 17'b10001000000100000};
			{`get_rm_mov, 5'bxxxxx}: next = {`mov_op, `MNONE, 17'b00100010000000000};
			{`get_rm_add, 5'bxxxxx}: next = {`get_rn_add, `MNONE, 17'b00100010000000000};
			{`get_rm_cmp, 5'bxxxxx}: next = {`get_rn_cmp, `MNONE, 17'b00100010000000000};
			{`get_rm_and, 5'bxxxxx}: next = {`get_rn_and, `MNONE, 17'b00100010000000000};
			{`get_rm_mvn, 5'bxxxxx}: next = {`mvn_op, `MNONE, 17'b00100010000000000};
			
			//third stage of most instructions (MOV, ADD, CMP, AND, MVN)
			{`mov_op, 5'bxxxxx}: next = {`write_rd_mov, `MNONE, 17'b00xxx001010000000};
			{`get_rn_add, 5'bxxxxx}: next = {`add_op, `MNONE, 17'b00001100000000000};
			{`get_rn_cmp, 5'bxxxxx}: next = {`cmp_op, `MNONE, 17'b00001100000000000};
			{`get_rn_and, 5'bxxxxx}: next = {`and_op, `MNONE, 17'b00001100000000000};
			{`mvn_op, 5'bxxxxx}: next = {`write_rd_mvn, `MNONE, 17'b00xxx001010000000};
		
		   //fouth stage of most instructions (MOV, ADD, CMP, AND, MVN)
			{`write_rd_mov, 5'bxxxxx}: next = {`IF1, `MNONE, 17'b00010000000100000};	
			{`add_op, 5'bxxxxx}: next = {`write_rd_add, `MNONE, 17'b00xxx001000000000};
			{`cmp_op, 5'bxxxxx}: next = {`write_status, `MNONE, 17'b00xxx000100000000};
			{`and_op, 5'bxxxxx}: next = {`write_rd_and, `MNONE, 17'b00xxx001000000000};
			{`write_rd_mvn, 5'bxxxxx}: next = {`IF1, `MNONE, 17'b00010000000100000};
			
			//fifth stage of some instructions (ADD, CMP, AND)
			{`write_rd_add, 5'bxxxxx}: next = {`IF1, `MNONE, 17'b00010000000100000};
			{`write_status, 5'bxxxxx}: next = {`IF1, `MNONE, 17'b00xxx000100000000};
			{`write_rd_and, 5'bxxxxx}: next = {`IF1, `MNONE, 17'b00010000000100000};
			
			//ldr instructions stages
			{`get_rn_ldr, 5'bxxxxx}: next = {`get_ldr_addr, `MNONE, 17'b00001100000000000};
			{`get_ldr_addr, 5'bxxxxx}: next = {`get_data_addr_ldr, `MNONE, 17'b00xxx001001000000};
			{`get_data_addr_ldr, 5'bxxxxx}: next = {`read_addr_ldr, `MNONE, 17'b00xxx000000000001};
			{`read_addr_ldr, 5'bxxxxx}: next = {`write_rd_ldr, `MREAD, 17'b00xxx000000000000};
			{`write_rd_ldr, 5'bxxxxx}: next = {`IF1, `MREAD, 17'b11010000000100000};
			
			//str instructions stages
			{`get_rn_str, 5'bxxxxx}: next = {`get_str_addr, `MNONE, 17'b00001100000000000};
			{`get_str_addr, 5'bxxxxx}: next = {`get_data_addr_str, `MNONE, 17'b00xxx001001000000};
			{`get_data_addr_str, 5'bxxxxx}: next = {`write_addr_str, `MNONE, 17'b00xxx000000000001};
			{`write_addr_str, 5'bxxxxx}: next = {`get_rd_str, `MNONE, 17'b00xxx000000000000};
			{`get_rd_str, 5'bxxxxx}: next = {`get_rd_out, `MNONE, 17'b00010010000000000};
			{`get_rd_out, 5'bxxxxx}: next = {`write_rd_str, `MNONE, 17'b00xxx001010000000};
			{`write_rd_str, 5'bxxxxx}: next = {`IF1, `MWRITE, 17'b00xxx000000000000};
			
			//halt instruction
			{`HALT, 5'bxxxxx}: next = {`HALT, `MNONE, 17'b00xxx000000000000};
			
			default: next = {25{1'bx}};
			
		endcase
		
	end
	
	assign {next_state, mem_cmd, vsel, nsel, loada, loadb, loadc, loads, asel, bsel, write, reset_pc, load_pc, load_ir, addr_sel, load_addr} = next; //writing all bits of next to necessary wires or outputs
	
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
			
	
	
