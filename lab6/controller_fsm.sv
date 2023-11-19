module controller_fsm(clk, s, reset, opcode, op, nsel, w, loada, loadb, loadc, loads, asel, bsel, vsel, write);

	input clk, s, reset;
	input[2:0] opcode;
	input[1:0] op;
	output w, loada, loadb, loadc, loads, asel, bsel, write;
	output[1:0] vsel, nsel;
	