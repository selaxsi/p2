`timescale 1ns/1ps
`default_nettype none

module MEM_tb;

    reg clk, rst;
    reg memRead_in, memWrite_in, regWrite_in;
    reg [1:0] resultSrc_in;
    reg [4:0] rd_in;
    reg [31:0] ALU_result_in, rs2_val_in, PC_in;

    wire [31:0] ALU_result_out, mem_result_out, PC_plus_4_out;
    wire [1:0] resultSrc_out;
    wire regWrite_out;
    wire [4:0] rd_out;

    mem_stage uut (
        .clk(clk),
        .rst(rst),
        .memRead_in(memRead_in),
        .memWrite_in(memWrite_in),
        .regWrite_in(regWrite_in),
        .resultSrc_in(resultSrc_in),
        .rd_in(rd_in),
        .ALU_result_in(ALU_result_in),
        .rs2_val_in(rs2_val_in),
        .PC_in(PC_in),
        .ALU_result_out(ALU_result_out),
        .mem_result_out(mem_result_out),
        .PC_plus_4_out(PC_plus_4_out),
        .resultSrc_out(resultSrc_out),
        .regWrite_out(regWrite_out),
        .rd_out(rd_out)
    );

    always #5 clk = ~clk;

    initial begin
        $dumpfile("MEM_tb.vcd");
        $dumpvars(0, MEM_tb);

        clk = 0;
        rst = 1;

        memRead_in = 0;
        memWrite_in = 0;
        regWrite_in = 0;
        resultSrc_in = 2'b00;
        rd_in = 5'b0;
        ALU_result_in = 32'b0;
        rs2_val_in = 32'b0;
        PC_in = 32'b0;

        #12 rst = 0;

        @(negedge clk);
        memWrite_in = 1;
        memRead_in = 0;
        regWrite_in = 0;
        resultSrc_in = 2'b00;
        ALU_result_in = 32'h0000_0000;
        rs2_val_in = 32'd55;
        PC_in = 32'h0000_0100;
        rd_in = 5'd1;

        @(posedge clk);
        #1;
        memWrite_in = 0;
        $display("MEM write done | stored %d at addr 0", rs2_val_in);

        @(negedge clk);
        memRead_in = 1;
        memWrite_in = 0;
        regWrite_in = 1;
        resultSrc_in = 2'b01;
        ALU_result_in = 32'h0000_0000;
        rs2_val_in = 32'd0;
        PC_in = 32'h0000_0100;
        rd_in = 5'd2;

        @(posedge clk);
        #1;
        $display("MEM read  | mem_result_out = %d (expected 55)", mem_result_out);
        $display("PIPE OUT  | ALU=%h MEM=%h PC+4=%h resultSrc=%b regWrite=%b rd=%0d",
                 ALU_result_out, mem_result_out, PC_plus_4_out, resultSrc_out, regWrite_out, rd_out);

        @(negedge clk);
        memRead_in = 0;
        memWrite_in = 0;
        regWrite_in = 1;
        resultSrc_in = 2'b10;
        ALU_result_in = 32'h1234_5678;
        rs2_val_in = 32'h0;
        PC_in = 32'h0000_0200;
        rd_in = 5'd3;

        @(posedge clk);
        #1;
        $display("PC+4 test | PC_plus_4_out = %h (expected 00000204)", PC_plus_4_out);

        $display("MEM_tb done.");
        $finish;
    end

endmodule