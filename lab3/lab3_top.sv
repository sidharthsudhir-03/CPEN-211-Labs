
  `define seven 7'b1111000
  `define zero 7'b1000000
  `define three 7'b0110000
  `define two 7'b0100100
  `define six 7'b0000010
  `define one 7'b1111001
  `define four 7'b00011001
  `define five 7'b00010010
  `define eight 7'b00000000
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
  wire rst_n = ~KEY[3]; // this is your reset; your reset should be synchronous and active-low

  // put your solution code here!
  
  reg [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
  wire [`wid-1:0] ps, ns_rst;
  reg [`wid-1:0] ns;
  reg [9:0] bout; // output from FSM
  
  vDFF #(`wid) STATE(clk, ns_rst, ps);
  assign ns_rst = rst_n ? `S0 : ns;
  assign LEDR = SW;
  
  always @(*) begin
  if(SW > 10'b0000001001) begin
	{HEX5, HEX4, HEX3, HEX2, HEX1, HEX0} = {`off, `E, `R, `R, `O, `R};
  end
  else begin
		case(ps)
		//Transition to state 1 if input is 7 or to the ~7 state
		`S0 : {ns, bout} = {(SW == 10'b0000000111) ?  `S1 : `S7, SW};
		//Transition to state 2 if input is 0 or to the ~0 state
		`S1 : {ns, bout} = {(SW == 10'b0000000000) ?  `S2 : `S8, SW};
		//Transition to state 3 if input is 3 or to the ~3 state
		`S2 : {ns, bout} = {(SW == 10'b0000000011) ?  `S3 : `S9, SW};
		//Transition to state 4 if input is 2 or to the ~2 state
		`S3 : {ns, bout} = {(SW == 10'b0000000010) ?  `S4 : `S10, SW};
		//Transition to state 5 if input is 6 or to the ~6 state
		`S4 : {ns, bout} = {(SW == 10'b0000000110) ?  `S5 : `S11, SW};
		//Transition to state 6 if input is 2 or to the ~2 state
		`S5 : {ns, bout} = {(SW == 10'b0000000010) ?  `S6 : `S12, SW};
		//Stay in state 6 until reset is pressed
		`S6 : {ns, bout} = {`S6, 10'b1000000000};
		/*Transitions of incorrect digit states until closed is displayed*/
		`S7 : {ns, bout} = {`S8, SW};
		`S8 : {ns, bout} = {`S9, SW};
		`S9 : {ns, bout} = {`S10, SW};
		`S10 : {ns, bout} = {`S11, SW};
		`S11 : {ns, bout} = {`S12, SW};
		`S12 : {ns, bout} = {`S12, 10'b1111111111};
		default ns = 4'bxxxx;
		endcase
		
		//outputs to display on the LEDs
		case(bout)
		10'b0000000000 : {HEX5, HEX4, HEX3, HEX2, HEX1, HEX0} = {`off, `off, `off, `off, `off, `zero};
		10'b0000000001 : {HEX5, HEX4, HEX3, HEX2, HEX1, HEX0} = {`off, `off, `off, `off, `off, `one};
		10'b0000000010 : {HEX5, HEX4, HEX3, HEX2, HEX1, HEX0} = {`off, `off, `off, `off, `off, `two};
		10'b0000000011 : {HEX5, HEX4, HEX3, HEX2, HEX1, HEX0} = {`off, `off, `off, `off, `off, `three};
		10'b0000000100 : {HEX5, HEX4, HEX3, HEX2, HEX1, HEX0} = {`off, `off, `off, `off, `off, `four};
		10'b0000000101 : {HEX5, HEX4, HEX3, HEX2, HEX1, HEX0} = {`off, `off, `off, `off, `off, `five};
		10'b0000000110 : {HEX5, HEX4, HEX3, HEX2, HEX1, HEX0} = {`off, `off, `off, `off, `off, `six};
		10'b0000000111 : {HEX5, HEX4, HEX3, HEX2, HEX1, HEX0} = {`off, `off, `off, `off, `off, `seven};
		10'b0000001000 : {HEX5, HEX4, HEX3, HEX2, HEX1, HEX0} = {`off, `off, `off, `off, `off, `eight};
		10'b1000000000 : {HEX5, HEX4, HEX3, HEX2, HEX1, HEX0} = {`off, `off, `O, `P, `E, `N};
		10'b1111111111 : {HEX5, HEX4, HEX3, HEX2, HEX1, HEX0} = {`C, `L, `O, `S, `E, `D};
		endcase
	end
  end
endmodule
 
module vDFF (clk, in, out);
	parameter n = 1;
	input clk;
	input [n-1:0] in;
	output reg [n-1:0] out;
	
	always_ff @ (posedge clk)
		out <= in;
endmodule