`include "pc.v"
`include "imem.v"
`include "alu.v"
`include "regfile.v"
`include "dmem.v"
`include "alucontrol.v"
`include "control.v"
`include "mux.v"
`include "signextend.v"
`include "sll2.v"
`include "adder.v"
`include "regbuffer.v"
`include "forwardingunit.v"
`include "muxfwd.v"


module Top(clk);

input wire clk;

//---------------------------------
wire [31:0]pc_in;
wire [31:0]pc_out;
wire [31:0]pc_next;
wire [31:0]inst;
wire [27:0]jump_address_no_pc;
wire [31:0]jump_address;
wire reg_dst;
wire jump;
wire branch;
wire mem_read;
wire mem_to_reg;
wire [1:0]alu_op;
wire mem_write;
wire alu_src; 
wire reg_write;
wire [4:0]write_reg;
wire [31:0]write_data;
wire [31:0]rs_value;
wire [31:0]rt_value;
wire [31:0]immediate; 
wire [3:0]alu_cont;
wire [31:0]alu_second_in;
wire zero;
wire [31:0]alu_result;
wire [31:0]offset;
wire [31:0]br_alu_result;
wire  brach_select;
wire [31:0]branch_result;
wire [31:0] read_data;

wire [31:0] inst_buffer;
wire [31:0] pc_next_buffer1;
wire [31:0] pc_next_buffer2;
wire [4:0] rt_address;
wire [4:0] rd_address;
wire reg_dst_buffer;
//wire [4:0] write_reg;
wire [4:0] write_reg_buffer1;
wire [4:0] write_reg_buffer2;
wire reg_write_buffer3;
//wire reg_dst_buffer;
wire alu_src_buffer;
wire [1:0] alu_op_buffer;
wire branch_buffer1;
wire mem_read_buffer1;
wire mem_write_buffer1;
wire jump_buffer1;
wire reg_write_buffer1;
wire mem_to_reg_buffer1;
wire [31:0] rs_value_buffer;
wire [31:0] rt_value_buffer1;
wire [31:0] immediate_buffer;
wire [31:0] jump_address_buffer1;
wire branch_buffer2;
wire mem_read_buffer2;
wire mem_write_buffer2;
wire jump_buffer2;
wire reg_write_buffer2;
wire mem_to_reg_buffer2;
wire [31:0] br_alu_result_buffer;
wire zero_buffer;
wire [31:0] alu_result_buffer;
wire [31:0] rt_value_buffer2;
//wire [4:0] write_reg_buffer1;
wire [31:0] jump_address_buffer2;
//wire reg_write_buffer3;
wire mem_to_reg_buffer3;
wire [31:0] alu_result_buffer1;
wire [31:0] read_data_buffer;
//wire [4:0] write_reg_buffer2;

//lab 6 added wires
wire [4:0] rs_address;
wire [1:0] fwdctrl_rs, fwdctrl_rt;
wire [31:0] operand1, operand2;

//---------------------------------- fd=fetch/decode and dx=decode/execute and xm=execute/memory and mb=memory/back

PC pc(clk, pc_in, pc_out); 
Adder pc_adder(pc_out, 4, pc_next);
Imem imem(pc_out,inst);

//--------------------------------------------------------------IF/ID in
Regbuffer #(32) inst_fd(clk, inst, inst_buffer);
Regbuffer #(32) pc_fd(clk, pc_next, pc_next_buffer1);
//--------------------------------------------------------------IF/ID out

Sll2 #(26,28) shift_jump(inst_buffer[25:0],jump_address_no_pc); 
assign jump_address = {pc_next[31:28],jump_address_no_pc};
Control control(inst_buffer[31:26],reg_dst, jump, branch, mem_read, mem_to_reg, alu_op, mem_write, alu_src, reg_write);
Mux #(5) mux_write_reg(reg_dst_buffer, rt_address,rd_address, write_reg);
RegisterFile regfile(clk, inst_buffer[25:21], inst_buffer[20:16], write_reg_buffer2, write_data, reg_write_buffer3, rs_value, rt_value);
SignExtend signedextend(inst_buffer[15:0],immediate);

//--------------------------------------------------------------ID/EX in
Regbuffer #(1) reg_dst_dx(clk, reg_dst, reg_dst_buffer); //used in alu
Regbuffer #(1) alu_src_dx(clk, alu_src, alu_src_buffer); //used in alu
Regbuffer #(2) alu_op_dx(clk, alu_op, alu_op_buffer); //used in alu
Regbuffer #(1) branch_dx(clk, branch, branch_buffer1); //used in mem
Regbuffer #(1) mem_read_dx(clk, mem_read, mem_read_buffer1); //used in mem
Regbuffer #(1) mem_write_dx(clk, mem_write, mem_write_buffer1); //used in mem
Regbuffer #(1) jump_dx(clk, jump, jump_buffer1); //used in mem
Regbuffer #(1) reg_write_dx(clk, reg_write, reg_write_buffer1); //used in wb
Regbuffer #(1) mem_to_reg_dx(clk, mem_to_reg, mem_to_reg_buffer1); //used in wb
Regbuffer #(32) pc_dx(clk, pc_next_buffer1, pc_next_buffer2);
Regbuffer #(32) rs_value_dx(clk, rs_value, rs_value_buffer); 
Regbuffer #(32) rt_value_dx(clk, rt_value, rt_value_buffer1); 
Regbuffer #(32) immediate_dx(clk, immediate, immediate_buffer);
Regbuffer #(5) rs_address_dx(clk, inst_buffer[25:21], rs_address); //---
Regbuffer #(5) rt_address_dx(clk, inst_buffer[20:16], rt_address);
Regbuffer #(5) rd_address_dx(clk, inst_buffer[15:11], rd_address);
Regbuffer #(32) jump_address_dx(clk, jump_address, jump_address_buffer1);
//--------------------------------------------------------------ID/EX out

Mux mux_alu_select(alu_src_buffer, rt_value_buffer1,immediate_buffer,alu_second_in);
AluControl alu_control(alu_op_buffer, immediate_buffer[5:0], alu_cont);
//Forwardingunit forwardingunit (reg_write_xm, reg_write_mw, rd_register_xm, rd_register_mw, rs_register_dx, rt_register_dx, fwdctrl_rs, fwdctrl_rt);
Forwardingunit forwardunit(reg_write_buffer2, reg_write_buffer3, write_reg_buffer1, write_reg_buffer2, rs_address, rt_address, fwdctrl_rs, fwdctrl_rt);
//so when we feed mux we should: in1=aluoperand from regfile, in2=alu result from earlier run(write back value), in3 = prior alu result
//Muxfwd #(WIDTH) muxfwd (flag, in1, in2, in3, out);
Muxfwd #(32) select1(fwdctrl_rs, rs_value_buffer, write_data, alu_result_buffer, operand1);
Muxfwd #(32) select2(fwdctrl_rt, alu_second_in, write_data, alu_result_buffer, operand2);

Alu alu(alu_cont, operand1, operand2, alu_result, zero);
Sll2 shift_branch(immediate_buffer,offset);
Adder adder_branch(pc_next_buffer2,offset,br_alu_result);

//--------------------------------------------------------------EX/MEM in
Regbuffer #(1) branch_xm(clk, branch_buffer1, branch_buffer2); //used in mem
Regbuffer #(1) mem_read_xm(clk, mem_read_buffer1, mem_read_buffer2); //used in mem
Regbuffer #(1) mem_write_xm(clk, mem_write_buffer1, mem_write_buffer2); //used in mem
Regbuffer #(1) jump_xm(clk, jump_buffer1, jump_buffer2); //used in mem
Regbuffer #(1) reg_write_xm(clk, reg_write_buffer1, reg_write_buffer2); //used in wb
Regbuffer #(1) mem_to_reg_xm(clk, mem_to_reg_buffer1, mem_to_reg_buffer2); //used in wb
Regbuffer #(32) branch_address_xm(clk, br_alu_result, br_alu_result_buffer);
Regbuffer #(1) zero_xm(clk, zero, zero_buffer);
Regbuffer #(32) alu_result_xm(clk, alu_result, alu_result_buffer);
Regbuffer #(32) rt_value_xm(clk, rt_value_buffer1, rt_value_buffer2);
Regbuffer #(5) write_reg_xm(clk, write_reg, write_reg_buffer1);
Regbuffer #(32) jump_address_xm(clk, jump_address_buffer1, jump_address_buffer2);
//--------------------------------------------------------------EX/MEM out

assign branch_select = branch_buffer2 & zero_buffer; 
Mux mux_branch(branch_select, pc_next,br_alu_result_buffer,branch_result);
Mux mux_jump_or_branch(jump_buffer2, branch_result,jump_address_buffer2,pc_in);
Dmem data_mem(clk, alu_result_buffer,rt_value_buffer2, mem_read_buffer2, mem_write_buffer2, read_data);

//--------------------------------------------------------------MEM/WB in
Regbuffer #(1) reg_write_mb(clk, reg_write_buffer2, reg_write_buffer3); //used in wb
Regbuffer #(1) mem_to_reg_mb(clk, mem_to_reg_buffer2, mem_to_reg_buffer3); //used in wb
Regbuffer #(32) alu_result_mb(clk, alu_result_buffer, alu_result_buffer1);
Regbuffer #(32) read_data_mb(clk, read_data, read_data_buffer);
Regbuffer #(5) write_reg_mb(clk, write_reg_buffer1, write_reg_buffer2);
//--------------------------------------------------------------MEM/WB out

Mux mux_dmem(mem_to_reg_buffer3, alu_result_buffer1,read_data_buffer, write_data);

endmodule
