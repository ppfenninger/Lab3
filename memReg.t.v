`include "memReg.v"
`timescale 1 ns / 1 ps

module testmemReg ();
	reg clk;
	reg[6:0] addressRW, addressRead, addressWrite;
	reg[31:0] dataInRW, dataInWrite;
	reg writeEnableRW, writeEnableWrite;
	wire[31:0] dataOutRW, dataOutRead;

	memoryReg memReg(.clk(clk), 
		.dataOutRW(dataOutRW), 
		.dataOutRead(dataOutRead), 
		.addressRW(addressRW), 
		.addressRead(addressRead), 
		.addressWrite(addressWrite), 
		.writeEnableRW(writeEnableRW), 
		.writeEnableWrite(writeEnableWrite), 
		.dataInRW(dataInRW), 
		.dataInWrite(dataInWrite));

	initial begin
	$display("Starting memReg tests.");

	$display("Writing to two memory addresses");
	writeEnableWrite = 0;
	addressRead = 9'b0000000;
	dataInWrite = 31'b0;

	writeEnableRW=1;
	addressRW=9'b1111111;
	dataInRW=32'b11110000;
	clk=0; #10
	clk=1; #10 //addressRW 1111111 should be written to
	addressRW=9'b0000000;
	dataInRW=32'b00001111;
	clk=0; #10
	clk=1; #10 //addressRW 0000000 should now be written to

	$display("Reading from the two memory addresses"); //should not depend on the clock
	writeEnableRW=0;
	addressRW=9'b1111111; #10
	if (dataOutRW !== 32'b11110000) $display("Read test 1 failed - %b", dataOutRW);
	addressRW=9'b0000000; #10
	if (dataOutRW !== 32'b00001111) $display("Read test 2 failed - %b", dataOutRW);

	$display("Writing to two memory addressRWes - with write disabled");
	writeEnableRW=0;
	addressRW=9'b1111111;
	dataInRW=32'b00001111;
	clk=0; #10
	clk=1; #10 //addressRW 1111111 should be written to
	addressRW=9'b0000000;
	dataInRW=32'b11110000;
	clk=0; #10
	clk=1; #10 //addressRW 0000000 should now be written to

	$display("Reading from the two memory addressRWes - make sure they didn't change"); //should not depend on the clock
	writeEnableRW=0;
	addressRW=9'b1111111; #10
	if (dataOutRW !== 32'b11110000) $display("Read test 1 failed - %b", dataOutRW);
	addressRW=9'b0000000; #10
	if (dataOutRW !== 32'b00001111) $display("Read test 2 failed - %b", dataOutRW);


	$display("Writing to two memory addresses at the same time");
	writeEnableRW = 1;
	writeEnableWrite = 1;
	dataInRW = 32'b1;
	dataInWrite = 32'b10;
	addressRW = 9'b1100000;
	addressWrite = 9'b0011111;
	clk = 0; #10
	clk = 1; #10 //register should now be written to

	$display("Reading from two memory addresses at the same time");
	writeEnableRW = 0;
	writeEnableWrite = 0;
	addressRW = 9'b0011111;
	addressRead = 9'b1100000; #10
	if (dataOutRW !== 32'b10) $display("Read from two at once test 1 failed - %b", dataOutRW);
	if (dataOutRead !== 32'b1) $display("Read from two at once test 2 failed - %b", dataOutRead);

	$display("memReg Testing Finished");

	end

endmodule // testmemReg