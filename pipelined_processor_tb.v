`timescale 1ns / 1ps

module pipelined_processor_tb();

reg clk, rst, enable_ex;
reg [31:0] src1, src2, imm, mem_data_read_in;
reg [6:0] control_in;

wire [31:0] aluout;
wire carry;
wire mem_data_wr_en;
wire [31:0] mem_data_write_out;

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
    .carry(carry),
    .mem_data_write_out(mem_data_write_out),
    .mem_data_wr_en(mem_data_wr_en)
);

initial clk = 0;
always #5 clk = ~clk;

// aluin1 is always src1.
// aluin2 is src2 when we have arith_logic as opselect and control_in[3] = 0.
// aluin2 is imm when we have arith_logic as opselect and control_in[3] = 1.
// aluin2 is mem_data_read_in when we have mem_read as opselect and control_in[3] = 1.
// operation = control_in[6:4]
// opselect = control_in[2:0]

initial begin

    // reset and initialise everything to 0
    rst = 1;
    enable_ex = 0;
    src1 = 0;
    src2 = 0;
    imm = 0;
    mem_data_read_in = 0;
    control_in = 0;
    
    // When reset is off but we also havent enabled it
    #10;
    rst = 0;
    enable_ex = 0;
    
    #10;
    enable_ex = 1;
    
    
    
    // Arithmetic operations: 
    
    // ADD operation: adds src1 and src2
    #10;
    src1 = 32'd20;
    src2 = 32'd30;
    control_in = 7'b0000001;
    
    // HADD operation1: does half addition of src1 and src2
    #10;
    src1 = 32'b00000000000000001010110010101110;
    src2 = 32'b00000000000000000010101010101011;
    control_in = 7'b0010001;
    
    // HADD operation2: does half addition of src1 and src2: the upper bits dont affect, 
    // also depicts sign extension
    #10;
    src1 = 32'b01001000000000000010110010101110;
    src2 = 32'b00010000001001000010101010101011;
    control_in = 7'b0010001;
    
     // HADD operation1: does half addition of src1 and src2, depicts carry = 1
    #10;
    src1 = 32'h0000FFFF;
    src2 = 32'h00000001;
    control_in = 7'b0010001;   
    
    // SUB operation: does src1 - src2
    #10;
    src1 = 32'd81;
    src2 = 32'd27;
    control_in = 7'b0100001;
    
    // NOT operation: does bitwise inversion of src2 (control_in[3] = 0 and we have arith)
    #10;
    src2 = 32'd24;
    control_in = 7'b0110001;
    
    // AND operation: does bitwise AND of src1(aluin1) and src2 (aluin2) bec control_in[3] = 0
    #10;
    control_in = 7'b1000001;
    src1 = 32'b1010101001010100010101010101000;
    src2 = 32'b0101001010101001101001010000101;
    
    // OR operation: does bitwise OR of src1(aluin1) and src2 (aluin2) bec control_in[3] = 0
    #10;
    control_in = 7'b1010001;
    src1 = 32'b1010101001010100010101010101000;
    src2 = 32'b0101001010101001101001010000101;
    
    // XOR operation: does bitwise XOR of src1(aluin1) and src2 (aluin2) bec control_in[3] = 0
    #10;
    control_in = 7'b1100001;
    src1 = 32'b1010101001010100010101010101000;
    src2 = 32'b0101001010101001101001010000101;
    
    // LHG operation: loads the lower 16 bits of aluin2 ie src2 to upper bits of aluout and lower bits remain 0.
    #10;
    control_in = 7'b1110001;
    src2 = 32'd24;
    
    
    
    // SHIFT operations: the in port of shift alu is connected to aluin1 (src1)
    // shift_amt = imm[10:6] if imm[2] = 0: immediate shift mode (fixed shift)
    // shift_amt = src2[4:0] if imm[2] = 1: register shift mode (variable shift)
    // opselect for shift = control_in[2:0] = 3'b000
    
    
    // IMMEDIATE SHIFTS: imm[2] = 0
    // shift left logical
    #10;
    src1 = 32'd8;
    imm = 32'b00000000000000000000000101000000;
    // imm[10:6] = 5
    control_in = 7'b0000000;  
    
    // shift left arithmetic when aluin[31] = 0 (carry should remain 0)
    #10;
    imm = 32'b00000000000000000000000101000000;
    control_in = 7'b0010000;    
    
    // shift left arithmetic when aluin1[31] = 1 (carry should also get 1)
    #10;
    src1 = -32'd8;
    imm = 32'b00000000000000000000000101000000;
    control_in = 7'b0010000;
    
    // shift right logical (no sign preservation): with positive number
    #10;
    src1 = 32'd32;
    imm = 32'b00000000000000000000000101000000;
    control_in = 7'b0100000;
    
    // shift right logical (no sign preservation): with negative number
    #10;
    src1 = -32'd32;
    imm = 32'b00000000000000000000000101000000;
    control_in = 7'b0100000;
    
    // shift right arithmetic (sign preservation): when the source number to be shifted is positive
    #10;
    src1 = 32'd32;
    imm = 32'b00000000000000000000000101000000;
    control_in = 7'b0110000;
    
    // shift right arithmetic (sign preservation): when the source number to be shifted is negative
    #10;
    src1 = -32'd32;
    imm = 32'b00000000000000000000000101000000;
    control_in = 7'b0110000;
    
    
    
    // Register shifts: imm[2] = 1
    // opselect = shift_reg = 3'b000
    // shift_number = src2[4:0]
    
    // logical shift left
    #10;
    imm = 32'd4;
    src1 = 32'd32;
    src2 = 32'd5;
    control_in = 7'b0000000;
    
    // arithmetic shift left
    #10;
    imm = 32'd4;
    src1 = 32'd32;
    src2 = 32'd5;
    control_in = 7'b0010000;
    
    // arithmetic shift left: to ensure carry goes 1
    #10;
    imm = 32'd4;
    src1 = -32'd32;
    src2 = 32'd5;
    control_in = 7'b0010000;
    
    // logical shift right
    #10;
    imm = 32'd4;
    src1 = 32'd32;
    src2 = 32'd5;
    control_in = 7'b0100000;
    
    // logical shift right to ensure sign does not get preserved
    #10;
    imm = 32'd4;
    src1 = -32'd32;
    src2 = 32'd5;
    control_in = 7'b0100000;
    
    // arithmetic shift right
    #10;
    imm = 32'd4;
    src1 = 32'd32;
    src2 = 32'd5;
    control_in = 7'b0110000;
    
    // arithmetic shift right to ensure sign extension happens
    #10;
    imm = 32'd4;
    src1 = -32'd32;
    src2 = 32'd5;
    control_in = 7'b0110000;
    
    #10;
    src1 = 0;
    src2 = 0;
    
    
    
    // Memory read operations:
    // opselect = mem_read = control_in[2:0] = 3'b101
    // aluin2 = mem_data_read_in if control_in[3] = 1, else no change
    // carry  = 0 for all
    
    // loadbyte 
    #10;
    mem_data_read_in = 32'd555;
    control_in = 7'b0001101;
    
    // loadbyte to ensure sign extension happens
    #10;
    mem_data_read_in = -32'd555;
    control_in = 7'b0001101;
    
    // loadbyte unsigned
    #10;
    mem_data_read_in = 32'd555;
    control_in = 7'b1001101;
    
    // loadbyte unsigned to ensure sign extension doesnt happen
    #10;
    mem_data_read_in = -32'd555;
    control_in = 7'b1001101;
    
    // loadhalf
    #10;
    mem_data_read_in = 32'd555;
    control_in = 7'b0011101;
    
    // loadhalf to ensure sign extension happens
    #10;
    mem_data_read_in = -32'd555;
    control_in = 7'b0011101;
    
    // loadhalf unsigned
    #10;
    mem_data_read_in = 32'd555;
    control_in = 7'b1011101;
    
    // loadhalf unsigned to ensure sign extension doesnt happen
    #10;
    mem_data_read_in = -32'd555;
    control_in = 7'b1011101;
    
    // loadword 
    #10;
    mem_data_read_in = 32'd555;
    control_in = 7'b0111101;
    
    // loadword testing with negative number
    #10;
    mem_data_read_in = -32'd555;
    control_in = 7'b0111101; 
    
    
    
    // memory write operations
    // they dont go through the alu stage, hence no aluout corrsponding to mem write
    // their output comes in execute preprocessor stage only
    // the corresponding outputs are mem_data_wr_en and mem_data_write_out
    // they are combinational outputs so we get the result in the same clk cycle itself, unlike others
    // mem_data_write_out = src2
    // mem_data_wr_en = 1 when opselect is mem_write && conntrol_in[3] = 1, else its is 0
    // opselect = 3'b100
    
    #10;
    src2 = 32;          
    // mem_data_write_out = src2
    control_in = 7'b0001100;
    // now control_in[3] = 1, and opselect = mem_write, so mem_wr_en should go high.
    
    // in the following cases, mem_wr_en should not go high:
    // the top 3 bits in control_in dont matter so I took them arbitrarily
    // 1) control_in[3] = 0 but opselect = mem_write:
    #10;
    control_in = 7'b0100100;
    
    // 2) control_in[3] = 0 and opselect != mem_write:
    #10;
    control_in = 7'b1000001;
    
    // 3) control_in[3] = 1 but opselect != mem_write:
    #10;
    control_in = 7'b0011010;
    
#20;
$finish;

end

endmodule
