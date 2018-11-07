`timescale 1 ns / 1 ps

module memoryReg
#(
    parameter addresswidth  = 12,
    parameter depth         = 4096,
    parameter width         = 32
)
(
    input 		                clk,
    output [width-1:0]          dataOutRW, dataOutRead,
    input [addresswidth-1:0]    addressRW, addressRead, addressWrite,
    input                       writeEnableRW, writeEnableWrite,
    input [width-1:0]           dataInRW, dataInWrite
);


    reg [width-1:0] memory [depth-1:0];

    always @(posedge clk) begin
        if(writeEnableRW)
            memory[addressRW] <= dataInRW;
        if(writeEnableWrite)
            memory[addressWrite] <= dataInWrite;
    end

    assign dataOutRW = memory[addressRW];
    assign dataOutRead = memory[addressRead];

endmodule