module idecoder(instruction, nsel, ALUop, sximm5, sximm8, shift, readnum, writenum, opcode, op);

	input[15:0] instruction;
	input[1:0] nsel;
	output[15:0] sximm5, sximm8;
	output[1:0] ALUop, shift, op;
	output[2:0] readnum, writenum, opcode;
	wire[3:0] Rn, Rd, Rm;
	
	assign sximm5 = {{11{instruction[4]}}, instruction[4:0]};
	assign sximm8 = {{8{instruction[7]}}, instruction[7:0]};
	assign ALUop = instruction[12:11];
	assign shift = instruction[4:3];
	assign opcode = instruction[15:13];
	assign op = instruction[12:11];
	assign Rn = instruction[10:8];
	assign Rd = instruction[7:5];
	assign Rm = instruction[2:0];
	assign readnum = (nsel[1] == 1'b0) ? ((nsel[0] == 1'b0) ? Rn : Rd) : ((nsel[0] == 1'b0) ? Rm : 3'bxxx);
	
endmodule 