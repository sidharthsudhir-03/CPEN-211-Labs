module regfile(data_in,writenum,write,readnum,clk,data_out);
	input [15:0] data_in;
	input [2:0] writenum, readnum;
	reg [2:0] writenum, readnum;
	input write, clk;
	output [15:0] data_out;
	reg [15:0] data_out;
	wire [7:0] writenum_onebit, readnum_onebit;
	wire [15:0] R0, R1, R2, R3, R4, R5, R6, R7;
	wire [7:0] w_en, r_en;

	Dec38(writenum, writenum_onebit);
	Dec38(readnum, readnum_onebit);

	assign w_en = writenum_onebit & {8{write}};
	assign r_en = readnum_onebit & {8{~write}};

	vDFFE(clk, w_en[0], data_in, R0);
	vDFFE(clk, w_en[1], data_in, R1);
	vDFFE(clk, w_en[2], data_in, R2);
	vDFFE(clk, w_en[3], data_in, R3);
	vDFFE(clk, w_en[4], data_in, R4);
	vDFFE(clk, w_en[5], data_in, R5);
	vDFFE(clk, w_en[6], data_in, R6);
	vDFFE(clk, w_en[7], data_in, R7);

	always_comb begin
		case(r_en)
			8'b00000001: data_out = R0;
			8'b00000010: data_out = R1;
			8'b00000100: data_out = R2;
			8'b00001000: data_out = R3;
			8'b00010000: data_out = R4;
			8'b00100000: data_out = R5;
			8'b01000000: data_out = R6;
			8'b10000000: data_out = R7;
			default: data_out = {15{1'bx}};
		endcase
	end


endmodule: regfile


module vDFFE(clk, en, in, out) ;
  parameter n = 1; 
  input clk, en ;
  input  [n-1:0] in ;
  output [n-1:0] out ;
  reg    [n-1:0] out ;
  wire   [n-1:0] next_out ;

  assign next_out = en ? in : out;

  always_ff @(posedge clk)
    out <= next_out;  
endmodule

module Dec38(a, b) ;
  input  [2:0] a ;
  output [7:0] b ;
  wire [7:0] b = 1 << a ;
endmodule

