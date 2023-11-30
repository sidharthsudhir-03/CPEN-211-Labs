module lab7_top_tb;
  reg [3:0] KEY;
  reg [9:0] SW;
  wire [9:0] LEDR; 
  wire [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
  reg err;

  lab7_top DUT(KEY,SW,LEDR,HEX0,HEX1,HEX2,HEX3,HEX4,HEX5);

  initial forever begin
    KEY[0] = 0; #5;
    KEY[0] = 1; #5;
  end

  initial begin
    err = 0;
    KEY[1] = 1'b0; // reset asserted
	 
	 //memory allocation check
    
    if (DUT.MEM.mem[0] !== 16'b1101000000010100) begin err = 1; $display("FAILED: mem[0] wrong"); $stop; end
    if (DUT.MEM.mem[1] !== 16'b1101000100010101) begin err = 1; $display("FAILED: mem[1] wrong"); $stop; end
    if (DUT.MEM.mem[2] !== 16'b0110000000000000) begin err = 1; $display("FAILED: mem[2] wrong"); $stop; end
    if (DUT.MEM.mem[3] !== 16'b0110000100100000) begin err = 1; $display("FAILED: mem[3] wrong"); $stop; end
    if (DUT.MEM.mem[4] !== 16'b1101001000010011) begin err = 1; $display("FAILED: mem[4] wrong"); $stop; end
    if (DUT.MEM.mem[5] !== 16'b1011100001100010) begin err = 1; $display("FAILED: mem[5] wrong"); $stop; end
	 if (DUT.MEM.mem[6] !== 16'b1010101100000010) begin err = 1; $display("FAILED: mem[6] wrong"); $stop; end
    if (DUT.MEM.mem[7] !== 16'b1010001010001010) begin err = 1; $display("FAILED: mem[7] wrong"); $stop; end
    if (DUT.MEM.mem[8] !== 16'b1000000110000000) begin err = 1; $display("FAILED: mem[8] wrong"); $stop; end
    if (DUT.MEM.mem[9] !== 16'b0110000010100000) begin err = 1; $display("FAILED: mem[9] wrong"); $stop; end
    if (DUT.MEM.mem[10] !== 16'b1000000110100000) begin err = 1; $display("FAILED: mem[10] wrong"); $stop; end
    if (DUT.MEM.mem[11] !== 16'b1010010001100010) begin err = 1; $display("FAILED: mem[11] wrong"); $stop; end
	 if (DUT.MEM.mem[12] !== 16'b1000000101100000) begin err = 1; $display("FAILED: mem[12] wrong"); $stop; end
    if (DUT.MEM.mem[13] !== 16'b0110000010000000) begin err = 1; $display("FAILED: mem[13] wrong"); $stop; end
    if (DUT.MEM.mem[14] !== 16'b1010110000000011) begin err = 1; $display("FAILED: mem[14] wrong"); $stop; end
    if (DUT.MEM.mem[15] !== 16'b1010010001010011) begin err = 1; $display("FAILED: mem[15] wrong"); $stop; end
    if (DUT.MEM.mem[16] !== 16'b1000000101000000) begin err = 1; $display("FAILED: mem[16] wrong"); $stop; end
    if (DUT.MEM.mem[17] !== 16'b1100000011010101) begin err = 1; $display("FAILED: mem[17] wrong"); $stop; end
	 if (DUT.MEM.mem[18] !== 16'b1000000111000000) begin err = 1; $display("FAILED: mem[18] wrong"); $stop; end
    if (DUT.MEM.mem[19] !== 16'b1110000000000000) begin err = 1; $display("FAILED: mem[19] wrong"); $stop; end
    if (DUT.MEM.mem[20] !== 16'b0000000101000000) begin err = 1; $display("FAILED: mem[20] wrong"); $stop; end
    if (DUT.MEM.mem[21] !== 16'b0000000100000000) begin err = 1; $display("FAILED: mem[21] wrong"); $stop; end
   
    @(negedge KEY[0]); // wait until next falling edge of clock

    KEY[1] = 1'b1; // reset de-asserted, PC still undefined if as in Figure 4

    #10; // waiting for RST state to cause reset of PC
	 
	 SW = 10'd76; //initialzing slider input

    
    if (DUT.CPU.PC !== 9'b0) begin err = 1; $display("FAILED: PC is not reset to zero."); $stop; end

    @(posedge DUT.CPU.PC or negedge DUT.CPU.PC);  // wait here until PC changes
    if (DUT.CPU.PC !== 9'h1) begin err = 1; $display("FAILED: PC should be 0x01."); $stop; end

    @(posedge DUT.CPU.PC or negedge DUT.CPU.PC);  // wait here until PC changes

    if (DUT.CPU.PC !== 9'h2) begin err = 1; $display("FAILED: PC should be 0x02."); $stop; end
    if (DUT.CPU.DP.REGFILE.R0 !== 16'h14) begin err = 1; $display("FAILED: R0 should be 0x0014."); $stop; end  

    @(posedge DUT.CPU.PC or negedge DUT.CPU.PC);  // wait here until PC changes

    if (DUT.CPU.PC !== 9'h3) begin err = 1; $display("FAILED: PC should be 0x03."); $stop; end
    if (DUT.CPU.DP.REGFILE.R1 !== 16'h15) begin err = 1; $display("FAILED: R1 should be 0x0017."); $stop; end

    @(posedge DUT.CPU.PC or negedge DUT.CPU.PC);  // wait here until PC changes

    if (DUT.CPU.PC !== 9'h4) begin err = 1; $display("FAILED: PC should be 0x04."); $stop; end
    if (DUT.CPU.DP.REGFILE.R0 !== 16'h0140) begin err = 1; $display("FAILED: R0 should be 0x0140."); $stop; end

    @(posedge DUT.CPU.PC or negedge DUT.CPU.PC);  // wait here until PC changes
   
    if (DUT.CPU.PC !== 9'h5) begin err = 1; $display("FAILED: PC should be 0x05."); $stop; end
    if (DUT.CPU.DP.REGFILE.R1 !== 16'h0100) begin err = 1; $display("FAILED: R1 should be 0x0100."); $stop; end
	 
	 @(posedge DUT.CPU.PC or negedge DUT.CPU.PC);  // wait here until PC changes
    if (DUT.CPU.PC !== 9'h6) begin err = 1; $display("FAILED: PC should be 0x06."); $stop; end
	 if (DUT.CPU.DP.REGFILE.R2 !== 16'd19) begin err = 1; $display("FAILED: R2 should be 19."); $stop; end

    @(posedge DUT.CPU.PC or negedge DUT.CPU.PC);  // wait here until PC changes

    if (DUT.CPU.PC !== 9'h7) begin err = 1; $display("FAILED: PC should be 0x07."); $stop; end
    if (DUT.CPU.DP.REGFILE.R3 !== 16'hFFEC) begin err = 1; $display("FAILED: R3 should be 0xFFEC"); $stop; end

	 @(posedge DUT.CPU.PC or negedge DUT.CPU.PC);  // wait here until PC changes

    if (DUT.CPU.PC !== 9'h8) begin err = 1; $display("FAILED: PC should be 0x08."); $stop; end
    if (DUT.CPU.DP.status_out !== 3'b100) begin err = 1; $display("FAILED: CMP operation should flag N."); $stop; end

    @(posedge DUT.CPU.PC or negedge DUT.CPU.PC);  // wait here until PC changes

    if (DUT.CPU.PC !== 9'h9) begin err = 1; $display("FAILED: PC should be 0x09."); $stop; end
    if (DUT.CPU.DP.REGFILE.R4 !== 16'd57) begin err = 1; $display("FAILED: R4 should be 57."); $stop; end

    @(posedge DUT.CPU.PC or negedge DUT.CPU.PC);  // wait here until PC changes

    if (DUT.CPU.PC !== 9'h0A) begin err = 1; $display("FAILED: PC should be 0x0A."); $stop; end
    if (DUT.LEDR !== 10'd57) begin err = 1; $display("FAILED: STR instruction does not work."); $stop; end

	 @(posedge DUT.CPU.PC or negedge DUT.CPU.PC);  // wait here until PC changes
    if (DUT.CPU.PC !== 9'h0B) begin err = 1; $display("FAILED: PC should be 0x0B."); $stop; end
	 if (DUT.CPU.DP.REGFILE.R5 !== 16'd76) begin err = 1; $display("FAILED: R5 should be 76"); $stop; end

    @(posedge DUT.CPU.PC or negedge DUT.CPU.PC);  // wait here until PC changes

    if (DUT.CPU.PC !== 9'h0C) begin err = 1; $display("FAILED: PC should be 0x0C."); $stop; end
    if (DUT.LEDR !== 10'd76) begin err = 1; $display("FAILED: STR instruction does not work."); $stop; end

    @(posedge DUT.CPU.PC or negedge DUT.CPU.PC);  // wait here until PC changes

    if (DUT.CPU.PC !== 9'h0D) begin err = 1; $display("FAILED: PC should be 0x0D."); $stop; end
    if (DUT.CPU.DP.REGFILE.R3 !== 16'd76) begin err = 1; $display("FAILED: R3 should be 76."); $stop; end

    @(posedge DUT.CPU.PC or negedge DUT.CPU.PC);  // wait here until PC changes

    if (DUT.CPU.PC !== 9'h0E) begin err = 1; $display("FAILED: PC should be 0x0E."); $stop; end
    if (DUT.LEDR !== 10'd76) begin err = 1; $display("FAILED: STR instruction does not work."); $stop; end

    @(posedge DUT.CPU.PC or negedge DUT.CPU.PC);  // wait here until PC changes
   
    if (DUT.CPU.PC !== 9'h0F) begin err = 1; $display("FAILED: PC should be 0x0F."); $stop; end
    if (DUT.CPU.DP.REGFILE.R4 !== 16'd76) begin err = 1; $display("FAILED: R4 should be 76."); $stop; end

	 @(posedge DUT.CPU.PC or negedge DUT.CPU.PC);  // wait here until PC changes
	  if (DUT.CPU.PC !== 9'h10) begin err = 1; $display("FAILED: PC should be 0x10."); $stop; end
    if (DUT.CPU.DP.status_out !== 3'b001) begin err = 1; $display("FAILED: CMP operation should flag Z."); $stop; end

    @(posedge DUT.CPU.PC or negedge DUT.CPU.PC);  // wait here until PC changes

    if (DUT.CPU.PC !== 9'h11) begin err = 1; $display("FAILED: PC should be 0x11."); $stop; end
    if (DUT.CPU.DP.REGFILE.R2 !== 16'd114) begin err = 1; $display("FAILED: R2 should be 114."); $stop; end  

    @(posedge DUT.CPU.PC or negedge DUT.CPU.PC);  // wait here until PC changes

    if (DUT.CPU.PC !== 9'h12) begin err = 1; $display("FAILED: PC should be 0x12."); $stop; end
    if (DUT.LEDR !== 10'd114) begin err = 1; $display("FAILED: STR instruction does not work."); $stop; end

    @(posedge DUT.CPU.PC or negedge DUT.CPU.PC);  // wait here until PC changes

    if (DUT.CPU.PC !== 9'h13) begin err = 1; $display("FAILED: PC should be 0x13."); $stop; end
    if (DUT.CPU.DP.REGFILE.R6 !== 16'd38) begin err = 1; $display("FAILED: R6 should be 38."); $stop; end

    @(posedge DUT.CPU.PC or negedge DUT.CPU.PC);  // wait here until PC changes
   
    if (DUT.CPU.PC !== 9'h14) begin err = 1; $display("FAILED: PC should be 0x14."); $stop; end
    if (DUT.LEDR !== 10'd38) begin err = 1; $display("FAILED: STR instruction does not work."); $stop; end
	 

    // NOTE: if HALT is working, PC won't change again...

    if (~err) $display("PASSED: Overall Design works as expected");
    $stop;
  end
endmodule
