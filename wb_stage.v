`default_nettype none

module wb_stage(
    input [31:0] ALU_result_in,
    input [31:0] mem_result_in,
    input [31:0] PC_plus_4_in,
    input [1:0]  resultSrc_in,

    input regWrite_in,
    input [4:0] rd_in,

    output [31:0] WB_result_out,
    output regWrite_out,
    output [4:0] rd_out
);

    assign WB_result_out = (resultSrc_in == 2'b00) ? ALU_result_in  :
                           (resultSrc_in == 2'b01) ? mem_result_in  :
                           (resultSrc_in == 2'b10) ? PC_plus_4_in   :
                           32'b0;

    assign regWrite_out = regWrite_in;
    assign rd_out       = rd_in;

endmodule