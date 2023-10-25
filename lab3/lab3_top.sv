module lab3(SW,KEY,HEX0,HEX1,HEX2,HEX3,HEX4,HEX5,LEDR);
  input [9:0] SW;
  input [3:0] KEY;
  output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
  output [9:0] LEDR;   // optional: use these outputs for debugging on your DE1-SoC

  wire clk = ~KEY[0];  // this is your clock
  wire rst_n = ~KEY[3]; // this is your reset; your reset should be synchronous and active-low
  wire [3:0] present_state;
  reg [3:0] next_state;
  wire [3:0] next_state_reset; // this is the state value that depends on reset
  reg [9:0] bin_out; // this is output of the state transition that is fed to the decoder
  reg [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
  
  `define Sw 4 // State Width
  
  //State definitions
  
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
  `define Er 4'b1110
  
  vDFF #(`Sw) U1(clk, next_state_reset, present_state);
  
  // This assign statement decides wheter to reset the state machine or not
  
  assign next_state_reset = rst_n ? `Sa : next_state;
  assign LEDR = SW;
  
  always @(*) begin
  
	//This case statement describes state transitions
	
		case(present_state)
		
			`Sa: {next_state, bin_out} = {(SW == 10'd7) ? `Sb : `Wa, (SW > 10'd9) ? 10'b1111110011 : SW};
			`Sb: {next_state, bin_out} = {(SW == 10'd0) ? `Sc : `Wb, (SW > 10'd9) ? 10'b1111110011 : SW};
			`Sc: {next_state, bin_out} = {(SW == 10'd3) ? `Sd : `Wc, (SW > 10'd9) ? 10'b1111110011 : SW};
			`Sd: {next_state, bin_out} = {(SW == 10'd2) ? `Se : `Wd, (SW > 10'd9) ? 10'b1111110011 : SW};
			`Se: {next_state, bin_out} = {(SW == 10'd6) ? `Sf : `We, (SW > 10'd9) ? 10'b1111110011 : SW};
			`Sf: {next_state, bin_out} = {(SW == 10'd2) ? `Sg : `Wf, (SW > 10'd9) ? 10'b1111110011 : SW};
			`Sg: {next_state, bin_out} = {`Op, 10'b1111111111};
			`Op: {next_state, bin_out} = {`Op, 10'b1111111111};
			`Wa: {next_state, bin_out} = {`Wb, (SW > 10'd9) ? 10'b1111110011 : SW};
			`Wb: {next_state, bin_out} = {`Wc, (SW > 10'd9) ? 10'b1111110011 : SW};
			`Wc: {next_state, bin_out} = {`Wd, (SW > 10'd9) ? 10'b1111110011 : SW};
			`Wd: {next_state, bin_out} = {`We, (SW > 10'd9) ? 10'b1111110011 : SW};
			`We: {next_state, bin_out} = {`Wf, (SW > 10'd9) ? 10'b1111110011 : SW};
			`Wf: {next_state, bin_out} = {`Cl, 10'b1111110000};
			`Cl: {next_state, bin_out} = {`Cl, 10'b1111110000};
		
		default: {next_state, bin_out} = {14{1'bx}};
			
		endcase
		
		
		// This case statement decodes 'bin_out' to the seven segment display
		
	case(bin_out)
		
		10'b0000000000: {HEX5, HEX4, HEX3, HEX2, HEX1, HEX0} = {{35{1'b1}}, 7'b1000000};//0
		10'b0000000001: {HEX5, HEX4, HEX3, HEX2, HEX1, HEX0} = {{35{1'b1}}, 7'b1111001};//1
		10'b0000000010: {HEX5, HEX4, HEX3, HEX2, HEX1, HEX0} = {{35{1'b1}}, 7'b0100100};//2
		10'b0000000011: {HEX5, HEX4, HEX3, HEX2, HEX1, HEX0} = {{35{1'b1}}, 7'b0110000};//3
		10'b0000000100: {HEX5, HEX4, HEX3, HEX2, HEX1, HEX0} = {{35{1'b1}}, 7'b0011001};//4
		10'b0000000101: {HEX5, HEX4, HEX3, HEX2, HEX1, HEX0} = {{35{1'b1}}, 7'b0010010};//5
		10'b0000000110: {HEX5, HEX4, HEX3, HEX2, HEX1, HEX0} = {{35{1'b1}}, 7'b0000010};//6
		10'b0000000111: {HEX5, HEX4, HEX3, HEX2, HEX1, HEX0} = {{35{1'b1}}, 7'b1111000};//7
		10'b0000001000: {HEX5, HEX4, HEX3, HEX2, HEX1, HEX0} = {{35{1'b1}}, 7'b0000000};//8
		10'b0000001001: {HEX5, HEX4, HEX3, HEX2, HEX1, HEX0} = {{35{1'b1}}, 7'b0010000};//9
		10'b1111110011: {HEX5, HEX4, HEX3, HEX2, HEX1, HEX0} = {{7{1'b1}}, 7'b0000110, 7'b0101111, 7'b0101111, 7'b1000000, 7'b0101111}; //OPEn
		10'b1111110000: {HEX5, HEX4, HEX3, HEX2, HEX1, HEX0} = {7'b1000110, 7'b1000111, 7'b1000000, 7'b0010010, 7'b0000110, 7'b1000000}; //CLOSED
		10'b1111111111: {HEX5, HEX4, HEX3, HEX2, HEX1, HEX0} = {{14{1'b1}}, 7'b1000000, 7'b0001100, 7'b0000110, 7'b1001000}; //ErrOr
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

