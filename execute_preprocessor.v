`timescale 1ns / 1ps

module execute_preprocessor(
input clk, rst, enable_ex,
input [31:0] src1, src2, imm, mem_data_read_in,
input [6:0] control_in,

output reg [31:0] aluin1, aluin2,
output reg [2:0] operation_out, opselect_out,
output reg [4:0] shift_number,
output reg enable_arith, enable_shift,
output mem_data_wr_en, 
output [31:0] mem_data_write_out
    );
    
always @(posedge clk or posedge rst) begin
    if (rst) begin
        aluin1 <= 0;
        aluin2 <= 0;
        operation_out <= 0;
        opselect_out <= 0;
        shift_number <= 0;
        enable_arith <= 0;
        enable_shift <= 0;
    end
    
    else begin
        if (enable_ex) begin
        
            aluin1 <= src1;
            if (control_in[3] && (control_in[2:0] == 3'b001)) aluin2 <= imm;
            else if ((control_in[3] == 0) && (control_in[2:0] == 3'b001)) aluin2 <= src2;
            else if (control_in[3] && (control_in[2:0] == 3'b101)) aluin2 <= mem_data_read_in;
            
            operation_out <= control_in[6:4];
            opselect_out <= control_in[2:0];
            
            if (control_in[2:0] == 3'b000 && imm[2] == 0) shift_number <= imm[10:6];
            else if (control_in[2:0] == 3'b000 && imm[2] == 1) shift_number <= src2[4:0];
            else shift_number <= 0;
            
            if (control_in[2:0] == 3'b001) enable_arith <= 1'b1; // Irrespective of control_in[3]
            else if (control_in[2:0] == 3'b101 && control_in[3] == 0) enable_arith <= 1'b0;
            else if (control_in[2:0] == 3'b101 && control_in[3] == 1) enable_arith <= 1'b1;
            else enable_arith <= 0;
            
            if (control_in[2:0] == 3'b000) enable_shift <= 1;
            else enable_shift <= 0;
            
        end
    end
end

assign mem_data_wr_en = (control_in[2:0] == 3'b100 && control_in[3] == 1);
assign mem_data_write_out = src2;

endmodule

