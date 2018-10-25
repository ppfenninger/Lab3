`include "CPU.v"

module regWrLUT
/*
LUT module to determine RegWr
Inputs:
opcode: The first 6 bits of the binary command, which partly determines which operation the CPU will perform
funct;  The last 6 bits of the binary command, which determines the res of the operation the CPU will perform

Outpus:
regwr: Whether to enable register write for this cycle
*/
(
output reg regwr,
input[5:0] opcode,
input[5:0] funct
);

always @(opcode or funct) begin
	case (opcode)
		`LW_OP:   regwr=1; //LW
		`SW_OP:   regwr=0; //SW
		`J_OP:    regwr=0; //J
		`JAL_OP:  regwr=1; //JAL
		`BEQ_OP:  regwr=0; //BEQ
		`BNE_OP:  regwr=0; //BNE
		`XORI_OP: regwr=1; //XORI
		`ADDI_OP: regwr=1; //ADDI

		`RTYPE_OP: begin
			case (funct)
				`JR_FUNCT:  regwr = 0; //JR
				`ADD_FUNCT: regwr = 1; //ADD
				`SUB_FUNCT: regwr = 1; //SUB
				`SLT_FUNCT: regwr = 1; //SLT
				default: $display("Error in regWrLUT: Invalid funct");
			endcase
		end

		default: $display("Error in regWrLUT: Invalid opcode");


	endcase
end
endmodule