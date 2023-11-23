module ALU(Ain,Bin,ALUop,out,status);

	//initializing inputs
	input reg[15:0] Ain, Bin;
	input reg[1:0] ALUop;

	//initializing outputs
	output reg [15:0] out;
	output reg[2:0] status;
	
	wire [16:0] ovf_out;
	assign ovf_out = Ain - Bin;

always_comb begin 

   //different alu operations to be executed based on ALUop
	case(ALUop)
		2'b00: {out, status} = {Ain + Bin, 3'bxxx};
		2'b01: {out, status} = {{16{1'bx}}, (ovf_out[15] == 1'b1) ? 1'b1 : 1'b0, (ovf_out[16] != ovf_out[15]) ? 1'b1 : 1'b0, (ovf_out[15:0] == {16{1'b0}}) ? 1'b1 : 1'b0} ;
		2'b10: {out, status} = {Ain & Bin, 3'bxxx};
		2'b11: {out, status} = {~Bin, 3'bxxx};	
		default: {out, status} = {19{1'bx}};
	endcase
	
	
end		

endmodule 




