`include "mux.v"
`define DELAY 500
`define WIDTH 32
`define HALFWIDTH 16

module testMux();
	reg[`WIDTH-1:0] a;
	reg[`WIDTH-1:0] b;
	reg            select;
	wire[`WIDTH-1:0] out;

	mux #(`WIDTH) dut(
		.input0(a),
		.input1(b),
		.sel(select),
		.out(out));

initial begin
	$display("Starting Mux Tests.");

	a = {`HALFWIDTH'b1111, `HALFWIDTH'b0};
	b = {`HALFWIDTH'b0, `HALFWIDTH'b1111};;
	select = 0;
	#`DELAY;
	if(out !== a)
		$display("Mux test failed; output != a when sel=0");

	select = 1;
	#`DELAY;
	if(out !== b)
		$display("Mux test failed; output != b when sel=1");

	$display("Mux tests finished!");
	$display();

end // initial
endmodule // testMux