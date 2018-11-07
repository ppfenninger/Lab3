`include "signExtender.v"
module signExtendTest();
	reg[15:0] initialValue;
	wire[31:0] signExtendedValue;

	signExtend extend(initialValue, signExtendedValue);

	initial begin
		$display("Starting Sign Extender Testing");
		initialValue = 16'b1100000000000000; #100
		if (signExtendedValue !== 32'b11111111111111111100000000000000) $display("Negative extension did not work - %b", signExtendedValue);
		initialValue = 16'b0000000000000001; #10
		if (signExtendedValue !== 32'b000000000000000000000000000001) $display("Positive extension did not work - %b", signExtendedValue);
		$display("Finished sign extender testing");
		$display();
	end
endmodule // signExtendTest