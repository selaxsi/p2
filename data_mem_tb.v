`timescale 1ns/1ps
`default_nettype none

module data_mem_tb;

    reg clk;
    reg memRead, memWrite;
    reg [31:0] ALU_result, rs2_val;
    wire [31:0] mem_result;

    data_memory uut(
        .clk(clk),
        .memRead(memRead), .memWrite(memWrite),
        .ALU_result(ALU_result), .rs2_val(rs2_val),
        .mem_result(mem_result)
    );

    always #5 clk = ~clk;

    initial begin
        $dumpfile("data_mem_tb.vcd");
        $dumpvars(0, data_mem_tb);

        clk = 0;
        memRead = 0; memWrite = 0;
        ALU_result = 0; rs2_val = 0;

        // 1. write 42 to address 0
        @(negedge clk);
        memWrite  = 1;
        ALU_result = 32'h00000000;
        rs2_val   = 32'd42;
        @(posedge clk); #1;
        memWrite  = 0;
        $display("Write 42 to addr 0 done");

        // 2. read back from address 0
        memRead   = 1;
        ALU_result = 32'h00000000;
        #1;
        $display("Read addr 0  -> %d (expected 42)", mem_result);
        memRead = 0;

        // 3. write 99 to address 4
        @(negedge clk);
        memWrite  = 1;
        ALU_result = 32'h00000004;
        rs2_val   = 32'd99;
        @(posedge clk); #1;
        memWrite  = 0;
        $display("Write 99 to addr 4 done");

        // 4. read back from address 4
        memRead   = 1;
        ALU_result = 32'h00000004;
        #1;
        $display("Read addr 4  -> %d (expected 99)", mem_result);
        memRead = 0;

        // 5. read address that was never written
        memRead   = 1;
        ALU_result = 32'h00000008;
        #1;
        $display("Read addr 8  -> %d (expected 0)", mem_result);
        memRead = 0;

        // 6. no read no write -> result should be 0 
        memRead = 0; memWrite = 0;
        ALU_result = 32'h00000000;
        #1;
        $display("No op addr 0 -> %d (expected 0)", mem_result);

        $display("data_mem tests done.");
        $finish;
    end

endmodule