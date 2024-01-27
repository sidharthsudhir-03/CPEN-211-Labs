module ALU(Ain,Bin,ALUop,out,Z);

//initializing inputs
input [15:0] Ain, Bin;
input [1:0] ALUop;

//initializing outputs
output reg[15:0] out;
output reg Z;


always_comb begin 

   //different alu operations to be executed based on ALUop
	case(ALUop)
		2'b00: out = Ain + Bin;
		2'b01: out = Ain - Bin;
		2'b10: out = Ain & Bin;
		2'b11: out = ~Bin;	
		default: out = {16{1'bx}};
	endcase
	
	//determining value of Z depending on output value
	case(out)
		{16{1'b0}}: Z = 1'b1;
		default: Z = 1'b0;
	endcase
	
end
		

endmodule 
