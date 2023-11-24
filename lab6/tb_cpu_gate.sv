`timescale 1ps/1ps

module tb_cpu_gate;

  //cpu ports
  reg clk, reset, s, load;
  reg [15:0] in;
  wire [15:0] out;
  wire N,V,Z,w;

  reg err; //error register

  cpu DUT(clk,reset,s,load,in,out,N,V,Z,w);
  
  //clock initialization
  initial begin
    clk = 0; #5;
    forever begin
      clk = 1; #5;
      clk = 0; #5;
    end
  end

  //Test cases for 14 different ARM instructions
  initial begin
    err = 0;
    reset = 1; s = 0; load = 0; in = 16'b0;
    #10;
    reset = 0; 
    #10;

	 //MOV R0, #4
    in = {3'b110, 2'b10, 3'd0, 8'h4}; //{opcode, op, rn, im8}
    load = 1;
    #10;
    load = 0;
    s = 1;
    #10
    s = 0;
    @(posedge w); // wait for w to go high again
    #10;
    if (tb_cpu_gate.DUT.DP.REGFILE.R0 !== 16'h4) begin
      err = 1;
      $display("FAILED: MOV R0, #4");
      $stop;
    end
	 else begin
		err = 0;
		$display("PASSED: MOV R0, #4");
	 end
		

    @(negedge clk); // wait for falling edge of clock before changing inputs
	 
	 //MOV R1, #24
	 in = {3'b110, 2'b10, 3'd1, 8'h24}; //{opcode, op, rn, im8}
    load = 1;
    #10;
    load = 0;
    s = 1;
    #10
    s = 0;
    @(posedge w); // wait for w to go high again
    #10;
    if (tb_cpu_gate.DUT.DP.REGFILE.R1 !== 16'h24) begin
      err = 1;
      $display("FAILED: MOV R1, #24");
      $stop;
    end
	 else begin
		err = 0;
		$display("PASSED: MOV R1, #24");
	 end
		

    @(negedge clk); // wait for falling edge of clock before changing inputs
	 
	 //MOV R2, #33
	 in = {3'b110, 2'b10, 3'd2, 8'h33}; //{opcode, op, rn, im8}
    load = 1;
    #10;
    load = 0;
    s = 1;
    #10
    s = 0;
    @(posedge w); // wait for w to go high again
    #10;
    if (tb_cpu_gate.DUT.DP.REGFILE.R2 !== 16'h33) begin
      err = 1;
      $display("FAILED: MOV R2, #33");
      $stop;
    end
	 else begin
		err = 0;
		$display("PASSED: MOV R2, #33");
	 end
		
	 
	 @(negedge clk); // wait for falling edge of clock before changing inputs
	 
	 //MOV R3, #2
	 in = {3'b110, 2'b10, 3'd3, 8'h2}; //{opcode, op, rn, im8}
    load = 1;
    #10;
    load = 0;
    s = 1;
    #10
    s = 0;
    @(posedge w); // wait for w to go high again
    #10;
    if (tb_cpu_gate.DUT.DP.REGFILE.R3 !== 16'h2) begin
      err = 1;
      $display("FAILED: MOV R3, #2");
      $stop;
    end
	 else begin
		err = 0;
		$display("PASSED: MOV R3, #2");
	 end
		
	 
	 @(negedge clk); // wait for falling edge of clock before changing inputs
	 
	 //MOV R4, #42
	 in = {3'b110, 2'b10, 3'd4, 8'h42}; //{opcode, op, rn, im8}
    load = 1;
    #10;
    load = 0;
    s = 1;
    #10
    s = 0;
    @(posedge w); // wait for w to go high again
    #10;
    if (tb_cpu_gate.DUT.DP.REGFILE.R4 !== 16'h42) begin
      err = 1;
      $display("FAILED: MOV R4, #42");
      $stop;
    end
	 else begin
		err = 0;
		$display("PASSED: MOV R4, #42");
	 end
		
	 
	 
	 @(negedge clk); // wait for falling edge of clock before changing inputs
	 
	 //MVN R5, R2, ASR #1
	 in = {3'b101, 2'b11, 3'd0, 3'd5, 2'b11, 3'd2}; //{opcode, op, rn, rd, sh, rm}
    load = 1;
    #10;
    load = 0;
    s = 1;
    #10
    s = 0;
    @(posedge w); // wait for w to go high again
    #10;
    if (tb_cpu_gate.DUT.DP.REGFILE.R5 !== 16'hFFE6) begin
      err = 1;
      $display("FAILED: MVN R5, R2, ASR #1");
      $stop;
    end
	 else begin
		err = 0;
		$display("PASSED: MVN R5, R2, ASR #1");
	 end
		
	 
	 @(negedge clk); // wait for falling edge of clock before changing inputs
	 
	 //MOV R6, #6
	 in = {3'b110, 2'b10, 3'd6, 8'h6}; //{opcode, op, rn, im8}
    load = 1;
    #10;
    load = 0;
    s = 1;
    #10
    s = 0;
    @(posedge w); // wait for w to go high again
    #10;
    if (tb_cpu_gate.DUT.DP.REGFILE.R6 !== 16'h6) begin
      err = 1;
      $display("FAILED: MOV R6, #6");
      $stop;
    end
	 else begin
		err = 0;
		$display("PASSED: MOV R6, #6");
	 end
		
	 
	 @(negedge clk); // wait for falling edge of clock before changing inputs
	 
	 //MOV R7, #0
	 in = {3'b110, 2'b10, 3'd7, 8'h0}; //{opcode, op, rn, im8}
    load = 1;
    #10;
    load = 0;
    s = 1;
    #10
    s = 0;
    @(posedge w); // wait for w to go high again
    #10;
    if (tb_cpu_gate.DUT.DP.REGFILE.R7 !== 16'h0) begin
      err = 1;
      $display("FAILED: MOV R7, #0");
      $stop;
    end
	 else begin
		err = 0;
		$display("PASSED: MOV R7, #0");
	 end
	 
	 @(negedge clk); // wait for falling edge of clock before changing inputs
	 
	 //ADD R0, R2, R3, LSL#1
	 in = {3'b101, 2'b00, 3'd2, 3'd0, 2'b01, 3'd3}; //{opcode, op, rn, rd, sh, rm}
    load = 1;
    #10;
    load = 0;
    s = 1;
    #10
    s = 0;
    @(posedge w); // wait for w to go high again
    #10;
    if (tb_cpu_gate.DUT.DP.REGFILE.R0 !== 16'h37) begin
      err = 1;
      $display("FAILED: ADD R0, R2, R3, LSL#1");
      $stop;
    end
	 else begin
		err = 0;
		$display("PASSED: ADD R0, R2, R3, LSL#1");
	 end
	 
	 @(negedge clk); // wait for falling edge of clock before changing inputs
	 
	 //AND R3, R2, R1
	 in = {3'b101, 2'b10, 3'd2, 3'd3, 2'b00, 3'd1}; //{opcode, op, rn, rd, sh, rm}
    load = 1;
    #10;
    load = 0;
    s = 1;
    #10
    s = 0;
    @(posedge w); // wait for w to go high again
    #10;
    if (tb_cpu_gate.DUT.DP.REGFILE.R3 !== 16'h20) begin
      err = 1;
      $display("FAILED: AND R3, R2, R1");
      $stop;
    end
	 else begin
		err = 0;
		$display("PASSED: AND R3, R2, R1");
	 end
	 
	 @(negedge clk); // wait for falling edge of clock before changing inputs
	 
	 //CMP R7, R3, LSR#1
	 in = {3'b101, 2'b01, 3'd7, 3'd0, 2'b10, 3'd3}; //{opcode, op, rn, rd, sh, rm}
    load = 1;
    #10;
    load = 0;
    s = 1;
    #10
    s = 0;
    @(posedge w); // wait for w to go high again
    #10;
    if ({N,V,Z} != 3'b100) begin
      err = 1;
      $display("FAILED: CMP R7, R3, LSR#1");
      $stop;
    end
	 else begin
		err = 0;
		$display("PASSED: CMP R7, R3, LSR#1");
	 end
	 
	 @(negedge clk); // wait for falling edge of clock before changing inputs
	 
	 //MVN R3, R0
	 in = {3'b101, 2'b11, 3'd0, 3'd3, 2'b00, 3'd0}; //{opcode, op, rn, rd, sh, rm}
    load = 1;
    #10;
    load = 0;
    s = 1;
    #10
    s = 0;
    @(posedge w); // wait for w to go high again
    #10;
    if (tb_cpu_gate.DUT.DP.REGFILE.R3 !== 16'hFFC8) begin
      err = 1;
      $display("FAILED: MVN R3, R0");
      $stop;
    end
	 else begin
		err = 0;
		$display("PASSED: MVN R3, R0");
	 end
	 
	 @(negedge clk); // wait for falling edge of clock before changing inputs
	 
	 //MVN R6, R3
	 in = {3'b101, 2'b11, 3'd0, 3'd6, 2'b00, 3'd3}; //{opcode, op, rn, rd, sh, rm}
    load = 1;
    #10;
    load = 0;
    s = 1;
    #10
    s = 0;
    @(posedge w); // wait for w to go high again
    #10;
    if (tb_cpu_gate.DUT.DP.REGFILE.R6 !== 16'h37) begin
      err = 1;
      $display("FAILED: MVN R6, R3");
      $stop;
    end
	 else begin
		err = 0;
		$display("PASSED: MVN R6, R3");
	 end
	 
	 @(negedge clk); // wait for falling edge of clock before changing inputs
	 
	 //CMP R6, R0
	 in = {3'b101, 2'b01, 3'd6, 3'd0, 2'b00, 3'd0}; //{opcode, op, rn, rd, sh, rm}
    load = 1;
    #10;
    load = 0;
    s = 1;
    #10
    s = 0;
    @(posedge w); // wait for w to go high again
    #10;
    if ({N,V,Z} != 3'b001) begin
      err = 1;
      $display("FAILED: CMP R6, R0");
      $stop;
    end
	 else begin
		err = 0;
		$display("PASSED: CMP R6, R0");
	 end
	 
	 @(negedge clk); // wait for falling edge of clock before changing inputs
	 
	 //MOV R4, #7F
	 in = {3'b110, 2'b10, 3'd4, 8'h7F}; //{opcode, op, rn, im8}
    load = 1;
    #10;
    load = 0;
    s = 1;
    #10
    s = 0;
    @(posedge w); // wait for w to go high again
    #10;
    if (tb_cpu_gate.DUT.DP.REGFILE.R4 !== 16'h7F) begin
      err = 1;
      $display("FAILED: MOV R4, #7F");
      $stop;
    end
	 else begin
		err = 0;
		$display("PASSED: MOV R4, #7F");
	 end
	 
	  @(negedge clk); // wait for falling edge of clock before changing inputs
	 
	 //MOV R5, #1
	 in = {3'b110, 2'b10, 3'd5, 8'h1}; //{opcode, op, rn, im8}
    load = 1;
    #10;
    load = 0;
    s = 1;
    #10
    s = 0;
    @(posedge w); // wait for w to go high again
    #10;
    if (tb_cpu_gate.DUT.DP.REGFILE.R5 !== 16'h1) begin
      err = 1;
      $display("FAILED: MOV R5, #1");
      $stop;
    end
	 else begin
		err = 0;
		$display("PASSED: MOV R5, #1");
	 end
	 
	 @(negedge clk); // wait for falling edge of clock before changing inputs
	 
	 //MVN R6, R5
	 in = {3'b101, 2'b11, 3'd0, 3'd6, 2'b00, 3'd5}; //{opcode, op, rn, rd, sh, rm}
    load = 1;
    #10;
    load = 0;
    s = 1;
    #10
    s = 0;
    @(posedge w); // wait for w to go high again
    #10;
    if (tb_cpu_gate.DUT.DP.REGFILE.R6 !== 16'hFFFE) begin
      err = 1;
      $display("FAILED: MVN R6, R5");
      $stop;
    end
	 else begin
		err = 0;
		$display("PASSED: MVN R6, R5");
	 end
	 
	 
	 @(negedge clk); // wait for falling edge of clock before changing inputs
	 
	 //ADD R6, R6, R5
	 in = {3'b101, 2'b00, 3'd6, 3'd6, 2'b00, 3'd5}; //{opcode, op, rn, rd, sh, rm}
    load = 1;
    #10;
    load = 0;
    s = 1;
    #10
    s = 0;
    @(posedge w); // wait for w to go high again
    #10;
    if (tb_cpu_gate.DUT.DP.REGFILE.R6 !== 16'hFFFF) begin
      err = 1;
      $display("FAILED: ADD R6, R6, R5");
      $stop;
    end
	 else begin
		err = 0;
		$display("PASSED: ADD R6, R6, R5");
	 end
	 
	 @(negedge clk); // wait for falling edge of clock before changing inputs
	 
	 //CMP R6, R4
	 in = {3'b101, 2'b01, 3'd6, 3'd0, 2'b00, 3'd4}; //{opcode, op, rn, rd, sh, rm}
    load = 1;
    #10;
    load = 0;
    s = 1;
    #10
    s = 0;
    @(posedge w); // wait for w to go high again
    #10;
    if ({N,V,Z} != 3'b100) begin
      err = 1;
      $display("FAILED: CMP R6, R4");
      $stop;
    end
	 else begin
		err = 0;
		$display("PASSED: CMP R6, R4");
	 end
		
	 
    if (~err) $display("PASSED: CPU WORKS AS EXPECTED");
    $stop;
  end
endmodule

