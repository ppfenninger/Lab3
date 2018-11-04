`include "regfile.v"
`include "mux.v"
`include "memReg.v"
`include "alu.v"
`include "adder.v"
`include "regWrLUT.v"
`include "signExtender.v"

module CPU (
	input clk,    // Clock
	input instructionWriteEnable,
	input instructionInput,
	input instructionInputAddress,
	input reset
);
//wire declaration
wire[31:0] pcAfterAdd, pcPlusFour, Da, immediate, RegWrite;
wire opcode2Inv, opcode3Inv, opcode4Inv, opcode5Inv;

wire isBranch, isBneOrBeq, zero, wEnable;

//Program Counter Logic
reg[31:0] programCounter;
wire [31:0] instruction, nextProgramCounter;

//advances the program to the next step
always @(posedge clk) begin
	if (reset) programCounter <= 32'b0;
	else programCounter <= nextProgramCounter;
end

wire[25:0] jump;
wire[31:0] finalJumpValue;
assign jump = instruction[25:0];
assign finalJumpValue = {programCounter[31:26], jump};

wire isJumpSel;
not(opcode5Inv, opcode[5]);
or(isJumpSel, opcode5Inv, opcode4Inv, opcode3Inv, opcode2Inv, opcode[1]);
wire[31:0] jumpNextPC;
mux isJumpMux(
	.input0(pcAfterAdd),
	.input1(finalJumpValue),
	.out(jumpNextPC),
	.sel(isJumpSel)
);

wire jrOr, jrNor;
or(jrOr, opcode[0], opcode[1], opcode[2], opcode[3], opcode[4], opcode[5], funct[0]); // if all of these are zero then its JR
not(jrNor, jrOr);
mux isNotJRMux(
	.input0(Da), //R[rs]
	.input1(jumpNextPC),
	.out(nextProgramCounter),
	.sel(jrNor)
);

wire[31:0] fourOrBranch;
Adder programCounterAdder(
	.operandA(programCounter),
	.operandB(fourOrBranch),
	.result(pcAfterAdd),
	.carryout(),
	.overflow()
);

wire isBranchOrAddSel;
mux isBranchOrAddMux(
	.input0(immediate), // has already been extended
	.input1(32'd4),
	.out(fourOrBranch),
	.sel(isBranchOrAddSel)
);

and(isBranchOrAddSel, isBranch, isBneOrBeq);

and(isBranch, opcode[1], opcode[2]); //is true if BNE or BEQ
wire zeroInv;
not(zeroInv, zero);
defparam isBneOrBeqMux.data_width = 1;
mux isBneOrBeqMux(
	.input0(zero),
	.input1(zeroInv),
	.out(isBneOrBeq),
	.sel(opcode[0])
);

wire[5:0] opcode;
assign opcode = instruction[31:26];
wire[5:0] funct;
assign funct = instruction[5:0];

//Register File Logic
wire[4:0] Rs, Rt, Rd;
wire[4:0] regWrite;
assign Rs = instruction[25:21];
assign Rt = instruction[20:16];
assign Rd = instruction[15:11];
wire[31:0] Db, Dw;

regfile register(
	.ReadData1(Da),
	.ReadData2(Db),
	.WriteData(Dw),
	.ReadRegister1(Rs),
	.ReadRegister2(Rt),
	.WriteRegister(regWrite),
	.wEnable(wEnable),
	.Clk(clk)
);

regWrLUT isRegWrite(
	.opcode(opcode),
	.funct(funct),
	.regwr(wEnable)
);

wire rTypeOr; 
wire[4:0] regWriteRdOrRt;
or(rTypeOr, opcode[0], opcode[1], opcode[2], opcode[3], opcode[4], opcode[5]);
//determines if you are writing to Rd or Rt
mux #(5) writeRegisterMuxRtOrRd(
	.input0(Rd),
	.input1(Rt),
	.out(regWriteRdOrRt),
	.sel(rTypeOr)
);

wire isJumpandLink;
not(opcode2Inv, opcode[2]);
not(opcode3Inv, opcode[3]);
not(opcode4Inv, opcode[4]);
and(isJumpandLink, opcode[0], opcode[1], opcode2Inv, opcode3Inv, opcode4Inv);
//determines if write address is set my Rt or Rd or is "31" because of the opcode
mux #(5) writeRegister31Mux(
	.input0(regWriteRdOrRt),
	.input1(5'd31),
	.out(RegWrite),
	.sel(isJumpandLink)
);

//ALU Logic

wire[31:0] DbOrImmediate;

mux isDbOrImmediateMux(
	.input0(Db),
	.input1(immediate),
	.out(DbOrImmediate),
	.sel(rTypeOr)
);

wire[15:0] preExtendedImm;
assign preExtendedImm = instruction[15:0];

signExtend sExtend(
	.extend(preExtendedImm),
	.extended(immediate)
);

wire[31:0] aluResult;
wire overflow, carryout;

ALU alu(
	.operandA(Da),
	.operandB(DbOrImmediate),
	.opcode(opcode),
	.funct(funct),
	.zero(zero),
	.res(aluResult),
	.overflow(overflow),
	.carryout(carryout)
);

//Memory Logic

wire[31:0] dataOut;
wire dataWrite;
and(dataWrite, opcode[5], opcode[3]);
memoryReg memory(
	.clk(clk),
	.dataOutRW(dataOut),
	.dataOutRead(instruction),
	.addressRW(aluResult),
	.addressRead(programCounter),
	.addressWrite(9'b0),
	.writeEnableRW(dataWrite),
	.writeEnableWrite(1'b0),
	.dataInRW(Db),
	.dataInWrite(32'b0)
);

wire isAluOrDout;
wire[31:0] aluOrDout;
and(isAluOrDout, opcode[5], opcode3Inv);

mux isAluOrDoutMux(
	.input0(dataOut),
	.input1(aluResult),
	.out(aluOrDout),
	.sel(isAluOrDout)
);

mux isJalAluOrDoutMux(
	.input0(aluOrDout),
	.input1(pcPlusFour),
	.out(Dw),
	.sel(isJumpandLink)
);

Adder pcPlusFourAdder(
	.operandA(programCounter),
	.operandB(32'd4),
	.result(pcPlusFour),
	.carryout(),
	.overflow()
);
endmodule