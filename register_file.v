`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/16/2020 04:05:23 PM
// Design Name: 
// Module Name: register_file
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module register_file(
    input clk, reset,  
    input reg_write_en,  
    input [4:0] reg_write_dest,  
    input [31:0] reg_write_data,
    input [4:0] reg_read_addr_1, 
    input [4:0] reg_read_addr_2,  
    output [31:0] reg_read_data_1,  
    output [31:0] reg_read_data_2 
    );
    
    reg [31:0] reg_array [31:0];  
  
    always @ (negedge clk ) begin  
           if(reset) begin  
                reg_array[0] <= 32'b0;  
                reg_array[1] <= 32'b01;  
                reg_array[2] <= 32'b0;
                reg_array[3] <= 32'b0;    
                reg_array[4] <= 32'b0;
                reg_array[5] <= 32'b0;
                reg_array[6] <= 32'b0;
                reg_array[7] <= 32'b0;
                reg_array[8] <= 32'b0; 
                reg_array[9] <= 32'b0;
                reg_array[10] <= 32'b0; 
//                reg_array[2] <= 32'b00001111110101110110111000010000; //0fd76e10  
//                reg_array[3] <= 32'b00001111110101110110111000010000; //0fd76e10    
//                reg_array[4] <= 32'b00010100001100110011111111111100; //14333ffc
//                reg_array[5] <= 32'b00110010000111111110110111001011; //321fedcb
//                reg_array[6] <= 32'b10000000000000000000000000000000; //80000000
//                reg_array[7] <= 32'b10010000000100101111110101100101; //9012fd65
//                reg_array[8] <= 32'b10101011110000000000001000110111; //abc00237  
//                reg_array[9] <= 32'b10110101010010111100000000110001; //b54bc031 
//                reg_array[10] <= 32'b11000001100001111010011000000110;//c187a606  
                reg_array[11] <= 32'b0;  
                reg_array[12] <= 32'b0;  
                reg_array[13] <= 32'b0;  
                reg_array[14] <= 32'b0;  
                reg_array[15] <= 32'b0;
                reg_array[16] <= 32'b0;    //r16 = final value, initialize as 0  
                reg_array[17] <= 32'b0100; //r17 (g) = 4
                reg_array[18] <= 32'b011;  //r18 (h) = 3
                reg_array[19] <= 32'b010;  //r19 (i) = 2
                reg_array[20] <= 32'b01;   //r20 (j) = 1
                reg_array[21] <= 32'b0100; //r21 (k) = 4
                reg_array[22] <= 32'b0;  
                reg_array[23] <= 32'b0;  
                reg_array[24] <= 32'b0;  
                reg_array[25] <= 32'b0;  
                reg_array[26] <= 32'b0;  
                reg_array[27] <= 32'b0; 
                reg_array[28] <= 32'b0;  
                reg_array[29] <= 32'b0;  
                reg_array[30] <= 32'b0;  
                reg_array[31] <= 32'b0;     
           end  
           else begin  
                if(reg_write_en) begin  
                     reg_array[reg_write_dest] <= reg_write_data;  
                end  
           end  
      end  
      assign reg_read_data_1 = ( reg_read_addr_1 == 0)? 32'b0 : reg_array[reg_read_addr_1];  
      assign reg_read_data_2 = ( reg_read_addr_2 == 0)? 32'b0 : reg_array[reg_read_addr_2];  
endmodule
