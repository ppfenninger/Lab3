//Copied from HW4. Compiled all of the submodules into this file, as we won't use them
//in our top level CPU

//------------------------------------------------------------------------------
// MIPS register file
//   width: 32 bits
//   depth: 32 words (reg[0] is static zero register)
//   2 asynchronous read ports
//   1 synchronous, positive edge triggered write port
//------------------------------------------------------------------------------
`timescale 1 ns / 1 ps

module regfile
(
output[31:0]	ReadData1,	// Contents of first register read
output[31:0]	ReadData2,	// Contents of second register read
input[31:0]	WriteData,	// Contents to write to register
input[4:0]	ReadRegister1,	// Address of first register to read
input[4:0]	ReadRegister2,	// Address of second register to read
input[4:0]	WriteRegister,	// Address of register to write
input		wEnable,	// Enable writing of register when High
input		Clk		// Clock (Positive Edge Triggered)
);
	wire[31:0] decoder_out;
	wire[31:0] reg_out[31:0];

	decoder1to32 decoder(.out(decoder_out),.enable(wEnable),.address(WriteRegister));

	register32zero reg0(.d(WriteData),.q(reg_out[0]),.wrenable(decoder_out[0]),.clk(Clk));

	genvar i;
	generate
		for(i = 1; i < 32; i = i+1)
		begin:genblock
			register32 reg32( 
				.d(WriteData), 
				.q(reg_out[i]), 
				.wrenable(decoder_out[i]),
				.clk(Clk));
		end
	endgenerate

	mux32to1by32 mux1(
		.out(ReadData1),
		.address(ReadRegister1),
		.input0( reg_out[0]),
		.input1( reg_out[1]),
		.input2( reg_out[2]),
		.input3( reg_out[3]),
		.input4( reg_out[4]),
		.input5( reg_out[5]),
		.input6( reg_out[6]),
		.input7( reg_out[7]),
		.input8( reg_out[8]),
		.input9( reg_out[9]),
		.input10(reg_out[10]),
		.input11(reg_out[11]),
		.input12(reg_out[12]),
		.input13(reg_out[13]),
		.input14(reg_out[14]),
		.input15(reg_out[15]),
		.input16(reg_out[16]),
		.input17(reg_out[17]),
		.input18(reg_out[18]),
		.input19(reg_out[19]),
		.input20(reg_out[20]),
		.input21(reg_out[21]),
		.input22(reg_out[22]),
		.input23(reg_out[23]),
		.input24(reg_out[24]),
		.input25(reg_out[25]),
		.input26(reg_out[26]),
		.input27(reg_out[27]),
		.input28(reg_out[28]),
		.input29(reg_out[29]),
		.input30(reg_out[30]),
		.input31(reg_out[31]));

	mux32to1by32 mux2(
		.out(ReadData2),
		.address(ReadRegister2),
		.input0( reg_out[0]),
		.input1( reg_out[1]),
		.input2( reg_out[2]),
		.input3( reg_out[3]),
		.input4( reg_out[4]),
		.input5( reg_out[5]),
		.input6( reg_out[6]),
		.input7( reg_out[7]),
		.input8( reg_out[8]),
		.input9( reg_out[9]),
		.input10(reg_out[10]),
		.input11(reg_out[11]),
		.input12(reg_out[12]),
		.input13(reg_out[13]),
		.input14(reg_out[14]),
		.input15(reg_out[15]),
		.input16(reg_out[16]),
		.input17(reg_out[17]),
		.input18(reg_out[18]),
		.input19(reg_out[19]),
		.input20(reg_out[20]),
		.input21(reg_out[21]),
		.input22(reg_out[22]),
		.input23(reg_out[23]),
		.input24(reg_out[24]),
		.input25(reg_out[25]),
		.input26(reg_out[26]),
		.input27(reg_out[27]),
		.input28(reg_out[28]),
		.input29(reg_out[29]),
		.input30(reg_out[30]),
		.input31(reg_out[31]));

endmodule

// 32 bit decoder with enable signal
//   enable=0: all output bits are 0
//   enable=1: out[address] is 1, all other outputs are 0
module decoder1to32
(
output[31:0]	out,
input		enable,
input[4:0]	address
);

    assign out = enable<<address; 

endmodule

module register32
(
output reg [31:0] q,
input      [31:0] d,
input       wrenable,
input       clk
);
	always @(posedge clk) begin
		if(wrenable) begin
			q[31:0] <= d[31:0];
		end // if(wrenable)
	end // always @(posedge clk)
endmodule

module register32zero
(
output reg [31:0] q,
input      [31:0] d,
input       wrenable,
input       clk
);
integer i;
	always @(posedge clk) begin
		q[31:0] <= 32'h00000000;
	end // always @(posedge clk)
endmodule

module mux32to1by1
(
output      out,
input[4:0]  address,
input[31:0] inputs
);
  assign out = inputs[address];
endmodule

module mux32to1by32
(
output[31:0]  out,
input[4:0]    address,
input[31:0]   input0, input1, input2, input3, input4, input5, input6, input7, input8, input9, input10, input11, input12, input13, input14, input15, input16, input17, input18, input19, input20, input21, input22, input23, input24, input25, input26, input27, input28, input29, input30, input31
);

  wire[31:0] mux[31:0];			// Create a 2D array of wires
  assign mux[0]  = input0;		// Connect the sources of the array
  assign mux[1]  = input1;
  assign mux[2]  = input2;
  assign mux[3]  = input3;
  assign mux[4]  = input4;
  assign mux[5]  = input5;
  assign mux[6]  = input6;
  assign mux[7]  = input7;
  assign mux[8]  = input8;
  assign mux[9]  = input9;
  assign mux[10] = input10;
  assign mux[11] = input11;
  assign mux[12] = input12;
  assign mux[13] = input13;
  assign mux[14] = input14;
  assign mux[15] = input15;
  assign mux[16] = input16;
  assign mux[17] = input17;
  assign mux[18] = input18;
  assign mux[19] = input19;
  assign mux[20] = input20;
  assign mux[21] = input21;
  assign mux[22] = input22;
  assign mux[23] = input23;
  assign mux[24] = input24;
  assign mux[25] = input25;
  assign mux[26] = input26;
  assign mux[27] = input27;
  assign mux[28] = input28;
  assign mux[29] = input29;
  assign mux[30] = input30;
  assign mux[31] = input31;
  assign out = mux[address];	// Connect the output of the array
endmodule

