`timescale 1ns/1ps
`default_nettype none

module WB_tb;

    reg [31:0] ALU_result_in, mem_result_in, PC_plus_4_in;
    reg [1:0]  resultSrc_in;
    reg        regWrite_in;
    reg [4:0]  rd_in;

    wire [31:0] WB_result_out;
    wire regWrite_out;
    wire [4:0] rd_out;

    wb_stage uut (
        .ALU_result_in(ALU_result_in),
        .mem_result_in(mem_result_in),
        .PC_plus_4_in(PC_plus_4_in),
        .resultSrc_in(resultSrc_in),
        .regWrite_in(regWrite_in),
        .rd_in(rd_in),
        .WB_result_out(WB_result_out),
        .regWrite_out(regWrite_out),
        .rd_out(rd_out)
    );

    initial begin
        $dumpfile("WB_tb.vcd");
        $dumpvars(0, WB_tb);

        ALU_result_in = 32'd111;
        mem_result_in = 32'd222;
        PC_plus_4_in  = 32'd333;
        regWrite_in   = 1'b1;
        rd_in         = 5'd7;

        resultSrc_in = 2'b00;
        #1 $display("ALU select   -> %d (expected 111)", WB_result_out);

        resultSrc_in = 2'b01;
        #1 $display("MEM select   -> %d (expected 222)", WB_result_out);

        resultSrc_in = 2'b10;
        #1 $display("PC+4 select  -> %d (expected 333)", WB_result_out);

        resultSrc_in = 2'b11;
        #1 $display("Default      -> %d (expected 0)", WB_result_out);

        $display("WB pass-through rd=%0d regWrite=%b", rd_out, regWrite_out);
        $finish;
    end

endmodule