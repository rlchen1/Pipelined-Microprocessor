`timescale 1ns / 1ps

module ALU(
    input [31:0] a,  
    input [31:0] b, 
    input [3:0] alu_control,
    output zero, 
    output reg [31:0] alu_result);  
    
 always @(*)
 begin   
      case(alu_control)  
      4'b0000: alu_result = a & b; // and, andi 
      4'b0001: alu_result = a | b; // or   
      4'b0010: alu_result = a + b; // add, addi, lw, sw
      4'b0100: alu_result = a ^ b; // xor
      4'b0101: alu_result = a * b; // mult 
      4'b0110: alu_result = a - b; // sub, beq
      4'b0111: alu_result = (a < b) ? 1'b1 : 1'b0;  //set if less than (slt), 1 if true, 0 if false
      4'b1000: alu_result = a << b[10:6];  // shift left logical (sll)
      4'b1001: alu_result = a >> b[10:6];  // shift right logical (srl)
      4'b1010: alu_result = $signed(a) >>> b[10:6]; // arithmetic shift right(signed, sra)
      4'b1011: alu_result = a / b;   // div
      4'b1100: alu_result = ~(a | b);// nor (0 nor 0 --> ffffffff)
 
      default: alu_result = a + b; // add  
      endcase  
 end  
 assign zero = (alu_result==32'd0) ? 1'b1: 1'b0;

endmodule
