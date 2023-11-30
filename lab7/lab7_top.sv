module lab7_top(KEY,SW,LEDR,HEX0,HEX1,HEX2,HEX3,HEX4,HEX5);

	`define N 7'b1001000
	`define V 7'b1000001
	`define Z 7'b0100100

	input[3:0]KEY; 
	input[9:0]SW; 
	output[9:0]LEDR; 
	output reg[6:0]HEX0,HEX1,HEX2,HEX3,HEX4,HEX5;
	
	//wire|regs instantiations
	wire dout_en, sw_en, ledr_load;
	
	//cpu I/O ports
	reg [15:0] read_data_cpu;
	wire [1:0] mem_cmd;
	wire [8:0] mem_addr;
	wire [15:0] write_data;
	wire N, V, Z;
	
	//ram I/O ports
	reg [7:0] read_address, write_address;
	reg [15:0] din;
	reg write;
	wire [15:0] dout;
	
	//module instantiation 
	cpu CPU(KEY[0], ~KEY[1], read_data_cpu, mem_cmd, mem_addr, write_data, N, V, Z);
	ram MEM(KEY[0],read_address,write_address,write,din,dout);
	vDFFE #(8) LED_R(KEY[0], ledr_load, write_data[7:0], LEDR[7:0]);
	sseg H0(write_data[3:0],   HEX0);
	sseg H1(write_data[7:4],   HEX1);
	sseg H2(write_data[11:8],  HEX2);
	sseg H3(write_data[15:12], HEX3);


	assign HEX5[0] = ~Z;
	assign HEX5[6] = ~N;
	assign HEX5[3] = ~V;
	assign HEX4 = {7{1'b1}};
	assign {HEX5[2:1],HEX5[5:4]} = 4'b1111; // disabled
	assign LEDR[9:8] = 2'b00;
	assign dout_en = (mem_cmd == 2'b10) & (mem_addr[8] == 1'b0);
	assign sw_en =  (mem_cmd == 2'b10) & (mem_addr == 9'h140);
	assign ledr_load = (mem_cmd == 2'b11) & (mem_addr == 9'h100);
	
	always_comb begin

		read_address = mem_addr[7:0];
		write_address = mem_addr[7:0];
		din = write_data;
		read_data_cpu = dout_en ? dout : sw_en ? {8'b0, SW[7:0]} : 16'b0;
		write = (mem_cmd == 2'b11) & (mem_addr[8] == 1'b0); 
		
	end
	
endmodule

module sseg(in,segs);

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
  `define A 7'b0001000
  `define B 7'b0000000
  `define C 7'b1000110
  `define D 7'b1000000
  `define E 7'b0000110
  `define F 7'b0001110
  
  input [3:0] in;
  output [6:0] segs;


  always_comb begin 
  
	  case(in)
		4'b0000: segs = `ZERO;
		4'b0001: segs = `ONE;
		4'b0010: segs = `TWO;
		4'b0011: segs = `THREE;
		4'b0100: segs = `FOUR;
		4'b0101: segs = `FIVE;
		4'b0110: segs = `SIX;
		4'b0111: segs = `SEVEN;
		4'b1000: segs = `EIGHT;
		4'b1001: segs = `NINE;
		4'b1010: segs = `A;
		4'b1011: segs = `B;
		4'b1100: segs = `C;
		4'b1101: segs = `D;
		4'b1110: segs = `E;
		4'b1111: segs = `F;
		default: segs = 7'bxxxxxxx;
	  endcase
	end  

endmodule




