module Pipe #(parameter WIDTH=32) (clk, in, out);

input wire clk;
input wire [WIDTH-1 : 0] in;
output reg [WIDTH-1 : 0] out = 0;

always @(posedge clk)
    out <= in;

endmodule
