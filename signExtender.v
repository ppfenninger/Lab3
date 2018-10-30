module signExtend(
	input[15:0] extend,
	output reg[31:0] extended
);


// generate
// 	genvar i;
// 	for (i=16; i < 32; i=i+1) assign signExtendedValue[i] = 0;
// endgenerate

// always @(initialValue) begin
// assign signExtendedValue[15:0] = initialValue;


// if (initialValue[15]) assign signExtendedValue[31:16] = 16'b1111111111111111;
// else assign signExtendedValue[31:16] = 16'b0;
// end

always @(extend) begin
    extended[31:0] <= { {16{extend[15]}}, extend[15:0] };
end
endmodule // signExtend