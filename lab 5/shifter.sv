module shifter(in,shift,sout);

//initializing inputs
input [15:0] in;
input [1:0] shift;

//initializing output
output reg[15:0] sout;

always_comb begin 

	//different shift operations to be executed based on shift
	case(shift)
		2'b00: sout = in;
		2'b01: begin
					sout = in << 1; 
					sout[0] = 0;
				 end
		2'b10: begin 
					sout = in >> 1; 
					sout[15] = 0;
				 end
		2'b11: begin 
					sout = in >> 1; 
					sout[15] = in[15];
				 end
				 
		default: sout = {16{1'bx}};
	endcase
	
end

endmodule
