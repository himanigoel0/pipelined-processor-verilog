`timescale 1ns / 1ps

module pipelined_processor(
    input clk, rst, enable_ex,
    input [31:0] src1, src2, imm, mem_data_read_in,
    input [6:0] control_in,
    
    output carry,
    output [31:0] aluout,
    output mem_data_wr_en,
    output [31:0] mem_data_write_out
    );
    
    wire [31:0] aluin1, aluin2;
    wire [2:0] operation_out, opselect_out;
    wire [4:0] shift_number;
    wire enable_shift, enable_arith;
    
execute_preprocessor stage1 (
    .clk(clk),
    .rst(rst),
    .enable_ex(enable_ex),
    .src1(src1),
    .src2(src2),
    .imm(imm),
    .control_in(control_in),
    .mem_data_read_in(mem_data_read_in),
    .aluin1(aluin1),
    .aluin2(aluin2),
    .shift_number(shift_number),
    .operation_out(operation_out),
    .opselect_out(opselect_out),
    .enable_arith(enable_arith),
    .enable_shift(enable_shift),
    .mem_data_wr_en(mem_data_wr_en),
    .mem_data_write_out(mem_data_write_out)
);

alu stage2 (
    .clk(clk),
    .rst(rst),
    .aluin1(aluin1),
    .aluin2(aluin2),
    .operation(operation_out),
    .opselect(opselect_out),
    .shift_number(shift_number),
    .enable_arith(enable_arith),
    .enable_shift(enable_shift),
    .aluout(aluout),
    .carry(carry)
);

endmodule
