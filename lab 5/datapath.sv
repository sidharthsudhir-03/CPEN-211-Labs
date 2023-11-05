module datapath(clk, readnum, vsel, loada, loadb, shift, asel, bsel, ALUop, loadc, loads, writenum, write, datapath_in, Z_out, datapath_out);

	input [15:0] datapath_in;
	input loada, loadb, loadc, loads, asel, bsel, vsel, clk, write;
	input [2:0] readnum, writenum;
	reg [2:0] writenum, readnum;
	reg loada, loadb, loadc, loads, asel, bsel, vsel, write;
	input [1:0] shift, ALUop;
	reg [1:0] shift, ALUop;
	output Z_out;
	output [15:0] datapath_out;
	
	reg [15:0] data_in, data_out, Ain, Bin;
	wire ALU_Z;
	reg Z;
	wire [15:0] data_regfile, ALUout;
	reg [15:0] in, out;
	wire [15:0] data_outa, data_outb, sout;
	
	vDFFE #(16)LR1(clk, loada, data_out, data_outa);
	vDFFE #(16)LR2(clk, loadb, data_out, data_outb);
	vDFFE #(16)LR3(clk, loadc, out, datapath_out);
	vDFFE LR4(clk, loads, Z, Z_out);
	
	regfile REGFILE(data_in,writenum,write,readnum,clk,data_regfile);
	shifter SHIFTER(in, shift, sout);
	ALU ALU(Ain, Bin, ALUop, ALUout, ALU_Z);
	
	always_comb begin
	
		data_in = vsel ? datapath_in : datapath_out;
		data_out = data_regfile;
		in = data_outb;
		Ain = asel ? {16{1'b0}} : data_outa;
		Bin = bsel ? {{11{1'b0}}, datapath_in[4:0]} : sout;
		out = ALUout;
		Z = ALU_Z;
		
	end
		

endmodule
