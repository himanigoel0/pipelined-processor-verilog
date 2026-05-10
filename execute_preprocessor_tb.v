`timescale 1ns / 1ps

module execute_preprocessor_tb();

reg clk, rst, enable_ex;
reg [31:0] src1, src2, imm, mem_data_read_in;
reg [6:0] control_in;

wire [31:0] aluin1, aluin2;
wire [2:0] operation_out, opselect_out;
wire [4:0] shift_number;
wire enable_arith, enable_shift;
wire mem_data_wr_en;
wire [31:0] mem_data_write_out;

execute_preprocessor uut (
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
    .operation_out(operation_out),
    .opselect_out(opselect_out),
    .shift_number(shift_number),
    .enable_arith(enable_arith),
    .enable_shift(enable_shift),
    .mem_data_wr_en(mem_data_wr_en),
    .mem_data_write_out(mem_data_write_out)
);

initial clk = 0;
always #5 clk = ~clk;

initial begin

    rst = 1;
    enable_ex = 0;
    src1 = 0;
    src2 = 0;
    imm = 0;
    control_in = 0;
    mem_data_read_in = 0;
    
    
    // Arithmetic Corners testing: opselect is control_in[2:0] == 3'b001 for all
    
    // ADD
    #10;
    rst = 0;
    enable_ex = 1;
    src1 = 32'd10;
    src2 = 32'd20;
    imm  = 32'd50;
    control_in = 7'b0000001;
    
    // HADD
    #10;
    src1 = 32'd10;
    src2 = 32'd20;
    imm  = 32'd50;
    control_in = 7'b0010001;
    
    // SUB
    #10;
    src1 = 32'd10;
    src2 = 32'd20;
    imm  = 32'd50;
    control_in = 7'b0100001;
    
    // NOT
    #10;
    src1 = 32'd10;
    src2 = 32'd20;
    imm  = 32'd50;
    control_in = 7'b0110001;
    
    // AND
    #10;
    src1 = 32'd10;
    src2 = 32'd20;
    imm  = 32'd50;
    control_in = 7'b1000001;
    
    // OR
    #10;
    src1 = 32'd10;
    src2 = 32'd20;
    imm  = 32'd50;
    control_in = 7'b1010001;
    
    // XOR
    #10;
    src1 = 32'd10;
    src2 = 32'd20;
    imm  = 32'd50;
    control_in = 7'b1100001;
    
    // LHG
    #10;
    src1 = 32'd10;
    src2 = 32'd20;
    imm  = 32'd50;
    control_in = 7'b1110001;
    
    
    
    // Shift corners testing: opselect is control_in[2:0] == 3'b000 for all
    
    // Immediate shift: shift_number = imm[10:6]
    #10;
    src1 = 32'd8;
    src2 = 32'd0;
    control_in = 7'b0000000;
    imm = 32'b00000000000000000000000101000000;
    // imm[2] = 0
    // imm[10:6] = 00101 = 5
    
    // Variable shift: shift_number = src2[4:0]
    #10;
    src1 = 32'd8;
    src2 = 32'd15;
    control_in = 7'b0000000;
    imm = 32'b00000000000000000000000000000100;
    // imm[2] = 1
    // src2[4:0] = 15
    
    
    
    // Memory Read operations: control_in[2:0] = 3'b101, control_in[3] = 1
    
    #10;
    src1 = 32'd100;
    src2 = 32'd200;
    mem_data_read_in = 32'd555;
    imm = 32'd0;
    control_in = 7'b0001101;
    // aluin2 should get mem_data_read_in
    // enable_arith becomes 1
    
    
    
    // Memory Write operation: control_in[2:0] = 3'b100, control_in[3] = 1
    
    #10;
    src1 = 32'd111;
    src2 = 32'd999;
    imm = 32'd0;
    mem_data_read_in = 32'd0;
    control_in = 7'b0001100;
    // write-enable becomes 1
    // data sent to memory equals src2 (mem_data_write_out = src2)
    
    
    // enable_ex disabled
    #10;
    enable_ex = 0;
    src1 = 32'd999;
    control_in = 7'b1110001;
    // This checks pipeline stalling behavior. Outputs should NOT update.
    
    
#20;
$finish;

end

endmodule
