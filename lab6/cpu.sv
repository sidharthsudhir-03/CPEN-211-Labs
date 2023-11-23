module cpu(clk,reset,s,load,in,out,N,V,Z,w);
	input reg clk, reset, s, load;
	input reg [15:0] in;
	output [15:0] out;
	output N, V, Z, w;
	
	wire[15:0]in_load; //load register port
	
	//idecoder ports
	reg[2:0] nsel_id;
	reg [15:0] instruction_id;
	wire[15:0] sximm5_id, sximm8_id;
	wire[1:0] ALUop_id, shift_id, op_id;
	wire[2:0] writenum_id, opcode_id;
	wire[2:0] readnum_id;
	
	//datpath ports
	reg [15:0] mdata, sximm8_data, sximm5_data;
	reg[7:0] PC;
	reg loada_data, loadb_data, loadc_data, loads_data, asel_data, bsel_data, write_data;
	reg[1:0] vsel_data;
	reg [2:0] readnum_data, writenum_data;
	reg[1:0] shift_data, ALUop_data;
	
	//controller_fsm ports
	reg[2:0] opcode_fsm;
	reg[1:0] op_fsm;
	wire loada_fsm, loadb_fsm, loadc_fsm, loads_fsm, asel_fsm, bsel_fsm, write_fsm;
	wire[1:0] vsel_fsm;
	wire[2:0] nsel_fsm;
	
	vDFFE #(16) IF(clk, load, in, in_load);
	idecoder ID(instruction_id, nsel_id, ALUop_id, sximm5_id, sximm8_id, shift_id, readnum_id, writenum_id, opcode_id, op_id);
	datapath DP(clk, readnum_data, vsel_data, loada_data, loadb_data, shift_data, asel_data, bsel_data, ALUop_data, loadc_data, loads_data, writenum_data, write_data, mdata, sximm8_data, sximm5_data, PC, N, V, Z, out);
	controller_fsm  FSM(clk, s, reset, opcode_fsm, op_fsm, nsel_fsm, loada_fsm, loadb_fsm, loadc_fsm, loads_fsm, asel_fsm, bsel_fsm, vsel_fsm, write_fsm, w);
	
	always_comb begin 
	
		mdata =16'b0;
		PC = 8'b0;
		instruction_id = in_load;
		nsel_id = nsel_fsm;
		sximm5_data = sximm5_id;
		sximm8_data = sximm8_id;
		loada_data = loada_fsm;
		loadb_data = loadb_fsm;
		loadc_data = loadc_fsm;
		loads_data = loads_fsm;
		asel_data = asel_data;
		bsel_data = bsel_data;
		vsel_data = vsel_fsm;
		nsel_id = nsel_fsm;
		write_data = write_fsm;
		opcode_fsm = opcode_id;
		op_fsm = op_id;
		readnum_data = readnum_id;
		writenum_data = writenum_id;
		shift_data = shift_id;
		ALUop_data = ALUop_id;
		
	end

endmodule 
