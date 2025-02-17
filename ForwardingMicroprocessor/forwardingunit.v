/*check for only these conditions to detect hazards and forward 
(reg_write_xm && (rd_register_xm != 0) && (rd_register_xm == rs_register_dx))   fwdctrl_rs --> 10 (1st alu operand (rs) from prior ALU)
(reg_write_xm && (rd_register_xm != 0) && (rd_register_xm == rt_register_dx))   fwdctrl_rt --> 10 (2nd alu operand (rt) from prior ALU)

(reg_write_mw && (rd_register_mw != 0) && (rd_register_mw == rs_register_dx))   fwdctrl_rs --> 01 (1st alu operand (rs) from prior dmem for lw or earlier propagated alu result)
(reg_write_mw && (rd_register_mw != 0) && (rd_register_mw == rt_register_dx))   fwdctrl_rt --> 01 (2nd alu operand (rt) from prior dmem for lw or earlier propagated alu result)

if neither staisified then fwdctrls = 00

so when we feed mux we should: in1=aluoperand from regfile, in2=alu result from earlier run, in3 = prior alu result
*/
module Forwardingunit (reg_write_xm, reg_write_mw, rd_register_xm, rd_register_mw, rs_register_dx, rt_register_dx, fwdctrl_rs, fwdctrl_rt);
    input wire reg_write_xm, reg_write_mw;
    input wire [4:0] rd_register_mw, rd_register_xm, rs_register_dx, rt_register_dx;

    output reg [1:0] fwdctrl_rs, fwdctrl_rt;


    always @* begin
        fwdctrl_rs <= 0;
        fwdctrl_rt <= 0;

        if (reg_write_xm && (rd_register_xm != 0))begin
            if (rd_register_xm == rs_register_dx)
                fwdctrl_rs <= 2'b10;
            if (rd_register_xm == rt_register_dx)
                fwdctrl_rt <= 2'b10;
        end
        if (reg_write_mw && (rd_register_mw != 0))begin
            if (rd_register_mw == rs_register_dx)
                fwdctrl_rs <= 2'b01;
            if (rd_register_mw == rt_register_dx)
                fwdctrl_rt <= 2'b01;
        end

    end


endmodule
/*Forwarding unit receives regwrite 

In top module we have a mux for alu input 1 and alu input 2
Forwarding unit and 3 value multiplexers

Always @* begin 
Forward a
End
Always @* begin
Forward b
End
*/