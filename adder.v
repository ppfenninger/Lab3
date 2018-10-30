module FullAdder1
(
    output res, 
    output carryout,
    input a, 
    input b,
    input carryin
);
    wire xAorB;
    wire AandB;
    wire xAorBandCin;
    xor  xorgate(xAorB, a, b);   // OR gate produces AorB from A and B
    xor  xorgate(res, xAorB, carryin);
    and  andgate(AandB, a, b);
    and  andgate(xAorBandCin, xAorB, carryin);
    or   orgate(carryout, AandB, xAorBandCin);
endmodule

module didOverflow1
(
    output overflow,
    input a, 
    input b, 
    input s
); 
//this module determines if a signal overflows
// it requires the most significant bit of the two things being added together as well as the most significant bit of the sum
// this is only relevant when you are doing signed addition
    wire notA;
    wire notB;
    wire notS;
    wire aAndB;
    wire notaAndNotb;
    wire negToPos;
    wire posToNeg;

    not aNot(notA, a);
    not bNot(notB, b);
    not sNot(notS, s);

    and andab(aAndB, a, b);
    and andabNot(notaAndNotb, notA, notB);

    and andSwitch1(negToPos, aAndB, notS); //if the most significant bit of a and b were both 0 and the most significant big of the sum was 1, the inputs were both positive and the outpus was negative
    and andSwitch2(posToNeg, notaAndNotb, s); // this is the same as the above line but from positive to negative

    or orGate(overflow, negToPos, posToNeg); 

endmodule

module Adder 
(
    output[31:0] result,
    output carryout,
    output overflow,
    input[31:0] operandA,
    input[31:0] operandB
);
    wire[32:0] carryOut; // one larger to accomodate for the initial carry in
    assign carryOut[0] = 0;

    generate
        genvar i;
        for (i=0; i<32; i=i+1)
        begin
            FullAdder1 FullAdder (
                .carryout (carryOut[i+1]),
                .a (operandA[i]),
                .b (operandB[i]),
                .carryin (carryOut[i]),
                .res (result[i])
            );
        end
    endgenerate

    didOverflow1 overflowCalc( // looks at most significant bit and checks if it will overflow
        .overflow (overflow),
        .a (operandA[31]),
        .b (operandB[31]),
        .s (result[31])
    );
endmodule