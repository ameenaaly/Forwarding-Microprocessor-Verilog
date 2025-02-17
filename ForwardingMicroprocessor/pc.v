module PC(clk, in, out);

input wire clk;
input wire [31:0] in;

output wire [31:0] out;

reg [31:0] pc = 0;

always @(posedge clk)
    pc <= in;

assign out = pc;

endmodule
