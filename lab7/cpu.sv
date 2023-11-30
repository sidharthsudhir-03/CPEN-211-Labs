module cpu(clk, reset, read_data, mem_cmd, mem_addr, write_data, N, V, Z);
	input reg clk, reset;
	input reg [15:0] read_data;
	output [15:0] write_data;
	output [1:0] mem_cmd;
	output reg [8:0] mem_addr;
	output N, V, Z;
	
	//initializing cpu wires and regs
	reg[8:0] next_pc;
	wire[8:0] PC;
	wire[8:0] data_addr;
	wire[15:0]in_load; //load register port
	
	//idecoder I/O ports
	reg[2:0] nsel_id;
	reg [15:0] instruction_id;
	wire[15:0] sximm5_id, sximm8_id;
	wire[1:0] ALUop_id, shift_id, op_id;
	wire[2:0] writenum_id, opcode_id;
	wire[2:0] readnum_id;
	
	//datpath I/O ports
	reg [15:0] mdata, sximm8_data, sximm5_data;
	reg[7:0] PC_data;
	reg w_data, loada_data, loadb_data, loadc_data, loads_data, asel_data, bsel_data;
	reg[1:0] vsel_data;
	reg [2:0] readnum_data, writenum_data;
	reg[1:0] shift_data, ALUop_data;
	
	//controller_fsm I/O ports
	reg[2:0] opcode_fsm;
	reg[1:0] op_fsm;
	wire loada_fsm, loadb_fsm, loadc_fsm, loads_fsm, asel_fsm, bsel_fsm, w_fsm, reset_pc, load_pc, load_ir, addr_sel, load_addr;
	wire[1:0] vsel_fsm, mem_cmd;
	wire[2:0] nsel_fsm;
	
	
	
	//initializing all the high level modules
	vDFFE #(9) PCR(clk, load_pc, next_pc, PC);
	vDFFE #(9) DAR(clk, load_addr, write_data[8:0], data_addr);
	vDFFE #(16) IR(clk, load_ir, read_data, in_load);
	idecoder ID(instruction_id, nsel_id, ALUop_id, sximm5_id, sximm8_id, shift_id, readnum_id, writenum_id, opcode_id, op_id);
	datapath DP(clk, readnum_data, vsel_data, loada_data, loadb_data, shift_data, asel_data, bsel_data, ALUop_data, loadc_data, loads_data, writenum_data, w_data, mdata, sximm8_data, sximm5_data, PC_data, N, V, Z, write_data);
	controller_fsm  FSM(clk, reset, opcode_fsm, op_fsm, nsel_fsm, loada_fsm, loadb_fsm, loadc_fsm, loads_fsm, asel_fsm, bsel_fsm, vsel_fsm, w_fsm, reset_pc, load_pc, load_ir, mem_cmd, addr_sel, load_addr);
	
	//this always block is used to connect the ports across the different modules
	//the values of the outputs (wires) are assigned to the inputs of other modules (regs)
	always_comb begin 
	
		mdata = read_data;
		mem_addr = addr_sel ? PC : data_addr;
		next_pc = reset_pc ? 9'b0 : (PC + 9'd1);
		PC_data = PC[7:0];
		instruction_id = in_load;
		nsel_id = nsel_fsm;
		sximm5_data = sximm5_id;
		sximm8_data = sximm8_id;
		loada_data = loada_fsm;
		loadb_data = loadb_fsm;
		loadc_data = loadc_fsm;
		loads_data = loads_fsm;
		asel_data = asel_fsm;
		bsel_data = bsel_fsm;
		vsel_data = vsel_fsm;
		nsel_id = nsel_fsm;
		w_data = w_fsm;
		opcode_fsm = opcode_id;
		op_fsm = op_id;
		readnum_data = readnum_id;
		writenum_data = writenum_id;
		shift_data = shift_id;
		ALUop_data = ALUop_id;
		
	end

endmodule 