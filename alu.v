`define LW_OP    6'b100011
`define SW_OP    6'b101011
`define J_OP     6'b000010
`define JAL_OP   6'b000011
`define BEQ_OP   6'b000100
`define BNE_OP   6'b000101
`define XORI_OP  6'b001110
`define ADDI_OP  6'b001000
`define RTYPE_OP 6'b000000

`define JR_FUNCT  6'b001000
`define ADD_FUNCT 6'b100000
`define SUB_FUNCT 6'b100010
`define SLT_FUNCT 6'b101010

`timescale 1 ns / 1 ps

module ALUBitSlice(
	input a,
	input b,
	input[5:0] opcode,
	input[5:0] funct,
	input carryIn,
	output res,
	output carryOut,
	output reg isSubtract
);
wire addRes;
wire finalAdd;
wire xorRes;
wire finalXor;
wire finalA;
reg isA;
reg isAdd;
reg isXor;

	AdderAndSubtractor adder (
        .res (addRes),
        .carryout (carryOut),
        .a (a),
        .b (b),
        .isSubtract (isSubtract),
        .carryin (carryIn)
    );

    xor xorRes(xorRes, a, b);


	always @(opcode or funct) begin
		case (opcode)
			`LW_OP:   begin isA=0; isAdd=1; isXor=0; isSubtract=0; end
			`SW_OP:   begin isA=0; isAdd=1; isXor=0; isSubtract=0; end //SW
			`J_OP:    begin isA=1; isAdd=0; isXor=0; isSubtract=0; end //J
			`JAL_OP:  begin isA=1; isAdd=0; isXor=0; isSubtract=0; end //JAL
			`BEQ_OP:  begin isA=0; isAdd=1; isXor=0; isSubtract=1; end //BEQ
			`BNE_OP:  begin isA=0; isAdd=1; isXor=0; isSubtract=1; end//BNE
			`XORI_OP: begin isA=0; isAdd=0; isXor=1; isSubtract=0; end //XORI
			`ADDI_OP: begin isA=0; isAdd=1; isXor=0; isSubtract=0; end //ADDI

			`RTYPE_OP: begin
				case (funct)
					`JR_FUNCT:  begin isA=1; isAdd=0; isXor=0; isSubtract=0; end //JR
					`ADD_FUNCT: begin isA=0; isAdd=1; isXor=0; isSubtract=0; end //ADD
					`SUB_FUNCT: begin isA=0; isAdd=1; isXor=0; isSubtract=1; end //SUB //actually is subtract
					`SLT_FUNCT: begin isA=0; isAdd=1; isXor=0; isSubtract=1; end//SLT //actually is subtract
					default: $display("Error in ALUBitSlice: Invalid funct");
				endcase
			end
			default: $display("Error in ALU: Invalid opcode. OPCODE: %b", opcode);
		endcase
	end

	and andAdd(finalAdd, addRes, isAdd);
	and andXor(finalXor, xorRes, isXor);
	and andA(finalA, a, isA);

	or orRes(res, finalAdd, finalXor, finalA);

endmodule

module AdderAndSubtractor
(
    output res, 
    output carryout,
    input a, 
    input b, 
    input isSubtract,
    input carryin
);
    wire BxorSub;
    wire xAorB;
    wire AandB;
    wire xAorBandCin;
    xor  xorgate(BxorSub, b, isSubtract);
    xor  xorgate(xAorB, a, BxorSub);   // OR gate produces AorB from A and B
    xor  xorgate(res, xAorB, carryin);
    and  andgate(AandB, a, BxorSub);
    and  andgate(xAorBandCin, xAorB, carryin);
    or   orgate(carryout, AandB, xAorBandCin);
endmodule

module isZero (
    input[31:0] zeroBit,
    output out
);
wire outInv;
//nor all bits, if all are zero a one will be returned if any are not a 0 will be returned. 

or zeroNOR(outInv, zeroBit[0], zeroBit[1], zeroBit[2], zeroBit[3], zeroBit[4], zeroBit[5], zeroBit[6], zeroBit[7], zeroBit[8], zeroBit[9], zeroBit[10], zeroBit[11], zeroBit[12], zeroBit[13], zeroBit[14], 
    zeroBit[15], zeroBit[16], zeroBit[17], zeroBit[18], zeroBit[19], zeroBit[20], zeroBit[21], zeroBit[22], zeroBit[23], zeroBit[24], zeroBit[25], zeroBit[26], zeroBit[27], zeroBit[28], zeroBit[29], zeroBit[30], zeroBit[31]);
not notOut(out, outInv);

endmodule // isZero

module didOverflow // calculates overflow of 2 bits
(
    output overflow,
    input a, 
    input b, 
    input s, // most sig bit
    input sub
);
    wire BxorSub;
    wire notA;
    wire notB;
    wire notS;
    wire aAndB;
    wire notaAndNotb;
    wire negToPos;
    wire posToNeg;
    xor xorgate(BxorSub, b, sub);
    not aNot(notA, a);
    not bNot(notB, BxorSub);
    not sNot(notS, s);
    and andab(aAndB, a, BxorSub);
    and andabNot(notaAndNotb, notA, notB);
    and andSwitch1(negToPos, aAndB, notS);
    and andSwitch2(posToNeg, notaAndNotb, s);
    or orGate(overflow, negToPos, posToNeg);
endmodule

module ALU(
	input[31:0] operandA,
	input[31:0] operandB,
	input[5:0] opcode,
	input[5:0] funct,
	output zero,
	output[31:0] res,
	output overflow,
	output carryout
);
	wire[31:0] initialResult;
	wire[31:0] initialFinal;
	reg isInitial;
	wire[31:0] sltResult;
	wire[31:0] sltFinal;
	reg isSLT;
	wire isSubtract;
	wire[32:0] carryOut;

	or carryOr(carryOut[0], isSubtract, isSubtract);
	
	generate
        genvar i;
        for (i=0; i<32; i=i+1)
	//makes mini ALU for each bit
        begin
            ALUBitSlice aluBitSlice (
                .carryOut (carryOut[i+1]),
                .res (initialResult[i]),
                .a (operandA[i]),
                .b (operandB[i]),
                .carryIn (carryOut[i]),
                .isSubtract (isSubtract),
                .opcode (opcode),
                .funct (funct)
            );
        end
    endgenerate

	always @(opcode or funct) begin
		case (opcode)
			`LW_OP:   begin isInitial=1; isSLT=0; end //LW
			`SW_OP:   begin isInitial=1; isSLT=0; end //SW
			`J_OP:    begin isInitial=1; isSLT=0; end //J
			`JAL_OP:  begin isInitial=1; isSLT=0; end //JAL
			`BEQ_OP:  begin isInitial=1; isSLT=0; end //BEQ
			`BNE_OP:  begin isInitial=1; isSLT=0; end //BNE
			`XORI_OP: begin isInitial=1; isSLT=0; end //XORI
			`ADDI_OP: begin isInitial=1; isSLT=0; end //ADDI

			`RTYPE_OP: begin
				case (funct)
					`JR_FUNCT:  begin isInitial=1; isSLT=0; end //JR
					`ADD_FUNCT: begin isInitial=1; isSLT=0; end //ADD
					`SUB_FUNCT: begin isInitial=1; isSLT=0; end //SUB
					`SLT_FUNCT: begin isInitial=0; isSLT=1; end //SLT
					default: $display("Error in ALU: Invalid funct. OPCODE: %b", opcode);
				endcase
			end

			default: $display("Error in ALU: Invalid opcode");
		endcase
	end

	//SLT Module for . Uses outputs of subtractor
    wire overflowInv;
    wire isSLTinv;
    wire SLTval;

    wire bInv;
    not(bInv, operandB[31]);

    wire aCheck;
    wire bCheck;
    wire abCheck;

    and(aCheck, operandA[31], initialResult[31], isSLT);
    and(bCheck, bInv, initialResult[31], isSLT);
    and(abCheck, operandA[31], bInv, isSLT);

    or(SLTval, aCheck, bCheck, abCheck);

    // not(overflowInv, overflow);
    not(isSLTinv, isSLT);
    // and(SLTval, initialResult[31], overflowInv, isSLT);

    generate
        genvar j;
        for (j=1; j<32; j=j+1)
        begin
            and(res[j], initialResult[j], isSLTinv);
        end
    endgenerate

    wire sltCheck;
    and(sltCheck, initialResult[0], isSLTinv);
    or(res[0], sltCheck, SLTval);

	didOverflow overflowCalc (
		.overflow (overflow),
		.a (operandA[31]),
		.b (operandB[31]),
		.s (initialResult[31]),
		.sub (isSubtract)
	);

	isZero zeroCalc(
        .zeroBit (res),
        .out (zero)
    );

    or orCarryout(carryout, carryOut[32], carryOut[32]);

endmodule

