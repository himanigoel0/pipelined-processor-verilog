`timescale 1ns / 1ps

module alu_tb();

reg clk, rst;
reg signed [31:0] aluin1, aluin2;
reg [2:0] operation, opselect;
reg [4:0] shift_number;
reg enable_arith, enable_shift;

wire signed [31:0] aluout;
wire carry;

alu uut (
    .clk(clk),
    .rst(rst),
    .aluin1(aluin1),
    .aluin2(aluin2),
    .operation(operation),
    .opselect(opselect),
    .shift_number(shift_number),
    .enable_arith(enable_arith),
    .enable_shift(enable_shift),
    .aluout(aluout),
    .carry(carry)
);

initial clk = 0;
always #5 clk = ~clk;

initial begin

    rst = 1;
    aluin1 = 0;
    aluin2 = 0;
    operation = 0;
    opselect = 0;
    shift_number = 0;
    enable_arith = 0;
    enable_shift = 0;
    
    
    
    // Shift Operations: 
    
    // Shift Left Logical: operation[1:0] = 2'b00
    #10;
    rst = 0;
    shift_number = 5'd4;
    enable_arith = 0;
    enable_shift = 1;
    operation = 3'b000;
    aluin1 = 32'b10110100110010101010101010010111;
    
    // Shift Left Arithmetic: operation[1:0] = 2'b01, aluin1[31] = 1:
    #10;
    shift_number = 5'd4;
    enable_arith = 0;
    enable_shift = 1;
    operation = 3'b001;
    aluin1 = 32'b10110100110010110010101010011011;
    
    // Shift Left Arithmetic: operation[1:0] = 2'b01, aluin1[31] = 0:
    #10;
    shift_number = 5'd4;
    enable_arith = 0;
    enable_shift = 1;
    operation = 3'b001;
    aluin1 = 32'b00110100110010110010101010011011;
    
    // Shift Right Logical: operation[1:0] = 2'b10
    #10;
    shift_number = 5'd4;
    enable_arith = 0;
    enable_shift = 1;
    operation = 3'b010;
    aluin1 = 32'b10110100010011101010101001110111;
    
    // Shift Right Arithmetic: operation[1:0] = 2'b11: aluin1[31] = 1:
    #10;
    shift_number = 5'd4;
    enable_arith = 0;
    enable_shift = 1;
    operation = 3'b011;
    aluin1 = 32'b10110100110010110010101010011011;
    
    // Shift Right Arithmetic: operation[1:0] = 2'b11: aluin1[31] = 0:
    #10;
    shift_number = 5'd4;
    enable_arith = 0;
    enable_shift = 1;
    operation = 3'b011;
    aluin1 = 32'b00110100110010110010101010011011;
    
    #10;
    enable_shift = 0;
    
    
    
    // Arithmetic Operations: opselect = 3'b001:
    
    // ADD Operation: 
    #10;
    shift_number = 0;
    enable_arith = 1;
    enable_shift = 0;
    opselect = 3'b001;
    operation = 3'b000;
    aluin1 = 32'd54;
    aluin2 = 32'd46;
    
    // ADD Operation with negative values: 
    #10;
    shift_number = 0;
    enable_arith = 1;
    enable_shift = 0;
    opselect = 3'b001;
    operation = 3'b000;
    aluin1 = 32'd54;
    aluin2 = -32'd46;
    
    // HADD Operation1: 
    #10;
    shift_number = 0;
    enable_arith = 1;
    enable_shift = 0;
    opselect = 3'b001;
    operation = 3'b001;
    aluin1 = 32'd54;
    aluin2 = 32'd46;
    
    // HADD Operation2: 
    #10;
    aluin1 = 32'b01010010100101011010111010101001;
    aluin2 = 32'b01010010100101011011101010101010;
    
    // HADD Operation3: 
    #10;
    aluin1 = 32'b01010010100101011011111010101001;
    aluin2 = 32'b01010010100101010011101010101010;
    
    // SUB Operation: 
    #10;
    shift_number = 0;
    enable_arith = 1;
    enable_shift = 0;
    opselect = 3'b001;
    operation = 3'b010;
    aluin1 = 32'd54;
    aluin2 = 32'd46;
    
    // NOT Operation: not of aluin2
    #10;
    shift_number = 0;
    enable_arith = 1;
    enable_shift = 0;
    opselect = 3'b001;
    operation = 3'b011;
    aluin1 = 32'd54;
    aluin2 = 32'd46;
    
    // AND Operation: 
    #10;
    shift_number = 0;
    enable_arith = 1;
    enable_shift = 0;
    opselect = 3'b001;
    operation = 3'b100;
    aluin1 = 32'd54;
    aluin2 = 32'd46;
    
    // OR Operation: 
    #10;
    shift_number = 0;
    enable_arith = 1;
    enable_shift = 0;
    opselect = 3'b001;
    operation = 3'b101;
    aluin1 = 32'd54;
    aluin2 = 32'd46;
    
    // XOR Operation: 
    #10;
    shift_number = 0;
    enable_arith = 1;
    enable_shift = 0;
    opselect = 3'b001;
    operation = 3'b110;
    aluin1 = 32'd54;
    aluin2 = 32'd46;
    
    // LHG Operation (load lower bits of aluin2 to high of aluout, carry = 0)
    #10;
    shift_number = 0;
    enable_arith = 1;
    enable_shift = 0;
    opselect = 3'b001;
    operation = 3'b111;
    aluin1 = 32'd54;
    aluin2 = 32'd46;
    
    
    
    // Mem_Read Operations: opselect = 3'b101: happens on aluin2
    
    // Loadbyte1: 
    #10;
    shift_number = 0;
    enable_arith = 1;
    enable_shift = 0;
    opselect = 3'b101;
    operation = 3'b000;
    aluin2 = 32'd46;
    
    // Loadbyte2: 
    #10;
    shift_number = 0;
    enable_arith = 1;
    enable_shift = 0;
    opselect = 3'b101;
    operation = 3'b000;
    aluin2 = 32'd196;
    
    // Loadbyteu1: 
    #10;
    shift_number = 0;
    enable_arith = 1;
    enable_shift = 0;
    opselect = 3'b101;
    operation = 3'b100;
    aluin2 = 32'd46;
    
    // Loadbyteu2: 
    #10;
    shift_number = 0;
    enable_arith = 1;
    enable_shift = 0;
    opselect = 3'b101;
    operation = 3'b100;
    aluin2 = 32'd196;
    
    // Loadhalf1: 
    #10;
    shift_number = 0;
    enable_arith = 1;
    enable_shift = 0;
    opselect = 3'b101;
    operation = 3'b001;
    aluin2 = 32'd46;
    
    // Loadhalf2: 
    #10;
    shift_number = 0;
    enable_arith = 1;
    enable_shift = 0;
    opselect = 3'b101;
    operation = 3'b001;
    aluin2 = 32'd32768;
    
    // Loadhalfu1: 
    #10;
    shift_number = 0;
    enable_arith = 1;
    enable_shift = 0;
    opselect = 3'b101;
    operation = 3'b101;
    aluin2 = 32'd46;
    
    // Loadhalfu2: 
    #10;
    shift_number = 0;
    enable_arith = 1;
    enable_shift = 0;
    opselect = 3'b101;
    operation = 3'b101;
    aluin2 = 32'd32768;
    
    // Loadword: 
    #10;
    shift_number = 0;
    enable_arith = 1;
    enable_shift = 0;
    opselect = 3'b101;
    operation = 3'b011;
    aluin2 = 32'd46;
    
    // Others: 
    #10;
    shift_number = 0;
    enable_arith = 1;
    enable_shift = 0;
    opselect = 3'b101;
    operation = 3'b010;
    aluin2 = 32'd46;
    
#20;
$finish;
        
end

endmodule

