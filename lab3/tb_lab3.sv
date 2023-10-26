module tb_lab3();

	reg [3:0] KEY;
	reg [9:0] SW;
	reg err;
	wire [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	wire [9:0] LEDR;
	
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

	 lab3 dut(.SW(SW),
	 .KEY(KEY),
	 .HEX0(HEX0),
	 .HEX1(HEX1),
	 .HEX2(HEX2),
	 .HEX3(HEX3),
	 .HEX4(HEX4),
	 .HEX5(HEX5),
	 .LEDR(LEDR));
	
	task state_binout_checker;
		input [3:0] expected_state;
		input [9:0] expected_binout;
		
	begin
		if(dut.present_state !== expected_state) begin
       $display("ERROR ** state is %b, expected %b", dut.present_state, expected_state);
       err = 1'b1;
		end
		
		if(dut.bin_out !== expected_binout) begin
       $display("ERROR ** output is %b, expected %b", dut.bin_out, expected_binout);
       err = 1'b1;
		end
	end
	endtask
	
	
	task ssd_checker;
		case({HEX5, HEX4, HEX3, HEX2, HEX1, HEX0})
		
			{{35{1'b1}}, 7'b1000000} : $display("0");
			{{35{1'b1}}, 7'b1111001} : $display("1");
			{{35{1'b1}}, 7'b0100100} : $display("2");
			{{35{1'b1}}, 7'b0110000} : $display("3");
			{{35{1'b1}}, 7'b0011001} : $display("4");
			{{35{1'b1}}, 7'b0010010} : $display("5");
			{{35{1'b1}}, 7'b0000010} : $display("6");
			{{35{1'b1}}, 7'b1111000} : $display("7");
			{{35{1'b1}}, 7'b0000000} : $display("8");
			{{35{1'b1}}, 7'b0010000} : $display("9");
			{{14{1'b1}}, 7'b1000000, 7'b0001100, 7'b0000110, 7'b1001000} : $display("OPEn");
			{7'b1000110, 7'b1000111, 7'b1000000, 7'b0010010, 7'b0000110, 7'b1000000} : $display("CLOSED");
			{{7{1'b1}}, 7'b0000110, 7'b0101111, 7'b0101111, 7'b1000000, 7'b0101111} : $display("ErrOr");
			default: $display("xxxx");
		
		endcase	
	endtask


	initial begin 
		KEY[0] = 1'b1; #5;
		forever begin
			KEY[0] = 1'b0; #5;
			KEY[0] = 1'b1; #5;
		end
	end

initial begin 


	 $display("---Test 1---");
	 
	
	 $display("CHECKING RESET");
    KEY[3] = 1'b0; SW = 10'd0; err = 1'b0; #10; 
    state_binout_checker(`Sa, 10'd0);
	 ssd_checker;
    KEY[3] = 1'b1; 
     
    $display("CHECKING Sa->Sb");
    SW = 10'd7; #5; 
	 $display("before clk:"); 
	 ssd_checker; #5; 
    state_binout_checker(`Sb, 10'd7);
    $display("after clk:"); 
	 ssd_checker;

    $display("CHECKING Sb->Sc");
    SW = 10'd0; #5;
	 $display("before clk:"); 
	 ssd_checker; #5; 
    state_binout_checker(`Sc, 10'd0);
	 $display("after clk:"); 
    ssd_checker;

    $display("CHECKING Sc->Sd");
    SW = 10'd3; #5; 
	 $display("before clk:"); 
	 ssd_checker; #5;
    state_binout_checker(`Sd, 10'd3);
	 $display("after clk:"); 
    ssd_checker;

    $display("CHECKING Sd->Se");
    SW = 10'd2; #5; 
	 $display("before clk:"); 
	 ssd_checker; #5; 
    state_binout_checker(`Se, 10'd2);
	 $display("after clk:"); 
    ssd_checker;

    $display("CHECKING Se->Sf");
    SW = 10'd6; #5; 
	 $display("before clk:"); 
	 ssd_checker; #5; 
    state_binout_checker(`Sf, 10'd6);
	 $display("after clk:"); 
    ssd_checker;

    $display("CHECKING Sf->Sg");
	 SW = 10'd2;#5; 
	 $display("before clk:"); 
	 ssd_checker; #5;
    state_binout_checker(`Sg, 10'b1111111111);
	 $display("after clk:"); 
    ssd_checker;

    $display("CHECKING Sg->Op");
    #10; 
    state_binout_checker(`Op, 10'b1111111111);
    ssd_checker;
	 
	 $display("CHECKING Op->Op");
    #10; 
    state_binout_checker(`Op, 10'b1111111111);
    ssd_checker;
	 
	 
	 $display("---Test 2---");
	 
	
	 $display("CHECKING RESET");
    KEY[3] = 1'b0; SW = 10'd0; #10; 
    state_binout_checker(`Sa, 10'd0);
	 ssd_checker;
    KEY[3] = 1'b1; 
     
    $display("CHECKING Sa->Sb");
    SW = 10'd7; #5; 
	 $display("before clk:"); 
	 ssd_checker; #5; 
    state_binout_checker(`Sb, 10'd7);
    $display("after clk:"); 
	 ssd_checker;

    $display("CHECKING Sb->Sc");
    SW = 10'd0; #5;
	 $display("before clk:"); 
	 ssd_checker; #5; 
    state_binout_checker(`Sc, 10'd0);
	 $display("after clk:"); 
    ssd_checker;

    $display("CHECKING Sc->Sd");
    SW = 10'd3; #5; 
	 $display("before clk:"); 
	 ssd_checker; #5;
    state_binout_checker(`Sd, 10'd3);
	 $display("after clk:"); 
    ssd_checker;

    $display("CHECKING Sd->Se");
    SW = 10'd2; #5; 
	 $display("before clk:"); 
	 ssd_checker; #5; 
    state_binout_checker(`Se, 10'd2);
	 $display("after clk:"); 
    ssd_checker;

    $display("CHECKING Se->Sf");
    SW = 10'd6; #5; 
	 $display("before clk:"); 
	 ssd_checker; #5; 
    state_binout_checker(`Sf, 10'd6);
	 $display("after clk:"); 
    ssd_checker;

    $display("CHECKING Sf->Wf");
	 SW = 10'd3;#5; 
	 $display("before clk:"); 
	 ssd_checker; #5;
    state_binout_checker(`Wf, 10'b1111110000);
	 $display("after clk:"); 
    ssd_checker;

    $display("CHECKING Wf-> Cl");
    #10; 
    state_binout_checker(`Cl, 10'b1111110000);
    ssd_checker;
	 
	 $display("CHECKING Cl->Cl");
    #10; 
    state_binout_checker(`Cl, 10'b1111110000);
    ssd_checker;
	 
	 
	 $display("---Test 3---");
	 
	
	 $display("CHECKING RESET");
    KEY[3] = 1'b0; SW = 10'd0; #10; 
    state_binout_checker(`Sa, 10'd0);
	 ssd_checker;
    KEY[3] = 1'b1; 
     
    $display("CHECKING Sa->Sb");
    SW = 10'd7; #5; 
	 $display("before clk:"); 
	 ssd_checker; #5; 
    state_binout_checker(`Sb, 10'd7);
    $display("after clk:"); 
	 ssd_checker;

    $display("CHECKING Sb->Sc");
    SW = 10'd0; #5;
	 $display("before clk:"); 
	 ssd_checker; #5; 
    state_binout_checker(`Sc, 10'd0);
	 $display("after clk:"); 
    ssd_checker;

    $display("CHECKING Sc->Sd");
    SW = 10'd3; #5; 
	 $display("before clk:"); 
	 ssd_checker; #5;
    state_binout_checker(`Sd, 10'd3);
	 $display("after clk:"); 
    ssd_checker;

    $display("CHECKING Sd->Se");
    SW = 10'd2; #5; 
	 $display("before clk:"); 
	 ssd_checker; #5; 
    state_binout_checker(`Se, 10'd2);
	 $display("after clk:"); 
    ssd_checker;

    $display("CHECKING Se->We");
    SW = 10'd5; #5; 
	 $display("before clk:"); 
	 ssd_checker; #5; 
    state_binout_checker(`We, 10'd5);
	 $display("after clk:"); 
    ssd_checker;

    $display("CHECKING We->Wf");
	 SW = 10'd1;#5; 
	 $display("before clk:"); 
	 ssd_checker; #5;
    state_binout_checker(`Wf, 10'b1111110000);
	 $display("after clk:"); 
    ssd_checker;

    $display("CHECKING Wf->Cl");
    #10; 
    state_binout_checker(`Cl, 10'b1111110000);
    ssd_checker;
	 
	 $display("CHECKING Cl->Cl");
    #10; 
    state_binout_checker(`Cl, 10'b1111110000);
    ssd_checker;
	 
	 $display("---Test 4---");
	 
	
	 $display("CHECKING RESET");
    KEY[3] = 1'b0; SW = 10'd0; #10; 
    state_binout_checker(`Sa, 10'd0);
	 ssd_checker;
    KEY[3] = 1'b1; 
     
    $display("CHECKING Sa->Sb");
    SW = 10'd7; #5; 
	 $display("before clk:"); 
	 ssd_checker; #5; 
    state_binout_checker(`Sb, 10'd7);
    $display("after clk:"); 
	 ssd_checker;

    $display("CHECKING Sb->Sc");
    SW = 10'd0; #5;
	 $display("before clk:"); 
	 ssd_checker; #5; 
    state_binout_checker(`Sc, 10'd0);
	 $display("after clk:"); 
    ssd_checker;

    $display("CHECKING Sc->Sd");
    SW = 10'd3; #5; 
	 $display("before clk:"); 
	 ssd_checker; #5;
    state_binout_checker(`Sd, 10'd3);
	 $display("after clk:"); 
    ssd_checker;

    $display("CHECKING Sd->Wd");
    SW = 10'd8; #5; 
	 $display("before clk:"); 
	 ssd_checker; #5; 
    state_binout_checker(`Wd, 10'd8);
	 $display("after clk:"); 
    ssd_checker;

    $display("CHECKING Wd->We");
    SW = 10'd5; #5; 
	 $display("before clk:"); 
	 ssd_checker; #5; 
    state_binout_checker(`We, 10'd5);
	 $display("after clk:"); 
    ssd_checker;

    $display("CHECKING We->Wf");
	 SW = 10'd9;#5; 
	 $display("before clk:"); 
	 ssd_checker; #5;
    state_binout_checker(`Wf, 10'b1111110000);
	 $display("after clk:"); 
    ssd_checker;

    $display("CHECKING Wf->Cl");
    #10; 
    state_binout_checker(`Cl, 10'b1111110000);
    ssd_checker;
	 
	 $display("CHECKING Cl->Cl");
    #10; 
    state_binout_checker(`Cl, 10'b1111110000);
    ssd_checker;
	 
	 
	 $display("---Test 5---");
	 
	
	 $display("CHECKING RESET");
    KEY[3] = 1'b0; SW = 10'd0; #10; 
    state_binout_checker(`Sa, 10'd0);
	 ssd_checker;
    KEY[3] = 1'b1; 
     
    $display("CHECKING Sa->Sb");
    SW = 10'd7; #5; 
	 $display("before clk:"); 
	 ssd_checker; #5; 
    state_binout_checker(`Sb, 10'd7);
    $display("after clk:"); 
	 ssd_checker;

    $display("CHECKING Sb->Sc");
    SW = 10'd0; #5;
	 $display("before clk:"); 
	 ssd_checker; #5; 
    state_binout_checker(`Sc, 10'd0);
	 $display("after clk:"); 
    ssd_checker;

    $display("CHECKING Sc->Wc");
    SW = 10'd2; #5; 
	 $display("before clk:"); 
	 ssd_checker; #5;
    state_binout_checker(`Wc, 10'd2);
	 $display("after clk:"); 
    ssd_checker;

    $display("CHECKING Wc->Wd");
    SW = 10'd3; #5; 
	 $display("before clk:"); 
	 ssd_checker; #5; 
    state_binout_checker(`Wd, 10'd3);
	 $display("after clk:"); 
    ssd_checker;

    $display("CHECKING Wd->We");
    SW = 10'd4; #5; 
	 $display("before clk:"); 
	 ssd_checker; #5; 
    state_binout_checker(`We, 10'd4);
	 $display("after clk:"); 
    ssd_checker;

    $display("CHECKING We->Wf");
	 SW = 10'd5;#5; 
	 $display("before clk:"); 
	 ssd_checker; #5;
    state_binout_checker(`Wf, 10'b1111110000);
	 $display("after clk:"); 
    ssd_checker;

    $display("CHECKING Wf->Cl");
    #10; 
    state_binout_checker(`Cl, 10'b1111110000);
    ssd_checker;
	 
	 $display("CHECKING Cl->Cl");
    #10; 
    state_binout_checker(`Cl, 10'b1111110000);
    ssd_checker;
	 
	 $display("---Test 6---");
	 
	
	 $display("CHECKING RESET");
    KEY[3] = 1'b0; SW = 10'd0; #10; 
    state_binout_checker(`Sa, 10'd0);
	 ssd_checker;
    KEY[3] = 1'b1; 
     
    $display("CHECKING Sa->Sb");
    SW = 10'd7; #5; 
	 $display("before clk:"); 
	 ssd_checker; #5; 
    state_binout_checker(`Sb, 10'd7);
    $display("after clk:"); 
	 ssd_checker;

    $display("CHECKING Sb->Wb");
    SW = 10'd1; #5;
	 $display("before clk:"); 
	 ssd_checker; #5; 
    state_binout_checker(`Wb, 10'd1);
	 $display("after clk:"); 
    ssd_checker;

    $display("CHECKING Sc->Wc");
    SW = 10'd6; #5; 
	 $display("before clk:"); 
	 ssd_checker; #5;
    state_binout_checker(`Wc, 10'd6);
	 $display("after clk:"); 
    ssd_checker;

    $display("CHECKING Wc->Wd");
    SW = 10'd8; #5; 
	 $display("before clk:"); 
	 ssd_checker; #5; 
    state_binout_checker(`Wd, 10'd8);
	 $display("after clk:"); 
    ssd_checker;

    $display("CHECKING Wd->We");
    SW = 10'd1; #5; 
	 $display("before clk:"); 
	 ssd_checker; #5; 
    state_binout_checker(`We, 10'd1);
	 $display("after clk:"); 
    ssd_checker;

    $display("CHECKING We->Wf");
	 SW = 10'd0;#5; 
	 $display("before clk:"); 
	 ssd_checker; #5;
    state_binout_checker(`Wf, 10'b1111110000);
	 $display("after clk:"); 
    ssd_checker;

    $display("CHECKING Wf->Cl");
    #10; 
    state_binout_checker(`Cl, 10'b1111110000);
    ssd_checker;
	 
	 $display("CHECKING Cl->Cl");
    #10; 
    state_binout_checker(`Cl, 10'b1111110000);
    ssd_checker;
	 
	 $display("---Test 7---");
	 
	
	 $display("CHECKING RESET");
    KEY[3] = 1'b0; SW = 10'd0; #10; 
    state_binout_checker(`Sa, 10'd0);
	 ssd_checker;
    KEY[3] = 1'b1; 
     
    $display("CHECKING Sa->Wa");
    SW = 10'd6; #5; 
	 $display("before clk:"); 
	 ssd_checker; #5; 
    state_binout_checker(`Wa, 10'd6);
    $display("after clk:"); 
	 ssd_checker;

    $display("CHECKING Wa->Wb");
    SW = 10'd1; #5;
	 $display("before clk:"); 
	 ssd_checker; #5; 
    state_binout_checker(`Wb, 10'd1);
	 $display("after clk:"); 
    ssd_checker;

    $display("CHECKING Sc->Wc");
    SW = 10'd2; #5; 
	 $display("before clk:"); 
	 ssd_checker; #5;
    state_binout_checker(`Wc, 10'd2);
	 $display("after clk:"); 
    ssd_checker;

    $display("CHECKING Wc->Wd");
    SW = 10'd3; #5; 
	 $display("before clk:"); 
	 ssd_checker; #5; 
    state_binout_checker(`Wd, 10'd3);
	 $display("after clk:"); 
    ssd_checker;

    $display("CHECKING Wd->We");
    SW = 10'd6; #5; 
	 $display("before clk:"); 
	 ssd_checker; #5; 
    state_binout_checker(`We, 10'd6);
	 $display("after clk:"); 
    ssd_checker;

    $display("CHECKING We->Wf");
	 SW = 10'd7;#5; 
	 $display("before clk:"); 
	 ssd_checker; #5;
    state_binout_checker(`Wf, 10'b1111110000);
	 $display("after clk:"); 
    ssd_checker;

    $display("CHECKING Wf->Cl");
    #10; 
    state_binout_checker(`Cl, 10'b1111110000);
    ssd_checker;
	 
	 $display("CHECKING Cl->Cl");
    #10; 
    state_binout_checker(`Cl, 10'b1111110000);
    ssd_checker;
	 
	 $display("---Test 8---");
	 
	
	 $display("CHECKING RESET");
    KEY[3] = 1'b0; SW = 10'd0; #10; 
    state_binout_checker(`Sa, 10'd0);
	 ssd_checker;
    KEY[3] = 1'b1; 
     
    $display("CHECKING Sa->Sb");
    SW = 10'd7; #5; 
	 $display("before clk:"); 
	 ssd_checker; #5; 
    state_binout_checker(`Sb, 10'd7);
    $display("after clk:"); 
	 ssd_checker;

    $display("CHECKING Sb->Sc");
    SW = 10'd0; #5;
	 $display("before clk:"); 
	 ssd_checker; #5; 
    state_binout_checker(`Sc, 10'd0);
	 $display("after clk:"); 
    ssd_checker;

    $display("CHECKING Sc-Sd");
    SW = 10'd3; #5; 
	 $display("before clk:"); 
	 ssd_checker; #5;
    state_binout_checker(`Sd, 10'd3);
	 $display("after clk:"); 
    ssd_checker;

    $display("CHECKING Sd->Wd");
    SW = 10'd11; #5; 
	 $display("before clk:"); 
	 ssd_checker; #5; 
    state_binout_checker(`Wd, 10'b1111110011);
	 $display("after clk:"); 
    ssd_checker;

    $display("CHECKING Wd->We");
    SW = 10'd2; #5; 
	 $display("before clk:"); 
	 ssd_checker; #5; 
    state_binout_checker(`We, 10'd2);
	 $display("after clk:"); 
    ssd_checker;

    $display("CHECKING We->Wf");
	 SW = 10'd6;#5; 
	 $display("before clk:"); 
	 ssd_checker; #5;
    state_binout_checker(`Wf, 10'b1111110000);
	 $display("after clk:"); 
    ssd_checker;

    $display("CHECKING Wf->Cl");
    #10; 
    state_binout_checker(`Cl, 10'b1111110000);
    ssd_checker;
	 
	 $display("CHECKING Cl->Cl");
    #10; 
    state_binout_checker(`Cl, 10'b1111110000);
    ssd_checker;
	 
	 $display("---Test 9---");
	 
	
	 $display("CHECKING RESET");
    KEY[3] = 1'b0; SW = 10'd0; #10; 
    state_binout_checker(`Sa, 10'd0);
	 ssd_checker;
    KEY[3] = 1'b1; 
     
    $display("CHECKING Sa->Sb");
    SW = 10'd7; #5; 
	 $display("before clk:"); 
	 ssd_checker; #5; 
    state_binout_checker(`Sb, 10'd7);
    $display("after clk:"); 
	 ssd_checker;

    $display("CHECKING Sb->Wb");
    SW = 10'd4; #5;
	 $display("before clk:"); 
	 ssd_checker; #5; 
    state_binout_checker(`Wb, 10'd4);
	 $display("after clk:"); 
    ssd_checker;

    $display("CHECKING Sc->Wc");
    SW = 10'd14; #5; 
	 $display("before clk:"); 
	 ssd_checker; #5;
    state_binout_checker(`Wc, 10'b1111110011);
	 $display("after clk:"); 
    ssd_checker;

    $display("CHECKING Wc->Wd");
    SW = 10'd5; #5; 
	 $display("before clk:"); 
	 ssd_checker; #5; 
    state_binout_checker(`Wd, 10'd5);
	 $display("after clk:"); 
    ssd_checker;

    $display("CHECKING Wd->We");
    SW = 10'd5; #5; 
	 $display("before clk:"); 
	 ssd_checker; #5; 
    state_binout_checker(`We, 10'd5);
	 $display("after clk:"); 
    ssd_checker;

    $display("CHECKING We->Wf");
	 SW = 10'd6;#5; 
	 $display("before clk:"); 
	 ssd_checker; #5;
    state_binout_checker(`Wf, 10'b1111110000);
	 $display("after clk:"); 
    ssd_checker;

    $display("CHECKING Wf->Cl");
    #10; 
    state_binout_checker(`Cl, 10'b1111110000);
    ssd_checker;
	 
	 $display("CHECKING Cl->Cl");
    #10; 
    state_binout_checker(`Cl, 10'b1111110000);
    ssd_checker;

    if( ~err ) $display("PASSED");
    else $display("FAILED");
    $stop;
end
endmodule: tb_lab3
