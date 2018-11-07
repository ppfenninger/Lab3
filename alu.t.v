`include "alu.v"
`timescale 1 ns / 1 ps

module testALU();
	reg[31:0] operandA;
	reg[31:0] operandB;
    reg[5:0] opcode;
    reg[5:0] funct;

	wire[31:0] res;
	wire overflow;
	wire carryout;
	wire zero;


	ALU alu (operandA, operandB, opcode, funct, zero, res, overflow, carryout);

	initial begin
        // $dumpfile("ALU.vcd");
        // $dumpvars();
        $display("Starting ALU tests.");

    	$display("TESTING BASIC GATES");

    	// XOR Test
        opcode = `XORI_OP;
        funct = `JR_FUNCT;
    	if(res != 32'b0110) $display("XOR Test Failed - res: %b%b%b%b", res[3], res[2], res[1], res[0]);

    	$display("TESTING ADD");
    	opcode = `ADDI_OP;
        funct = `JR_FUNCT;
    	operandA=32'd7000;operandB=32'd14000; #4000
    	if(res != 32'd21000) $display("p + p = p TEST FAILED - res: %d", res);
    	if(overflow != 0) $display("p + p = p OVERFLOW FAILED");
    	if(carryout != 0) $display("p + p = p CARRYOUT FAILED");
    	operandA=32'd2147483647;operandB=32'd14000; #4000
    	if(res != 32'd2147497647) $display("p + p = n TEST FAILED - res: %d", res);
    	if(overflow != 1) $display("p + p = n OVERFLOW FAILED");
    	if(carryout != 0) $display("p + p = n CARRYOUT FAILED");
    	if(zero != 0) $display("ZERO FAILED - was not 0 part 1");
    	operandA=32'd0;operandB=32'd87000; #4000
    	if(res != 32'd87000) $display("0 + p = p TEST FAILED - res: %d", res);
    	if(overflow != 0) $display("0 + p = p OVERFLOW FAILED");
    	if(carryout != 0) $display("0 + p = p CARRYOUT FAILED");
    	if(zero != 0) $display("ZERO FAILED - was not 0 part 2");
    	operandA=32'd3657483652;operandB=32'd2997483652; #4000
    	if(res != 32'd2360000008) $display("n + n = n TEST FAILED - res: %d", res);
    	if(overflow != 0) $display("n + n = n OVERFLOW FAILED");
    	if(carryout != 1) $display("n + n = n CARRYOUT FAILED");
    	if(zero != 0) $display("ZERO FAILED - was not 0 part 3");

        opcode = `RTYPE_OP;
        funct = `ADD_FUNCT;
    	operandA=32'd2147483652;operandB=32'd2147483652; #4000
    	if(res != 32'd8) $display("n + n = p TEST FAILED - res: %d", res);
    	if(overflow != 1) $display("n + n = p OVERFLOW FAILED");
    	if(carryout != 1) $display("n + n = p CARRYOUT FAILED");
    	if(zero != 0) $display("ZERO FAILED - was not 0 part 4");
    	operandA=32'd3657483652;operandB=32'd637483644; #4000
    	if(res != 32'd0) $display("n + p = 0 TEST FAILED - res: %d", res);
    	if(overflow != 0) $display("n + p = 0 OVERFLOW FAILED");
    	if(carryout != 1) $display("n + p = 0 CARRYOUT FAILED");
    	if(zero != 1) $display("ZERO FAILED - was 0");
    	operandA=32'd3657483652;operandB=32'd637483645; #4000
    	if(res != 32'd1) $display("n + p = p TEST FAILED - res: %d", res);
    	if(overflow != 0) $display("n + p = p OVERFLOW FAILED");
    	if(carryout != 1) $display("n + p = p CARRYOUT FAILED");
    	if(zero != 0) $display("ZERO FAILED - was not 0 part 5");
    	operandA=32'd3657483652;operandB=32'd637483643; #4000
    	if(res != 32'd4294967295) $display("n + p = n TEST FAILED - res: %d", res);
    	if(overflow != 0) $display("n + p = n OVERFLOW FAILED");
    	if(carryout != 0) $display("n + p = n CARRYOUT FAILED");


    	$display("TESTING SUBTRACT");
    	opcode = `RTYPE_OP;
        funct = `SUB_FUNCT;
    	operandA=32'd0;operandB=32'd637483644; #4000
    	if(res != 32'd3657483652) $display("0 - p = n TEST FAILED - res: %d", res); //the res is equivalent to -637483644
    	if(overflow != 0) $display("0 - p = n OVERFLOW FAILED");
    	if(carryout != 0) $display("0 - p = n CARRYOUT FAILED");
    	operandA=32'd0;operandB=32'd3657483652; #4000 // b is equivalent to -637483644
    	if(res != 32'd637483644) $display("0 - n = p TEST FAILED - res: %d", res);
    	if(overflow != 0) $display("0 - n = p OVERFLOW FAILED");
    	if(carryout != 0) $display("0 - n = p CARRYOUT FAILED");
    	operandA=32'd3657483652;operandB=32'd3657483652; #4000 // a and b is equivalent to -637483644
    	if(res != 32'd0) $display("n - n = 0 TEST FAILED - res: %d", res);
    	if(overflow != 0) $display("n - n = 0 OVERFLOW FAILED");
    	if(carryout != 1) $display("n - n = 0 CARRYOUT FAILED");
    	if(zero != 1) $display("ZERO FAILED - was 0 part 1");

        opcode = `BEQ_OP;
        funct = `JR_FUNCT;
    	operandA=32'd637483644;operandB=32'd637483644; #4000
    	if(res != 32'd0) $display("p - p = 0 TEST FAILED - res: %d", res);
    	if(overflow != 0) $display("p - p = 0 OVERFLOW FAILED");
    	if(carryout != 1) $display("p - p = 0 CARRYOUT FAILED");
    	if(zero != 1) $display("ZERO FAILED - was 0 part 2");
    	operandA=32'd436258181;operandB=32'd236258181; #4000
    	if(res != 32'd200000000) $display("p - p = p TEST FAILED - res: %d", res);
    	if(overflow != 0) $display("p - p = p OVERFLOW FAILED");
    	if(carryout != 1) $display("p - p = p CARRYOUT FAILED");
    	if(zero != 0) $display("ZERO FAILED - was not 0");
    	operandA=32'd436258181;operandB=32'd2013265920; #4000
    	if(res != 32'd2717959557) $display("p - p = n TEST FAILED - res: %d", res); //res is equivalent to -1845443195
    	if(overflow != 0) $display("p - p = n OVERFLOW FAILED");
    	if(carryout != 0) $display("p - p = n CARRYOUT FAILED");
    	operandA=32'd3657483652;operandB=32'd3657483653; #4000 //a and b both correspond to negative numbers
    	if(res != 32'd4294967295) $display("n - n = n TEST FAILED - res: %d", res); //the res is also a negative twos complement number
    	if(overflow != 0) $display("n - n = n OVERFLOW FAILED");
    	if(carryout != 0) $display("n - n = n CARRYOUT FAILED");
        
        opcode = `BNE_OP;
        funct = `JR_FUNCT;
    	operandA=32'd3657483652;operandB=32'd3657483651; #4000  
    	if(res != 32'd1) $display("n - n = p TEST FAILED - res: %d", res);
    	if(overflow != 0) $display("n - n = p OVERFLOW FAILED");
    	if(carryout != 1) $display("n - n = p CARRYOUT FAILED");
    	operandA=32'd7000;operandB=32'd4294953296 ; #4000 //b is the equivalent of -14000
    	if(res != 32'd21000) $display("p - n = p TEST FAILED - res: %d", res);
    	if(overflow != 0) $display("p - n = p OVERFLOW FAILED");
    	if(carryout != 0) $display("p - n = p CARRYOUT FAILED");
    	operandA=32'd2147483647;operandB=32'd4294953296; #4000
    	if(res != 32'd2147497647) $display("p - n = n TEST FAILED - res: %d", res);
    	if(overflow != 1) $display("p - n = n OVERFLOW FAILED");
    	if(carryout != 0) $display("p - n = n CARRYOUT FAILED");
    	operandA=32'd3657483652;operandB=32'd1297483644; #4000
    	if(res != 32'd2360000008) $display("n - p = n TEST FAILED - res: %d", res);
    	if(overflow != 0) $display("n - p = n OVERFLOW FAILED");
    	if(carryout != 1) $display("n - p = n CARRYOUT FAILED");
    	operandA=32'd2147483652;operandB=32'd2147483644; #4000
    	if(res != 32'd8) $display("n - p = p TEST FAILED - res: %d", res);
    	if(overflow != 1) $display("n - p = p OVERFLOW FAILED");
    	if(carryout != 1) $display("n - p = p CARRYOUT FAILED");

    	$display("TESTING SLT");
        opcode = `RTYPE_OP;
        funct = `SLT_FUNCT;
    	operandA=32'd0;operandB=32'd1000; #4000
    	if (res != 32'd1) $display("0 < p TEST FAILED - res: %b", res);
    	operandA=32'd1;operandB=32'd0; #4000
    	if (res != 32'd0) $display("p not < 0 TEST FAILED - res: %b", res);
    	operandA=32'd0;operandB=32'd3657483652; #4000
    	if (res != 32'd0) $display("0 not < n TEST FAILED - res: %b", res);
    	operandA=32'd3657483652;operandB=32'd0; #4000
    	if (res != 32'd1) $display("n < 0 TEST FAILED - res: %b %b", res, overflow);
    	operandA=32'd1000;operandB=32'd2000; #4000
    	if (res != 32'd1) $display("p < p TEST FAILED");
    	operandA=32'd2000;operandB=32'd1000; #4000
    	if (res != 32'd0) $display("p not < p TEST FAILED");
    	operandA=32'd2360000008;operandB=32'd3657483652; #4000
    	if (res != 32'd1) $display("n < n TEST FAILED");
    	operandA=32'd3657483652;operandB=32'd2360000008; #4000
    	if (res != 32'd0) $display("n not < n TEST FAILED %b", res);
    	operandA=32'd3657483652;operandB=32'd1000; #10000
    	if (res != 32'd1) $display("n < p TEST FAILED - res: %b, %b", res, overflow);
    	if(zero != 0) $display("ZERO FAILED - was not 1");
    	operandA=32'd1000;operandB=32'd3657483652; #4000
    	if (res != 32'd0) $display("p not < n TEST FAILED");
    	if(zero != 32'd1) $display("ZERO FAILED - was 0 %b   %b ", zero, res);

        $display("ALU Testing Finished");
        $display();
	end
endmodule // testALU
