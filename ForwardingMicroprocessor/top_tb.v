`include "top.v"
`timescale 1 ns/1 ns

module top_tb();

  reg clk;

  Top top(clk);
 
  always @* begin
      #5 clk <= !clk;
  end

  initial begin
    $dumpfile("top.vcd");
    $dumpvars(0, top_tb);
    clk = 0;
    #180
    $finish;
  end

endmodule
