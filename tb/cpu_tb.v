`timescale 1ns/1ps
`default_nettype none

module cpu_tb;

    reg clk, rst;
    wire [31:0] PC;
    wire [31:0] instruction;
    wire [31:0] WB_result;

    cpu uut (
        .clk(clk),
        .rst(rst),
        .PC_fetch_out(PC),
        .instr_fetch_out(instruction),
        .WB_result_out(WB_result)
    );

    always #5 clk = ~clk;

    initial begin
        $dumpfile("cpu_tb.vcd");
        $dumpvars(0, cpu_tb);

        clk = 0;
        rst = 1;
        #10 rst = 0;

        repeat (100) begin
            @(posedge clk);
            $display("Time=%0t | PC=%h | Instr=%h | WB=%d",
                     $time, PC, instruction, WB_result);
        end

        $finish;
    end

endmodule