`include "adder.v"

module testAdder();
	reg[31:0] operandA;
	reg[31:0] operandB;
	wire[31:0] result;
	wire overflow;
	wire carryout;

	initial begin
		$display();

		$display("Starting Adder Tests.");
		$display("TESTING ADD");
	    	operandA=32'd7000;operandB=32'd14000; #4000
	    	if(result != 32'd21000) $display("p + p = p TEST FAILED - result: %d", result);
	    	if(overflow != 0) $display("p + p = p OVERFLOW FAILED");
	    	if(carryout != 0) $display("p + p = p CARRYOUT FAILED");
	    	operandA=32'd2147483647;operandB=32'd14000; #4000
	    	if(result != 32'd2147497647) $display("p + p = n TEST FAILED - result: %d", result);
	    	if(overflow != 1) $display("p + p = n OVERFLOW FAILED");
	    	if(carryout != 0) $display("p + p = n CARRYOUT FAILED");
	    	operandA=32'd0;operandB=32'd87000; #4000
	    	if(result != 32'd87000) $display("0 + p = p TEST FAILED - result: %d", result);
	    	if(overflow != 0) $display("0 + p = p OVERFLOW FAILED");
	    	if(carryout != 0) $display("0 + p = p CARRYOUT FAILED");
	    	operandA=32'd3657483652;operandB=32'd2997483652; #4000
	    	if(result != 32'd2360000008) $display("n + n = n TEST FAILED - result: %d", result);
	    	if(overflow != 0) $display("n + n = n OVERFLOW FAILED");
	    	if(carryout != 1) $display("n + n = n CARRYOUT FAILED");
	    	operandA=32'd2147483652;operandB=32'd2147483652; #4000
	    	if(result != 32'd8) $display("n + n = p TEST FAILED - result: %d", result);
	    	if(overflow != 1) $display("n + n = p OVERFLOW FAILED");
	    	if(carryout != 1) $display("n + n = p CARRYOUT FAILED");
	    	operandA=32'd3657483652;operandB=32'd637483644; #4000
	    	if(result != 32'd0) $display("n + p = 0 TEST FAILED - result: %d", result);
	    	if(overflow != 0) $display("n + p = 0 OVERFLOW FAILED");
	    	if(carryout != 1) $display("n + p = 0 CARRYOUT FAILED");
	    	operandA=32'd3657483652;operandB=32'd637483645; #4000
	    	if(result != 32'd1) $display("n + p = p TEST FAILED - result: %d", result);
	    	if(overflow != 0) $display("n + p = p OVERFLOW FAILED");
	    	if(carryout != 1) $display("n + p = p CARRYOUT FAILED");
	    	operandA=32'd3657483652;operandB=32'd637483643; #4000
	    	if(result != 32'd4294967295) $display("n + p = n TEST FAILED - result: %d", result);
	    	if(overflow != 0) $display("n + p = n OVERFLOW FAILED");
	    	if(carryout != 0) $display("n + p = n CARRYOUT FAILED");

		$display("Finished Adder Testing");
		$display();
	end

endmodule // testAdder