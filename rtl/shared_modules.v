module mux_2x1(a,b,s,f);

input [31:0] a, b;
input s;
output [31:0] f;

assign f = (s)? b : a;

endmodule


module adder(a,b,f);

input [31:0] a,b;
output [31:0] f;
assign f = a+b;

endmodule

module mux_3x1(a, b, c, s, f);
input [31:0] a, b, c;
input [1:0] s;
output [31:0] f;
assign f = (s == 2'b00)? a :
           (s == 2'b10)? b :
           c;
endmodule