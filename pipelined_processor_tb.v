`timescale 1ns / 1ps

module pipelined_processor_tb();

reg clk, rst, enable_ex;
reg [31:0] src1, src2, imm, mem_data_read_in;
reg [6:0] control_in;

wire [31:0] aluout;
wire carry;

pipelined_processor uut (
    .clk(clk),
    .rst(rst),
    .enable_ex(enable_ex),
    .src1(src1),
    .src2(src2),
    .imm(imm),
    .mem_data_read_in(mem_data_read_in),
    .control_in(control_in),
    .aluout(aluout),
    .carry(carry)
);

initial clk = 0;
always #5 clk = ~clk;

initial begin

    rst = 1;
    enable_ex = 0;
    src1 = 0;
    src2 = 0;
    imm = 0;
    mem_data_read_in = 0;
    control_in = 0;
    
    #10;
    rst = 0;
    enable_ex = 1;
    
    // ADD operation
    #10;
    src1 = 32'd20;
    src2 = 32'd30;
    control_in = 7'b0000001;
    
    // SHIFT operation
    #10;
    src1 = 32'd8;
    imm = 32'b00000000000000000000000101000000;
    control_in = 7'b0000000;    
    
    // LOADWORD / memory read
    #10;
    mem_data_read_in = 32'd555;
    control_in = 7'b0001101;
    
#20;
$finish;

end

endmodule
