`timescale 1ns / 1ps

module alu(
    input clk, rst,
    input [31:0] aluin1, aluin2,
    input [2:0] operation, opselect,
    input [4:0] shift_number,
    input enable_arith, enable_shift,
    
    output reg [31:0] aluout, 
    output reg carry
    );
    
    reg h_carry;
    reg [15:0] h_add;
    
always @(posedge clk or posedge rst) begin
    if (rst) begin
        aluout <= 0;
        carry <= 0;
    end
    
    else begin
        if (enable_shift == 1) begin
        
            // Shift Left Logical
            if (operation[1:0] == 2'b00) begin
                aluout <= (aluin1 << shift_number);
                carry <= 0;
            end
            
            // Shift Left Arithmetic
            else if (operation[1:0] == 2'b01) begin
                aluout <= (aluin1 << shift_number);
                if (aluin1[31] == 1) carry <= 1;
                else carry <= 0;
            end
            
            // Shift Right Logical
            else if (operation[1:0] == 2'b10) begin
                aluout <= (aluin1 >> shift_number);
                carry <= 0;

            end
            
            // Shift Right Arithmetic
            else if (operation[1:0] == 2'b11) begin
                aluout <= ($signed(aluin1) >>> shift_number);
                carry <= 0;
            end
            
        end
        
        else if (enable_arith == 1) begin
        
            // ADD
            if (opselect == 3'b001 && operation == 3'b000) {carry, aluout} <= aluin1 + aluin2; 
            
            // HADD
            else if (opselect == 3'b001 && operation == 3'b001) begin
                {h_carry, h_add} = aluin1[15:0] + aluin2[15:0];
                aluout <= {{16{h_add[15]}}, h_add};
                carry <= h_carry;
            end
            
            // SUB
            else if (opselect == 3'b001 && operation == 3'b010) {carry, aluout} <= aluin1 - aluin2;
            
            // NOT
            else if (opselect == 3'b001 && operation == 3'b011) begin
                aluout <= ~aluin2;
                carry <= 0;
            end
            
            // AND
            else if (opselect == 3'b001 && operation == 3'b100) begin
                aluout <= aluin1 & aluin2;
                carry <= 0;
            end
            
            // OR
            else if (opselect == 3'b001 && operation == 3'b101) begin
                aluout <= aluin1 | aluin2;
                carry <= 0;
            end
            
            // XOR
            else if (opselect == 3'b001 && operation == 3'b110) begin
                aluout <= aluin1 ^ aluin2;
                carry <= 0;
            end
            
            // LHG
            else if (opselect == 3'b001 && operation == 3'b111) begin
                aluout[31:16] <= aluin2[15:0];
                aluout[15:0] <= 16'h0;
                carry <= 0;
            end
            
            // LOADBYTE
            else if (opselect == 3'b101 && operation == 3'b000) begin
                aluout[7:0] <= aluin2[7:0];
                aluout[31:8] <= {24{aluin2[7]}};
                carry <= 0;            
            end
            
            // LOADBYTEU
            else if (opselect == 3'b101 && operation == 3'b100) begin
                aluout[7:0] <= aluin2[7:0];
                aluout[31:8] <= 0;
                carry <= 0;            
            end
            
            // LOADHALF
            else if (opselect == 3'b101 && operation == 3'b001) begin
                aluout[15:0] <= aluin2[15:0];
                aluout[31:16] <= {16{aluin2[15]}};
                carry <= 0;            
            end
            
            // LOADHALFU
            else if (opselect == 3'b101 && operation == 3'b101) begin
                aluout[15:0] <= aluin2[15:0];
                aluout[31:16] <= 0;
                carry <= 0;            
            end
            
            // LOADWORD
            else if (opselect == 3'b101 && operation == 3'b011) begin
                aluout <= aluin2;
                carry <= 0;            
            end
            
            // OTHERS
            else if (opselect == 3'b101) begin
                aluout <= aluin2;
                carry <= 0;            
            end
            
        end
    end
end
    
endmodule
