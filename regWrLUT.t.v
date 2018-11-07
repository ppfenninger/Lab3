`include "regWrLUT.v"

module testRegWrLUT();
	reg[5:0] opcode;
	reg[5:0] funct;
	wire regwr;

	regWrLUT dut(
		.opcode(opcode),
		.funct(funct),
		.regwr(regwr)
		);

	initial begin
		// $dumpfile("LUT.vcd");
		// $dumpvars();
		$display("Starting RegWrLUT testing.");

		opcode = `LW_OP;
		funct = 6'b111111;
		#5;
		if (regwr !== 1)
			$display("Error in regWrLUT test: LW not asserting regwr.");

		opcode = `SW_OP;
		funct = 6'b111111;
		#5;
		if (regwr !== 0)
			$display("Error in regWrLUT test: SW asserting regwr.");

		opcode = `J_OP;
		funct = 6'b111111;
		#5;
		if (regwr !== 0)
			$display("Error in regWrLUT test: J asserting regwr.");

		opcode = `JAL_OP;
		funct = `JR_FUNCT;
		#5;
		if (regwr !== 1)
			$display("Error in regWrLUT test: JAL not asserting regwr.");

		opcode = `BEQ_OP;
		funct = `JR_FUNCT;
		#5;
		if (regwr !== 0)
			$display("Error in regWrLUT test: BEQ asserting regwr.");

		opcode = `BNE_OP;
		funct = `JR_FUNCT;
		#5;
		if (regwr !== 0)
			$display("Error in regWrLUT test: BNE asserting regwr.");

		opcode = `XORI_OP;
		funct = `JR_FUNCT;
		#5;
		if (regwr !== 1)
			$display("Error in regWrLUT test: XORI not asserting regwr.");

		opcode = `ADDI_OP;
		funct = `JR_FUNCT;
		#5;
		if (regwr !== 1)
			$display("Error in regWrLUT test: ADDI not asserting regwr.");

		opcode = `RTYPE_OP;
		funct = `JR_FUNCT;
		#5;
		if (regwr !== 0)
			$display("Error in regWrLUT test: JR asserting regwr.");

		opcode = `RTYPE_OP;
		funct = `ADD_FUNCT;
		#5;
		if (regwr !== 1)
			$display("Error in regWrLUT test: ADD not asserting regwr.");

		opcode = `RTYPE_OP;
		funct = `SUB_FUNCT;
		#5;
		if (regwr !== 1)
			$display("Error in regWrLUT test: SUB not asserting regwr.");

		opcode = `RTYPE_OP;
		funct = `SLT_FUNCT;
		#5;
		if (regwr !== 1)
			$display("Error in regWrLUT test: SLT not asserting regwr.");

		#5;
		$display("regWrLUT tests finished!");
	end // initial
endmodule // testRegWrLUT