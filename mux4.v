`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/24/2020 07:29:54 PM
// Design Name: 
// Module Name: mux4
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


 module mux4 #(parameter mux_width= 32)
  (   input [mux_width-1:0] a,b,c,d,
      input [1:0] sel,
      output reg [mux_width-1:0] y
  );
      always@(*)
      begin
        case(sel)
            2'b11: y = d;
            2'b10: y = c;
            2'b01: y = b;
            2'b00: y = a;
        endcase
      end
 endmodule