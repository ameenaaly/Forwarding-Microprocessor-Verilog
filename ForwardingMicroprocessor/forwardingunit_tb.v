`timescale 1ns/1ns
`include "forwardingunit.v"

module forwardingunit_tb;
//module Forwardingunit (reg_write_xm, reg_write_mw, rd_register_xm, rd_register_mw, rs_register_dx, rt_register_dx, fwdctrl_rs, fwdctrl_rt);

    reg reg_write_xm, reg_write_mw;
    reg [4:0] rd_register_xm, rd_register_mw, rs_register_dx, rt_register_dx;
    
    wire [1:0] fwdctrl_rs, fwdctrl_rt;
   

    Forwardingunit forwardingunit (reg_write_xm, reg_write_mw, rd_register_xm, rd_register_mw, rs_register_dx, rt_register_dx, fwdctrl_rs, fwdctrl_rt);

    initial begin
        $dumpfile("forwardingunit.vcd");  
        $dumpvars(0, forwardingunit_tb);     
        //iintialization
        reg_write_xm = 0;
        reg_write_mw = 0;
        rd_register_xm = 5'd0;
        rd_register_mw = 5'd0;
        rs_register_dx = 5'd0;
        rt_register_dx = 5'd0;
        #10;

        // no hazards (default state: fwdctrl_rs and fwdctrl_rt should be 00)
        reg_write_xm = 0;
        reg_write_mw = 0;
        rs_register_dx = 5'd1;
        rt_register_dx = 5'd2;
        #10;
        
        // forward from xm stage to rs and rt operands (fwdctrl_rs should be 10 and fwdctrl_rt should be 10)
        reg_write_xm = 1;
        rd_register_xm = 5'd1;  
        rs_register_dx = 5'd1;
        rt_register_dx = 5'd1;
        #10;

        //forward from mw stage to rs and rt operanda (fwdctrl_rs and fwdctrl_rtshould be 01)
        reg_write_xm = 0;
        reg_write_mw = 1;
        rd_register_mw = 5'd3;  
        rs_register_dx = 5'd3;
        rt_register_dx = 5'd3;
        #10;

        $finish;
    end

endmodule
