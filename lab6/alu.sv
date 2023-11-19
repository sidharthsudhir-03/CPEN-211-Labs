module ALU(Ain,Bin,ALUop,out,status);

	//initializing inputs
	input reg[15:0] Ain, Bin;
	input reg[1:0] ALUop;

	//initializing outputs
	output [15:0] out;
	output[2:0] status;

	wire[15:0] AddSub_out;
	
	AddSub #(16) (Ain, Bin, ALUop[0], AddSub_out, status[1]);
	assign out = (ALUop[1] == 1'b0) ? AddSub_out : ((ALUop[0] == 1'b0) ? Ain & Bin : ~Bin);
	assign {status[2], status[0]} = {(out[15] == {1'b1}) ? 1'b1 : 1'b0 , (out == {16{1'b0}}) ? 1'b1 : 1'b0};		

endmodule 

// add a+b or subtract a-b, check for overflow
module AddSub(a,b,sub,s,ovf) ;
  parameter n = 8 ;
  input [n-1:0] a, b ;
  input sub ;           // subtract if sub=1, otherwise add
  output [n-1:0] s ;
  output ovf ;          // 1 if overflow
  wire c1, c2 ;         // carry out of last two bits
  wire ovf = c1 ^ c2 ;  // overflow if signs don't match

  // add non sign bits
  Adder #(n-1) ai(a[n-2:0],b[n-2:0]^{n-1{sub}},sub,c1,s[n-2:0]) ;
  // add sign bits
  Adder #(1) as(a[n-1],b[n-1]^sub,c1,c2,s[n-1]) ;
endmodule


// multi-bit adder - behavioral
module Adder(a,b,cin,cout,s) ;
  parameter n = 8 ;
  input [n-1:0] a, b ;
  input cin ;
  output [n-1:0] s ;
  output cout ;
  wire [n-1:0] s;
  wire cout ;

  assign {cout, s} = a + b + cin ;
endmodule 


