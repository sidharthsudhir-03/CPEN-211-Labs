
  `define seven 7'b1111000
  `define zero 7'b1000000
  `define three 7'b0110000
  `define two 7'b0100110
  `define six 7'b0000010
  `define wid 4
  `define S0 4'b0000	//reset
  `define S1 4'b0001	//7
  `define S2 4'b0010	//0
  `define S3 4'b0011	//3
  `define S4 4'b0100	//2
  `define S5 4'b0101	//6
  `define S6 4'b0110	//2
  `define S7 4'b0111	//~7
  `define S8 4'b1000	//~0
  `define S9 4'b1001	//~3
  `define S10 4'b1010	//~2
  `define S11 4'b1011	//~6
  `define S12 4'b1100	//~2
  `define O 7'b1000000
  `define P 7'b0001100
  `define E 7'b0000110
  `define N 7'b1001000
  `define C 7'b1000110
  `define L 7'b1000111
  `define S 7'b0010010
  `define D 7'b0100001
  `define R 7'b1001110
  `define off 7'b1111111

module lab3_top(SW,KEY,HEX0,HEX1,HEX2,HEX3,HEX4,HEX5,LEDR);
  input [9:0] SW;
  input [3:0] KEY;
  output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
  output [9:0] LEDR;   // optional: use these outputs for debugging on your DE1-SoC

  wire clk = ~KEY[0];  // this is your clock
  wire rst_n = KEY[3]; // this is your reset; your reset should be synchronous and active-low

  // put your solution code here!
  
  wire [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
  wire [`wid-1:0] ps, ns_rst;
  reg [`wid-1:0] ns;
  
  vDFF #(`wid) STATE(clk, ns_rst, ps);
  assign ns_rst = rst_n ? `S0 : ns;
  assign LDR = SW;
  
  
  always @(*) begin
  {HEX5, HEX4, HEX3, HEX2, HEX1, HEX0} = `off;
		case(ps)
			
		`S0 : if(SW == 10'b0000000111) begin
				ns = `S1;
				{HEX5, HEX4, HEX3, HEX2, HEX1, HEX0} = {`off, `off, `off, `off, `off, `seven};
			end
			else if(SW > 10'b0000001001) begin
				{HEX5, HEX4, HEX3, HEX2, HEX1, HEX0} = {`off, `E, `R, `R, `O, `R};
			end
			else begin
				ns = `S7;
				{HEX5, HEX4, HEX3, HEX2, HEX1, HEX0} = {`off, `off, `off, `off, `off, `off};
			end
				
		`S1 : if(SW == 10'b0000000000) begin
				ns = `S2;
				{HEX5, HEX4, HEX3, HEX2, HEX1, HEX0} = {`off, `off, `off, `off, `off, `zero};
			end
			else if(SW > 10'b0000001001) begin
				{HEX5, HEX4, HEX3, HEX2, HEX1, HEX0} = {`off, `E, `R, `R, `O, `R};
			end
			else begin
				ns = `S8;
				{HEX5, HEX4, HEX3, HEX2, HEX1, HEX0} = {`off, `off, `off, `off, `off, `off};
			end
				
		`S2 : if(SW == 10'b0000000011) begin
				ns = `S3;
				{HEX5, HEX4, HEX3, HEX2, HEX1, HEX0} = {`off, `off, `off, `off, `off, `three};
			end
			else if(SW > 10'b0000001001) begin
				{HEX5, HEX4, HEX3, HEX2, HEX1, HEX0} = {`off, `E, `R, `R, `O, `R};
			end
			else begin
				ns = `S9;
				{HEX5, HEX4, HEX3, HEX2, HEX1, HEX0} = {`off, `off, `off, `off, `off, `off};
			end
				
		`S3 : if(SW == 10'b0000000010) begin
				ns = `S4;
				{HEX5, HEX4, HEX3, HEX2, HEX1, HEX0} = {`off, `off, `off, `off, `off, `two};
			end
			else if(SW > 10'b0000001001) begin
				{HEX5, HEX4, HEX3, HEX2, HEX1, HEX0} = {`off, `E, `R, `R, `O, `R};
			end
			else begin
				ns = `S10;
				{HEX5, HEX4, HEX3, HEX2, HEX1, HEX0} = {`off, `off, `off, `off, `off, `off};
			end
				
		`S4 : if(SW == 10'b0000000110) begin
				ns = `S5;
				{HEX5, HEX4, HEX3, HEX2, HEX1, HEX0} = {`off, `off, `off, `off, `off, `six};
			end
			else if(SW > 10'b0000001001) begin
				{HEX5, HEX4, HEX3, HEX2, HEX1, HEX0} = {`off, `E, `R, `R, `O, `R};
			end
			else begin
				ns = `S11;
				{HEX5, HEX4, HEX3, HEX2, HEX1, HEX0} = {`off, `off, `off, `off, `off, `off};
			end
				
		`S5 : if(SW == 10'b0000000010) begin
				ns = `S6;
				{HEX5, HEX4, HEX3, HEX2, HEX1, HEX0} = {`off, `off, `off, `off, `off, `two};
			end
			else if(SW > 10'b0000001001) begin
				{HEX5, HEX4, HEX3, HEX2, HEX1, HEX0} = {`off, `E, `R, `R, `O, `R};
			end
			else begin
				ns = `S12;
				{HEX5, HEX4, HEX3, HEX2, HEX1, HEX0} = {`C, `L, `O, `S, `E, `D};
			end
		
		`S6 : if(SW > 10'b0000001001) begin
				{HEX5, HEX4, HEX3, HEX2, HEX1, HEX0} = {`off, `E, `R, `R, `O, `R};
			end
			else begin
				{ns, HEX5, HEX4, HEX3, HEX2, HEX1, HEX0} = {(rst_n ? `S0 : `S6), `off, `off, `O, `P, `E, `N};
			end
				
		`S7 : if(SW > 10'b0000001001) begin
				{HEX5, HEX4, HEX3, HEX2, HEX1, HEX0} = {`off, `E, `R, `R, `O, `R};
			end
			else begin
				{ns, HEX5, HEX4, HEX3, HEX2, HEX1, HEX0} = {(rst_n ? `S0 : `S8), `off, `off, `off, `off, `off, `off};
			end
		`S8 : if(SW > 10'b0000001001) begin
				{HEX5, HEX4, HEX3, HEX2, HEX1, HEX0} = {`off, `E, `R, `R, `O, `R};
			end
			else begin
				{ns, HEX5, HEX4, HEX3, HEX2, HEX1, HEX0} = {(rst_n ? `S0 : `S9), `off, `off, `off, `off, `off, `off};
			end
		`S9 : if(SW > 10'b0000001001) begin
				{HEX5, HEX4, HEX3, HEX2, HEX1, HEX0} = {`off, `E, `R, `R, `O, `R};
			end
			else begin
				{ns, HEX5, HEX4, HEX3, HEX2, HEX1, HEX0} = {(rst_n ? `S0 : `S10), `off, `off, `off, `off, `off, `off};
			end
		`S10 : if(SW > 10'b0000001001) begin
				{HEX5, HEX4, HEX3, HEX2, HEX1, HEX0} = {`off, `E, `R, `R, `O, `R};
			end
			else begin
				{ns, HEX5, HEX4, HEX3, HEX2, HEX1, HEX0} = {(rst_n ? `S0 : `S11), `off, `off, `off, `off, `off, `off};
			end
		`S11 : if(SW > 10'b0000001001) begin
				{HEX5, HEX4, HEX3, HEX2, HEX1, HEX0} = {`off, `E, `R, `R, `O, `R};
			end
			else begin
				{ns, HEX5, HEX4, HEX3, HEX2, HEX1, HEX0} = {(rst_n ? `S0 : `S12), `off, `off, `off, `off, `off, `off};
			end
		`S12 : if(SW > 10'b0000001001) begin
				{HEX5, HEX4, HEX3, HEX2, HEX1, HEX0} = {`off, `E, `R, `R, `O, `R};
			end
			else begin
				{ns, HEX5, HEX4, HEX3, HEX2, HEX1, HEX0} = {(rst_n ? `S0 : `S12), `C, `L, `O, `S, `E, `D};
			end
		
		default : ns = 4'bxxxx;
		
		endcase
  end
  
endmodule

module vDFF (clk, in, out);
	parameter n = 1;
	input clk;
	input [n-1:0] in;
	output reg [n-1:0] out;
	always_ff @(posedge clk) begin
		out <= in;
	end
endmodule
