//------------------------------------------------------------------------------
// Test harness validates hw4testbench by connecting it to various functional 
// or broken register files, and verifying that it correctly identifies each
//------------------------------------------------------------------------------

`include "regfile.v"

module hw4testbenchharness();

  wire[31:0]	ReadData1;	// Data from first register read
  wire[31:0]	ReadData2;	// Data from second register read
  wire[31:0]	WriteData;	// Data to write to register
  wire[4:0]	ReadRegister1;	// Address of first register to read
  wire[4:0]	ReadRegister2;	// Address of second register to read
  wire[4:0]	WriteRegister;  // Address of register to write
  wire		RegWrite;	// Enable writing of register when High
  wire		Clk;		// Clock (Positive Edge Triggered)

  reg		begintest;	// Set High to begin testing register file
  wire  	endtest;    	// Set High to signal test completion 
  wire		dutpassed;	// Indicates whether register file passed tests

  // Instantiate the register file being tested.  DUT = Device Under Test
  regfile DUT
  (
    .ReadData1(ReadData1),
    .ReadData2(ReadData2),
    .WriteData(WriteData),
    .ReadRegister1(ReadRegister1),
    .ReadRegister2(ReadRegister2),
    .WriteRegister(WriteRegister),
    .wEnable(RegWrite),
    .Clk(Clk)
  );

  // Instantiate test bench to test the DUT
  hw4testbench tester
  (
    .begintest(begintest),
    .endtest(endtest), 
    .dutpassed(dutpassed),
    .ReadData1(ReadData1),
    .ReadData2(ReadData2),
    .WriteData(WriteData), 
    .ReadRegister1(ReadRegister1), 
    .ReadRegister2(ReadRegister2),
    .WriteRegister(WriteRegister),
    .RegWrite(RegWrite), 
    .Clk(Clk)
  );

  // Test harness asserts 'begintest' for 1000 time steps, starting at time 10
  initial begin
    $display("Starting Regfile Tests.");
    begintest=0;
    #10;
    begintest=1;
    #1000;
  end

  // Display test results ('dutpassed' signal) once 'endtest' goes high
  always @(posedge endtest) begin
    $display("Regfile tests passed?: %b", dutpassed);
    $display();
  end

endmodule


//------------------------------------------------------------------------------
// Your HW4 test bench
//   Generates signals to drive register file and passes them back up one
//   layer to the test harness. This lets us plug in various working and
//   broken register files to test.
//
//   Once 'begintest' is asserted, begin testing the register file.
//   Once your test is conclusive, set 'dutpassed' appropriately and then
//   raise 'endtest'.
//------------------------------------------------------------------------------

module hw4testbench
(
// Test bench driver signal connections
input	   		begintest,	// Triggers start of testing
output reg 		endtest,	// Raise once test completes
output reg 		dutpassed,	// Signal test result

// Register File DUT connections
input[31:0]		ReadData1,
input[31:0]		ReadData2,
output reg[31:0]	WriteData,
output reg[4:0]		ReadRegister1,
output reg[4:0]		ReadRegister2,
output reg[4:0]		WriteRegister,
output reg		RegWrite,
output reg		Clk
);

  // Initialize register driver signals
  initial begin
    WriteData=32'd0;
    ReadRegister1=5'd0;
    ReadRegister2=5'd0;
    WriteRegister=5'd0;
    RegWrite=0;
    Clk=0;
  end

  // Once 'begintest' is asserted, start running test cases
  always @(posedge begintest) begin
    endtest = 0;
    dutpassed = 1;
    #10

  // Test Case 1: 
  //   Write '42' to register 2, verify with Read Ports 1 and 2
  WriteRegister = 5'd2;
  WriteData = 32'd42;
  RegWrite = 1;
  ReadRegister1 = 5'd2;
  ReadRegister2 = 5'd2;
  #5 Clk=1; #5 Clk=0;	// Generate single clock pulse

  // Verify expectations and report test result
  if((ReadData1 !== 42) || (ReadData2 !== 42)) begin
    dutpassed = 0;	// Set to 'false' on failure
    $display("Regfile Test Case 1 Failed: Didn't write value and read back");
  end

  // Test Case 2: 
  //   Write '15' to register 2, verify with Read Ports 1 and 2
  WriteRegister = 5'd2;
  WriteData = 32'd15;
  RegWrite = 1;
  ReadRegister1 = 5'd2;
  ReadRegister2 = 5'd2;
  #5 Clk=1; #5 Clk=0;

  if((ReadData1 !== 15) || (ReadData2 !== 15)) begin
    dutpassed = 0;
    $display("Regfile Test Case 2 Failed: Didn't write value and read back");
  end

  // Test Case 3:
  //   Write '42' to register 12, then disable port writing, 
  //   then attempt to write '12' to register 12
  //   (Fails if writing is always enabled)
  WriteRegister = 5'd12;
  WriteData = 32'd42;
  RegWrite = 1;
  ReadRegister1 = 5'd12;
  ReadRegister2 = 5'd12;
  #5 Clk=1; #5 Clk=0;
  RegWrite = 0;
  WriteData = 32'd12;
  #5 Clk=1; #5 Clk=0;

  if((ReadData1 !== 42) || (ReadData2 !== 42)) begin
    dutpassed = 0;
    $display("Regfile Test Case 3 Failed: Low RegWrite didn't disable write");
  end

  // Test Case 4:
  //   Write '42' to register 12, then
  //   write '40' to register 11
  //   (Fails if all ports are always written to)
  //   (Also Fails if either read register reads the wrong register
  //    which covers test case #5)
  WriteRegister = 5'd12;
  WriteData = 32'd42;
  RegWrite=1;
  ReadRegister1 = 5'd12;
  ReadRegister2 = 5'd11;
  #5 Clk=1; #5 Clk=0;
  WriteData = 32'd40;
  WriteRegister = 5'd11;
  #5 Clk=1; #5 Clk=0;

  if((ReadData1 !== 42) || (ReadData2 !== 40)) begin
    dutpassed = 0;
    $display("Regfile Test Case 4 Failed: Separate registers not written to and read from.");
  end

  // Test Case 5:
  //   Write '42' to register 0
  //   (Fails if register 0 isn't always 0)
  WriteRegister = 5'd0;
  WriteData = 32'd42;
  RegWrite=1;
  ReadRegister1 = 5'd0;
  ReadRegister2 = 5'd0;
  #5 Clk=1; #5 Clk=0;

  if((ReadData1 !== 0) || (ReadData2 !== 0)) begin
    dutpassed = 0;
    $display("Regfile Test Case 5 Failed: Zero register not always 0.");
  end

  // Test Case 6:
  //   Write '42' to register 12, read it using both data reads
  //   Then change data read port to 0 without clocking
  //   Fails if the read port has to be clocked to update
  WriteRegister = 5'd12;
  WriteData = 32'd42;
  RegWrite=1;
  ReadRegister1 = 5'd12;
  ReadRegister2 = 5'd12;
  #5 Clk=1; #5 Clk=0;

  if((ReadData1 !== 42) || (ReadData2 !== 42)) begin
    dutpassed = 0;
    $display("Regfile Test Case 6 Failed: Didn't write value and read back.");
  end

  ReadRegister1 = 5'd0;
  ReadRegister2 = 5'd0;
  #5;

  if((ReadData1 !== 0) || (ReadData2 !== 0)) begin
    dutpassed = 0;
    $display("Regfile Test Case 6 Failed: Register has to clock to update outputs.");
  end
  // All done!  Wait a moment and signal test completion.
  #5
  endtest = 1;

end

endmodule
