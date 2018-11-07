iverilog -o adder adder.t.v
iverilog -o alu alu.t.v
iverilog -o CPU CPU.t.v
iverilog -o memReg memReg.t.v
iverilog -o mux mux.t.v
iverilog -o regfile regfile.t.v
iverilog -o regWrLUT regWrLUT.t.v
iverilog -o signExtender signExtender.t.v

./adder
./alu
./memReg
./mux
./regfile
./regWrLUT
./signExtender
./CPU +mem_text_fn=myprog.text +dump_fn=divide.vcd

rm adder
rm alu
rm memReg
rm mux
rm regfile
rm regWrLUT
rm signExtender
rm CPU