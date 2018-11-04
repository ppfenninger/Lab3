`include "memReg.v"
`timescale 1 ns / 1 ps

module testmemReg ();
	reg clk;
	reg[6:0] address1, address2;
	reg[31:0] dataIn1, dataIn2;
	reg writeEnable1, writeEnable2;
	wire[31:0] dataOut1, dataOut2;

	memoryReg memReg(clk, dataOut1, dataOut2, address1, address2, writeEnable1, writeEnable2, dataIn1, dataIn2);

	initial begin

	$display("Writing to two memory addresses");
	writeEnable2 = 0;
	address2 = 9'b0000000;
	dataIn2 = 31'b0;

	writeEnable1=1;
	address1=9'b1111111;
	dataIn1=32'b11110000;
	clk=0; #10
	clk=1; #10 //address1 1111111 should be written to
	address1=9'b0000000;
	dataIn1=32'b00001111;
	clk=0; #10
	clk=1; #10 //address1 0000000 should now be written to

	$display("Reading from the two memory addresses"); //should not depend on the clock
	writeEnable1=0;
	address1=9'b1111111; #10
	if (dataOut1 !== 32'b11110000) $display("Read test 1 failed - %b", dataOut1);
	address1=9'b0000000; #10
	if (dataOut1 !== 32'b00001111) $display("Read test 2 failed - %b", dataOut1);

	$display("Writing to two memory address1es - with write disabled");
	writeEnable1=0;
	address1=9'b1111111;
	dataIn1=32'b00001111;
	clk=0; #10
	clk=1; #10 //address1 1111111 should be written to
	address1=9'b0000000;
	dataIn1=32'b11110000;
	clk=0; #10
	clk=1; #10 //address1 0000000 should now be written to

	$display("Reading from the two memory address1es - make sure they didn't change"); //should not depend on the clock
	writeEnable1=0;
	address1=9'b1111111; #10
	if (dataOut1 !== 32'b11110000) $display("Read test 1 failed - %b", dataOut1);
	address1=9'b0000000; #10
	if (dataOut1 !== 32'b00001111) $display("Read test 2 failed - %b", dataOut1);


	$display("Writing to two memory addresses at the same time");
	writeEnable1 = 1;
	writeEnable2 = 1;
	dataIn1 = 32'b1;
	dataIn2 = 32'b10;
	address1 = 9'b1100000;
	address2 = 9'b0011111;
	clk = 0; #10
	clk = 1; #10 //register should now be written to

	$display("Reading from two memory addresses at the same time");
	writeEnable1 = 0;
	writeEnable2 = 0;
	address1 = 9'b0011111;
	address2 = 9'b1100000; #10
	if (dataOut1 !== 32'b10) $display("Read from two at once test 1 failed - %b", dataOut1);
	if (dataOut2 !== 32'b1) $display("Read from two at once test 2 failed - %b", dataOut2);

	$display("Testing Finished");

	end

endmodule // testmemReg