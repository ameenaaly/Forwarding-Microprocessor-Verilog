//register module with clock in and out with parameter
//at positive edge of clock in becomes out and must initialize ot 0

module Regbuffer #(parameter WIDTH = 32) (

input wire clk,
input wire [WIDTH-1:0] in,
output wire [WIDTH-1:0] out
);

reg [WIDTH-1:0] Reg = 0;

always @(posedge clk) begin
    Reg <= in;
end

assign out = Reg;

endmodule
