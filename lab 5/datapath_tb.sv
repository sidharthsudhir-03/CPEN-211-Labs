module datapath_tb;
  // checks datapath for compatibility with autograder

  reg clk;
  reg [15:0] datapath_in;
  reg write, vsel, loada, loadb, asel, bsel, loadc, loads;
  reg [2:0] readnum, writenum;
  reg [1:0] shift, ALUop;

  wire [15:0] datapath_out;
  wire Z_out;

  reg err;

  datapath DUT ( .clk         (clk),

                // register operand fetch stage
                .readnum     (readnum),
                .vsel        (vsel),
                .loada       (loada),
                .loadb       (loadb),

                // computation stage (sometimes called "execute")
                .shift       (shift),
                .asel        (asel),
                .bsel        (bsel),
                .ALUop       (ALUop),
                .loadc       (loadc),
                .loads       (loads),

                // set when "writing back" to register file
                .writenum    (writenum),
                .write       (write),  
                .datapath_in (datapath_in),

                // outputs
                .Z_out       (Z_out),
                .datapath_out(datapath_out)
             );

  // autograder needs to be able to access the contents of your register file
  // using the following statements (wire used as follows acts like assign)
  wire [15:0] R0 = DUT.REGFILE.R0;
  wire [15:0] R1 = DUT.REGFILE.R1;
  wire [15:0] R2 = DUT.REGFILE.R2;
  wire [15:0] R3 = DUT.REGFILE.R3;
  wire [15:0] R4 = DUT.REGFILE.R4;
  wire [15:0] R5 = DUT.REGFILE.R5;
  wire [15:0] R6 = DUT.REGFILE.R6;
  wire [15:0] R7 = DUT.REGFILE.R7;

  
  // The first initial block below generates the clock signal. The clock (clk)
  // starts with value 0, changes to 1 after 5 time units and changes again 0
  // after 10 time units.  This repeats "forever".  Rising edges of clk are at
  // time = 5, 15, 25, 35, ...  
  initial forever begin
    clk = 0; #5;
    clk = 1; #5;
  end

  // The rest of the inputs to our design under test (datapath) are defined 
  // below.
  initial begin
    // Plot err in your waveform to find out when first error occurs
    err = 0;
    
	 
    datapath_in = 0;
    write = 0; vsel=0; loada=0; loadb=0; asel=0; bsel=0; loadc=0; loads=0;
    readnum = 0; writenum=0;
    shift = 0; ALUop=0;

    // Now, wait for clk -- clock rises at time = 5, 15, 25, 35, ...  Thus, at 
    // time = 10 the clock is NOT rising so it is safe to change the inputs.
    #10; 

    //We start by executing the MOV instruction to all the registers, our first few instructions are:
	 //MOV R0, #25
	 //MOV R1, #47
	 //MOV R2, #55
	 //MOV R3, #42
	 //MOV R4, #10
	 //MOV R5, #23
	 //MOV R6, #59
	 //MOV R7, #74

    // MOV R0, #25
    datapath_in = 16'h25; 
    writenum = 3'd0;
    write = 1'b1;
    vsel = 1'b1;
    #10; // wait for clock 

    // the following checks if MOV was executed correctly
    if (R0 !== 16'h25) begin
      err = 1; 
      $display("FAILED: MOV R0, #25 wrong -- Regs[R0]=%h is wrong, expected %h", R0, 16'h25); 
    end


    // MOV R1, #47
    datapath_in = 16'h47;
    writenum = 3'd1;
    write = 1'b1;
    vsel = 1'b1;
    #10; // wait for clock 

    // the following checks if MOV was executed correctly
    if (R1 !== 16'h47) begin 
      err = 1; 
      $display("FAILED: MOV R1, #47 wrong -- Regs[R2]=%h is wrong, expected %h", R1, 16'h47); 
    end
	 
	 // MOV R2, #55
    datapath_in = 16'h55; 
    writenum = 3'd2;
    write = 1'b1;
    vsel = 1'b1;
    #10; // wait for clock 

    // the following checks if MOV was executed correctly
    if (R2 !== 16'h55) begin
      err = 1; 
      $display("FAILED: MOV R2, #55 wrong -- Regs[R2]=%h is wrong, expected %h", R2, 16'h25); 
    end
	 
	 // MOV R3, #42
    datapath_in = 16'h42; 
    writenum = 3'd3;
    write = 1'b1;
    vsel = 1'b1;
    #10; // wait for clock 

    // the following checks if MOV was executed correctly
    if (R3 !== 16'h42) begin
      err = 1; 
      $display("FAILED: MOV R3, #42 wrong -- Regs[R3]=%h is wrong, expected %h", R3, 16'h42); 
    end
	 
	 // MOV R4, #10
    datapath_in = 16'h10; 
    writenum = 3'd4;
    write = 1'b1;
    vsel = 1'b1;
    #10; // wait for clock 

    // the following checks if MOV was executed correctly
    if (R4 !== 16'h10) begin
      err = 1; 
      $display("FAILED: MOV R4, #10 wrong -- Regs[R4]=%h is wrong, expected %h", R4, 16'h10); 
    end
	 
	 // MOV R5, #23
    datapath_in = 16'h23; // h for hexadecimal
    writenum = 3'd5;
    write = 1'b1;
    vsel = 1'b1;
    #10; // wait for clock 

    // the following checks if MOV was executed correctly
    if (R5 !== 16'h23) begin
      err = 1; 
      $display("FAILED: MOV R5, #23 wrong -- Regs[R5]=%h is wrong, expected %h", R5, 16'h23); 
    end
	 
	 // MOV R6, #59
    datapath_in = 16'h59; // h for hexadecimal
    writenum = 3'd6;
    write = 1'b1;
    vsel = 1'b1;
    #10; // wait for clock 

    // the following checks if MOV was executed correctly
    if (R6 !== 16'h59) begin
      err = 1; 
      $display("FAILED: MOV R6, #59 wrong -- Regs[R6]=%h is wrong, expected %h", R6, 16'h59); 
    end
	 
	 // MOV R7, #74
    datapath_in = 16'h74; // h for hexadecimal
    writenum = 3'd7;
    write = 1'b1;
    vsel = 1'b1;
    #10; // wait for clock 

    // the following checks if MOV was executed correctly
    if (R7 !== 16'h74) begin
      err = 1; 
      $display("FAILED: MOV R7, #74 wrong -- Regs[R7]=%h is wrong, expected %h", R7, 16'h74); 
    end
	 
	 write = 1'b0;
	 

    ////////////////////////////////////////////////////////////

    // ADD R2,R5,R3
    // step 1 - load contents of R3 into B reg
    readnum = 3'd3; 
    loadb = 1'b1;
    #10; // wait for clock
    loadb = 1'b0; // done loading B, set loadb to zero so don't overwrite A 

    // step 2 - load contents of R5 into A reg 
    readnum = 3'd5; 
    loada = 1'b1;
    #10; // wait for clock
    loada = 1'b0;

    // step 3 - perform addition of contents of A and B registers, load into C
    shift = 2'b00;
    asel = 1'b0;
    bsel = 1'b0;
    ALUop = 2'b00;
    loadc = 1'b1;
    loads = 1'b1;
    #10; // wait for clock
    loadc = 1'b0;
    loads = 1'b0;

    // step 4 - store contents of C into R2
    write = 1'b1;
    writenum = 3'd2;
    vsel = 1'b0;
    #10;
    write = 0;

    if (R2 !== 16'h65) begin 
      err = 1; 
      $display("FAILED: ADD R2, R5, R3 -- Regs[R2]=%h is wrong, expected %h", R2, 16'h65); 
      $stop; 
    end

    if (datapath_out !== 16'h65) begin 
      err = 1; 
      $display("FAILED: ADD R2, R5, R3 -- datapath_out=%h is wrong, expected %h", R2, 16'h65); 
      $stop; 
    end

    if (Z_out !== 1'b0) begin
      err = 1; 
      $display("FAILED: ADD R2, R5, R3 -- Z_out=%b is wrong, expected %b", Z_out, 1'b0); 
      $stop; 
    end
	 
	 
	 ////////////////////////////////////////////////////////////

    // SUB R1, R3, R0
    // step 1 - load contents of R0 into B reg
    readnum = 3'd0; 
    loadb = 1'b1;
    #10; // wait for clock
    loadb = 1'b0; // done loading B, set loadb to zero so don't overwrite A 

    // step 2 - load contents of R3 into A reg 
    readnum = 3'd3; 
    loada = 1'b1;
    #10; // wait for clock
    loada = 1'b0;

    // step 3 - perform subraction of contents of A and B registers, load into C
    shift = 2'b00;
    asel = 1'b0;
    bsel = 1'b0;
    ALUop = 2'b01;
    loadc = 1'b1;
    loads = 1'b1;
    #10; // wait for clock
    loadc = 1'b0;
    loads = 1'b0;

    // step 4 - store contents of C into R1
    write = 1'b1;
    writenum = 3'd1;
    vsel = 1'b0;
    #10;
    write = 0;

    if (R1 !== 16'h1D) begin 
      err = 1; 
      $display("FAILED: SUB R1, R3, R0 -- Regs[R1]=%h is wrong, expected %h", R1, 16'h1D); 
       
    end

    if (datapath_out !== 16'h1D) begin 
      err = 1; 
      $display("FAILED: SUB R1, R3, R0 -- datapath_out=%h is wrong, expected %h", R1, 16'h1D); 
       
    end

    if (Z_out !== 1'b0) begin
      err = 1; 
      $display("FAILED: SUB R1, R3, R0 -- Z_out=%b is wrong, expected %b", Z_out, 1'b0); 
       
    end
	 
	////////////////////////////////////////////////////////////

    // AND R4, R7, R5, LSL#1
    // step 1 - load contents of R5 into B reg
    readnum = 3'd5; 
    loadb = 1'b1;
    #10; // wait for clock
    loadb = 1'b0; // done loading B, set loadb to zero so don't overwrite A 

    // step 2 - load contents of R7 into A reg 
    readnum = 3'd7; 
    loada = 1'b1;
    #10; // wait for clock
    loada = 1'b0;

    // step 3 - perform logical and of contents of A and B registers, load into C
    shift = 2'b01;
    asel = 1'b0;
    bsel = 1'b0;
    ALUop = 2'b10;
    loadc = 1'b1;
    loads = 1'b1;
    #10; // wait for clock
    loadc = 1'b0;
    loads = 1'b0;

    // step 4 - store contents of C into R4
    write = 1'b1;
    writenum = 3'd4;
    vsel = 1'b0;
    #10;
    write = 0;

    if (R4 !== 16'h44) begin 
      err = 1; 
      $display("FAILED: AND R4, R7, R5, LSL#1 -- Regs[R4]=%h is wrong, expected %h", R4, 16'h44); 
       
    end

    if (datapath_out !== 16'h44) begin 
      err = 1; 
      $display("FAILED: AND R4, R7, R5, LSL#1 -- datapath_out=%h is wrong, expected %h", R4, 16'h44); 
       
    end

    if (Z_out !== 1'b0) begin
      err = 1; 
      $display("FAILED: AND R4, R7, R5, LSL#1 -- Z_out=%b is wrong, expected %b", Z_out, 1'b0); 
      
    end
	 
	////////////////////////////////////////////////////////////

    // MVN R3, R1
    // step 1 - load contents of R1 into B reg
    readnum = 3'd1; 
    loadb = 1'b1;
    #10; // wait for clock
    loadb = 1'b0; // done loading B, set loadb to zero so don't overwrite A 


    // step 2 - perform logical not of contents of B register, load into C
    shift = 2'b00;
    asel = 1'b1;
    bsel = 1'b0;
    ALUop = 2'b11;
    loadc = 1'b1;
    loads = 1'b1;
    #10; // wait for clock
    loadc = 1'b0;
    loads = 1'b0;

    // step 4 - store contents of C into R3
    write = 1'b1;
    writenum = 3'd3;
    vsel = 1'b0;
    #10;
    write = 0;

    if (R3 !== 16'hFFE2) begin 
      err = 1; 
      $display("FAILED: MVN R3, R1 -- Regs[R3]=%h is wrong, expected %h", R3, 16'hFFE2); 
       
    end

    if (datapath_out !== 16'hFFE2) begin 
      err = 1; 
      $display("FAILED: MVN R3, R1-- datapath_out=%h is wrong, expected %h", R3, 16'hFFE2); 
       
    end

    if (Z_out !== 1'b0) begin
      err = 1; 
      $display("FAILED: MVN R3, R1 -- Z_out=%b is wrong, expected %b", Z_out, 1'b0); 
      
    end
	 

   ////////////////////////////////////////////////////////////

    // ADD R2, R3, R1
    // step 1 - load contents of R1 into B reg
    readnum = 3'd1; 
    loadb = 1'b1;
    #10; // wait for clock
    loadb = 1'b0; // done loading B, set loadb to zero so don't overwrite A 

    // step 2 - load contents of R3 into A reg 
    readnum = 3'd3; 
    loada = 1'b1;
    #10; // wait for clock
    loada = 1'b0;

    // step 3 - perform addition of contents of A and B registers, load into C
    shift = 2'b00;
    asel = 1'b0;
    bsel = 1'b0;
    ALUop = 2'b00;
    loadc = 1'b1;
    loads = 1'b1;
    #10; // wait for clock
    loadc = 1'b0;
    loads = 1'b0;

    // step 4 - store contents of C into R2
    write = 1'b1;
    writenum = 3'd2;
    vsel = 1'b0;
    #10;
    write = 0;

    if (R2 !== 16'hFFFF) begin 
      err = 1; 
      $display("FAILED: ADD R2, R3, R1 -- Regs[R2]=%h is wrong, expected %h", R2, 16'hFFFF); 
       
    end

    if (datapath_out !== 16'hFFFF) begin 
      err = 1; 
      $display("FAILED: ADD R2, R3, R1 -- datapath_out=%h is wrong, expected %h", R2, 16'hFFFF); 
       
    end

    if (Z_out !== 1'b0) begin
      err = 1; 
      $display("FAILED: ADD R2, R3, R1 -- Z_out=%b is wrong, expected %b", Z_out, 1'b0); 
       
    end
	 
	 ////////////////////////////////////////////////////////////

    ////////////////////////////////////////////////////////////

    // MVN R6, R2
    // step 1 - load contents of R2 into B reg
    readnum = 3'd2; 
    loadb = 1'b1;
    #10; // wait for clock
    loadb = 1'b0; // done loading B, set loadb to zero so don't overwrite A 


    // step 3 - perform logical not of contents of B register, load into C
    shift = 2'b00;
    asel = 1'b1;
    bsel = 1'b0;
    ALUop = 2'b11;
    loadc = 1'b1;
    loads = 1'b1;
    #10; // wait for clock
    loadc = 1'b0;
    loads = 1'b0;

    // step 4 - store contents of C into R6
    write = 1'b1;
    writenum = 3'd6;
    vsel = 1'b0;
    #10;
    write = 0;

    if (R6 !== 16'h0) begin 
      err = 1; 
      $display("FAILED: MVN R6, R2 -- Regs[R6]=%h is wrong, expected %h", R6, 16'h10); 
       
    end

    if (datapath_out !== 16'h0) begin 
      err = 1; 
      $display("FAILED: MVN R6, R2 -- datapath_out=%h is wrong, expected %h", R6, 16'h0); 
       
    end

    if (Z_out !== 1'b1) begin
      err = 1; 
      $display("FAILED: MVN R6, R2 -- Z_out=%b is wrong, expected %b", Z_out, 1'b1); 
       
    end
	 

    ////////////////////////////////////////////////////////////

    // ADD R5, R4, R1, LSR#1
    // step 1 - load contents of R1 into B reg
    readnum = 3'd1; 
    loadb = 1'b1;
    #10; // wait for clock
    loadb = 1'b0; // done loading B, set loadb to zero so don't overwrite A 

    // step 2 - load contents of R4 into A reg 
    readnum = 3'd4; 
    loada = 1'b1;
    #10; // wait for clock
    loada = 1'b0;

    // step 3 - perform addition of contents of A and B registers, load into C
    shift = 2'b10;
    asel = 1'b0;
    bsel = 1'b0;
    ALUop = 2'b00;
    loadc = 1'b1;
    loads = 1'b1;
    #10; // wait for clock
    loadc = 1'b0;
    loads = 1'b0;

    // step 4 - store contents of C into R5
    write = 1'b1;
    writenum = 3'd5;
    vsel = 1'b0;
    #10;
    write = 0;

    if (R5 !== 16'h52) begin 
      err = 1; 
      $display("FAILED:  ADD R5, R4, R1, LSR#1 -- Regs[R4]=%h is wrong, expected %h", R5, 16'h52); 
       
    end

    if (datapath_out !== 16'h52) begin 
      err = 1; 
      $display("FAILED:  ADD R5, R4, R1, LSR#1 -- datapath_out=%h is wrong, expected %h", R5, 16'h52); 
       
    end

    if (Z_out !== 1'b0) begin
      err = 1; 
      $display("FAILED:  ADD R5, R4, R1, LSR#1 -- Z_out=%b is wrong, expected %b", Z_out, 1'b0); 
      
    end
	 
	 ////////////////////////////////////////////////////////////

    // AND R1, R2, R3 (shift = 2'b11)
    // step 1 - load contents of R3 into B reg
    readnum = 3'd3; 
    loadb = 1'b1;
    #10; // wait for clock
    loadb = 1'b0; // done loading B, set loadb to zero so don't overwrite A 

    // step 2 - load contents of R2 into A reg 
    readnum = 3'd2; 
    loada = 1'b1;
    #10; // wait for clock
    loada = 1'b0;

    // step 3 - perform logical and of contents of A and B registers, load into C
    shift = 2'b11;
    asel = 1'b0;
    bsel = 1'b0;
    ALUop = 2'b10;
    loadc = 1'b1;
    loads = 1'b1;
    #10; // wait for clock
    loadc = 1'b0;
    loads = 1'b0;

    // step 4 - store contents of C into R1
    write = 1'b1;
    writenum = 3'd1;
    vsel = 1'b0;
    #10;
    write = 0;

    if (R1 !== 16'hFFF1) begin 
      err = 1; 
      $display("FAILED: AND R1, R2, R3 (shift = 2'b11) -- Regs[R4]=%h is wrong, expected %h", R1, 16'hFFF1); 
      
    end

    if (datapath_out !== 16'hFFF1) begin 
      err = 1; 
      $display("FAILED: AND R1, R2, R3 (shift = 2'b11) -- datapath_out=%h is wrong, expected %h", R1, 16'hFFF1); 
      
    end

    if (Z_out !== 1'b0) begin
      err = 1; 
      $display("FAILED: AND R1, R2, R3 (shift = 2'b11) -- Z_out=%b is wrong, expected %b", Z_out, 1'b0); 
      
    end

  end
  
  initial begin
		 #510;
		 if (err === 0) begin
			$display("PASSED: The datapath works as expected.");
			$stop;
		 end
	end
endmodule
