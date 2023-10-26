module lab3_top(SW,KEY,HEX0,HEX1,HEX2,HEX3,HEX4,HEX5,LEDR);
  
  `define Sw 4 // State Width
  
  //State definitions (Sn -> Correct Inpute States; Wn -> Wrong Input States )
  
  `define Sa 4'b0001
  `define Sb 4'b0010
  `define Sc 4'b0011
  `define Sd 4'b0100
  `define Se 4'b0101
  `define Sf 4'b0110
  `define Sg 4'b0111
  `define Wa 4'b1000
  `define Wb 4'b1001
  `define Wc 4'b1010
  `define Wd 4'b1011
  `define We 4'b1100
  `define Wf 4'b1101
  `define Cl 4'b0000
  `define Op 4'b1111
  
  /* 
    Some Binary Output Definitions (Binary Output is thought of as the encoded version of the 
	 output shown in the Seven Segment Display) 
  */
	
	`define OPEN 10'b1111111111
	`define CLOSED 10'b1111110000
	`define ErrOr 10'b1111110011
  
  //Seven Segment Display Definitions
  
  `define ZERO 7'b1000000
  `define ONE 7'b1111001
  `define TWO 7'b0100100
  `define THREE 7'b0110000
  `define FOUR 7'b0011001
  `define FIVE 7'b0010010
  `define SIX 7'b0000010
  `define SEVEN 7'b1111000
  `define EIGHT 7'b0000000
  `define NINE 7'b0010000
  `define O 7'b1000000
  `define P 7'b0001100
  `define E 7'b0000110
  `define N 7'b1001000
  `define C 7'b1000110
  `define L 7'b1000111
  `define S 7'b0010010
  `define D 7'b1000000
  `define r 7'b0101111
  `define OFF 7'b1111111
  
  input [9:0] SW;
  input [3:0] KEY;
  output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
  output [9:0] LEDR;   // optional: use these outputs for debugging on your DE1-SoC

  wire clk = ~KEY[0];  // this is your clock
  wire rst_n = ~KEY[3]; // this is your reset; your reset should be synchronous and active-low
  wire [`Sw-1:0] present_state;
  reg [`Sw-1:0] next_state;
  wire [`Sw-1:0] next_state_reset; // this is the state value that depends on reset
  reg [9:0] bin_out; // binary encoded output
  reg [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
  
  
  // A 4-bit D-Flip Flop to record state transition 
  vDFF #(`Sw) U1(clk, next_state_reset, present_state);
  
  // This assign statement decides wheter to reset the state machine or not
  assign next_state_reset = rst_n ? `Sa : next_state;
  
  assign LEDR = SW;
  
  always @(*) begin
  
	// This case statement describes state transitions and the encoded output associated ('bin_out')
	
		case(present_state)
		
			`Sa: {next_state, bin_out} = {(SW == 10'd7) ? `Sb : `Wa, (SW > 10'd9) ? `ErrOr : SW};
			`Sb: {next_state, bin_out} = {(SW == 10'd0) ? `Sc : `Wb, (SW > 10'd9) ? `ErrOr : SW};
			`Sc: {next_state, bin_out} = {(SW == 10'd3) ? `Sd : `Wc, (SW > 10'd9) ? `ErrOr : SW};
			`Sd: {next_state, bin_out} = {(SW == 10'd2) ? `Se : `Wd, (SW > 10'd9) ? `ErrOr : SW};
			`Se: {next_state, bin_out} = {(SW == 10'd6) ? `Sf : `We, (SW > 10'd9) ? `ErrOr : SW};
			`Sf: {next_state, bin_out} = {(SW == 10'd2) ? `Sg : `Wf, (SW > 10'd9) ? `ErrOr : SW};
			`Sg: {next_state, bin_out} = {`Op, `OPEN};
			`Op: {next_state, bin_out} = {`Op, `OPEN};
			`Wa: {next_state, bin_out} = {`Wb, (SW > 10'd9) ? `ErrOr : SW};
			`Wb: {next_state, bin_out} = {`Wc, (SW > 10'd9) ? `ErrOr : SW};
			`Wc: {next_state, bin_out} = {`Wd, (SW > 10'd9) ? `ErrOr : SW};
			`Wd: {next_state, bin_out} = {`We, (SW > 10'd9) ? `ErrOr : SW};
			`We: {next_state, bin_out} = {`Wf, (SW > 10'd9) ? `ErrOr : SW};
			`Wf: {next_state, bin_out} = {`Cl, `CLOSED};
			`Cl: {next_state, bin_out} = {`Cl, `CLOSED};
			default: {next_state, bin_out} = {{4{1'bx}}, (SW > 10'd9) ? `ErrOr : SW};
			
		endcase
		
	// This case statement decodes 'bin_out' to the seven segment display
		
		case(bin_out)
			
			10'd0: {HEX5, HEX4, HEX3, HEX2, HEX1, HEX0} = {{5{`OFF}}, `ZERO};
			10'd1: {HEX5, HEX4, HEX3, HEX2, HEX1, HEX0} = {{5{`OFF}}, `ONE};
			10'd2: {HEX5, HEX4, HEX3, HEX2, HEX1, HEX0} = {{5{`OFF}}, `TWO};
			10'd3: {HEX5, HEX4, HEX3, HEX2, HEX1, HEX0} = {{5{`OFF}}, `THREE};
			10'd4: {HEX5, HEX4, HEX3, HEX2, HEX1, HEX0} = {{5{`OFF}}, `FOUR};
			10'd5: {HEX5, HEX4, HEX3, HEX2, HEX1, HEX0} = {{5{`OFF}}, `FIVE};
			10'd6: {HEX5, HEX4, HEX3, HEX2, HEX1, HEX0} = {{5{`OFF}}, `SIX};
			10'd7: {HEX5, HEX4, HEX3, HEX2, HEX1, HEX0} = {{5{`OFF}}, `SEVEN};
			10'd8: {HEX5, HEX4, HEX3, HEX2, HEX1, HEX0} = {{5{`OFF}}, `EIGHT};
			10'd9: {HEX5, HEX4, HEX3, HEX2, HEX1, HEX0} = {{5{`OFF}}, `NINE};
			`ErrOr: {HEX5, HEX4, HEX3, HEX2, HEX1, HEX0} = {`OFF, `E, `r, `r, `O, `r}; 
			`CLOSED: {HEX5, HEX4, HEX3, HEX2, HEX1, HEX0} = {`C, `L, `O, `S, `E, `D}; 
			`OPEN: {HEX5, HEX4, HEX3, HEX2, HEX1, HEX0} = {{2{`OFF}}, `O, `P, `E, `N};
			default: {HEX5, HEX4, HEX3, HEX2, HEX1, HEX0} = {42{1'bx}};
				
		endcase
	
  end
   
endmodule

// n-bit D-Flip Flop module declaration 

module vDFF(clk, in, out);
	parameter n = 1;
	input clk;
	input [n-1:0] in;
	output reg [n-1:0] out;

	always_ff @ (posedge clk)
		out <= in;
endmodule

