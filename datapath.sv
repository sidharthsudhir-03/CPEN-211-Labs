module datapath(clk, readnum, vsel, loada, loadb, shift, asel, bsel, ALUop, loadc, loads, writenum, write, datapath_in, Z_out, datapath_out);

	//initializing all inputs
	input [15:0] datapath_in;
	input reg loada, loadb, loadc, loads, asel, bsel, vsel, write;
	input clk;
	input reg [2:0] readnum, writenum;
	input reg[1:0] shift, ALUop;
	
	//initializing all outputs
	output Z_out;
	output [15:0] datapath_out;
	
	
	//initializing all necessary wires and regs to avoid illegal declaration
	wire ALU_Z; //value of Z that comes out of the ALU unit
	reg Z; //assigned the value of ALU_Z in a combinational block to pass to load enable register
	reg [15:0] data_in, data_out, Ain, Bin, in, out; //all necessary inputs to different instantiated modules
	wire [15:0] data_regfile, ALUout, data_outa, data_outb, sout; //all necessary outputs to different instantiated modules
	
	vDFFE #(16)LR1(clk, loada, data_out, data_outa); //loada register
	vDFFE #(16)LR2(clk, loadb, data_out, data_outb); //loadb register
	vDFFE #(16)LR3(clk, loadc, out, datapath_out);   //loadc register
	vDFFE LR4(clk, loads, Z, Z_out); //loads register
	
	regfile REGFILE(data_in,writenum,write,readnum,clk,data_regfile); //regfile module
	shifter SHIFTER(in, shift, sout); //shifter module
	ALU ALU(Ain, Bin, ALUop, ALUout, ALU_Z); //alu module
	
	//The primary purpose of this always_comb block is to convert the output wire from one module into an
	//input reg into another module
	
	always_comb begin
	
		data_in = vsel ? datapath_in : datapath_out; 
		data_out = data_regfile; //output from regfile to input to loada or loadb register
		in = data_outb; //output from loadb register to input for shifter module
		Ain = asel ? {16{1'b0}} : data_outa;
		Bin = bsel ? {{11{1'b0}}, datapath_in[4:0]} : sout;
		out = ALUout; // output wire from ALU module to input reg for loadc register
		Z = ALU_Z; //Z output wire from ALU module as input reg for loads register
		
	end
		

endmodule:datapath
