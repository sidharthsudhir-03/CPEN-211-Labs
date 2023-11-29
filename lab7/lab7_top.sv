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

	assign HEX3 = {7{1'b1}};
	assign HEX4 = {7{1'b1}};
	assign HEX5 = {7{1'b1}};
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
	
		case({N, V, Z})
		
			3'b000 : {HEX2, HEX1, HEX0} = {21{1'b1}};
			3'b001 : {HEX2, HEX1, HEX0} = {{14{1'b1}}, `Z};
			3'b010 : {HEX2, HEX1, HEX0} = {{7{1'b1}}, `V, {7{1'b1}}};
			3'b011 : {HEX2, HEX1, HEX0} = {{7{1'b1}}, `V, `Z};
			3'b100 : {HEX2, HEX1, HEX0} = {`N, {14{1'b1}}};
			3'b101 : {HEX2, HEX1, HEX0} = {`N, {7{1'b1}},`Z};
			3'b110 : {HEX2, HEX1, HEX0} = {`N, `V, {7{1'b1}}};
			3'b111 : {HEX2, HEX1, HEX0} = {`N, `V, `Z};
			default: {HEX2, HEX1, HEX0} = {21{1'bx}};
			
		endcase
		
	end
	
endmodule
