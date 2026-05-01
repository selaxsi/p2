`timescale 1ns/1ps
`default_nettype none

module forwarding_tb;

    reg [4:0] rs1_ex, rs2_ex, rd_mem, rd_wb;
    reg       regWrite_mem, regWrite_wb;
    wire [1:0] forwardA, forwardB;

    forwarding uut(
        .rs1_ex(rs1_ex), .rs2_ex(rs2_ex),
        .rd_mem(rd_mem), .rd_wb(rd_wb),
        .regWrite_mem(regWrite_mem), .regWrite_wb(regWrite_wb),
        .forwardA(forwardA), .forwardB(forwardB)
    );

    initial begin
        $dumpfile("forwarding_tb.vcd");
        $dumpvars(0, forwarding_tb);

        // Test1: No Forwarding
        rs1_ex=5'd1; rs2_ex=5'd2; rd_mem=5'd3; rd_wb=5'd4;
        regWrite_mem=1; regWrite_wb=1;
        #5;
        $display("--- No forwarding ---");
        $display("forwardA=%b (expected 00) forwardB=%b (expected 00)", forwardA, forwardB);

        // Test2: EX-EX on A Forwarding 
        rs1_ex=5'd3; rs2_ex=5'd2; rd_mem=5'd3; rd_wb=5'd4;
        regWrite_mem=1; regWrite_wb=1;
        #5;
        $display("--- EX-EX forwarding A ---");
        $display("forwardA=%b (expected 10) forwardB=%b (expected 00)", forwardA, forwardB);

        // Test3: EX-EX on A Forwarding 
        rs1_ex=5'd1; rs2_ex=5'd3; rd_mem=5'd3; rd_wb=5'd4;
        regWrite_mem=1; regWrite_wb=1;
        #5;
        $display("--- EX-EX forwarding B ---");
        $display("forwardA=%b (expected 00) forwardB=%b (expected 10)", forwardA, forwardB);

        // Test4: MEM-EX on A Forwarding 
        rs1_ex=5'd4; rs2_ex=5'd2; rd_mem=5'd3; rd_wb=5'd4;
        regWrite_mem=1; regWrite_wb=1;
        #5;
        $display("--- MEM-EX forwarding A ---");
        $display("forwardA=%b (expected 01) forwardB=%b (expected 00)", forwardA, forwardB);

        // Test5: EX-EX priority over MEM-EX
        rs1_ex=5'd3; rs2_ex=5'd3; rd_mem=5'd3; rd_wb=5'd3;
        regWrite_mem=1; regWrite_wb=1;
        #5;
        $display("--- EX-EX priority over MEM-EX ---");
        $display("forwardA=%b (expected 10) forwardB=%b (expected 10)", forwardA, forwardB);

        // Test6: rd=0 no Forwarding 
        rs1_ex=5'd0; rs2_ex=5'd0; rd_mem=5'd0; rd_wb=5'd0;
        regWrite_mem=1; regWrite_wb=1;
        #5;
        $display("--- No forwarding to x0 ---");
        $display("forwardA=%b (expected 00) forwardB=%b (expected 00)", forwardA, forwardB);

        // Test7: regWrite=0 no Forwarding 
        rs1_ex=5'd3; rs2_ex=5'd3; rd_mem=5'd3; rd_wb=5'd3;
        regWrite_mem=0; regWrite_wb=0;
        #5;
        $display("--- No forwarding if regWrite=0 ---");
        $display("forwardA=%b (expected 00) forwardB=%b (expected 00)", forwardA, forwardB);

        $display("forwarding tests done.");
        $finish;
    end

endmodule