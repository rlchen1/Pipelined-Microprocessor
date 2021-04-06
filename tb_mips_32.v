`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/17/2020 11:41:22 AM
// Design Name: 
// Module Name: tb_mips_32
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


module tb_mips_32;
      reg clk;  
      reg reset;  
      // Outputs  

      wire [31:0] result;
      //wire data_memory;
      // Instantiate the Unit Under Test (UUT)  
      mips_32 uut (  
           .clk(clk),   
        //   .data_mem(data_memory),
           .reset(reset),     
           .result(result)    
      );  
      
      real points = 0;
      

      initial begin  
           clk = 0;  
           forever #10 clk = ~clk;  
      end  
      initial begin  
           // Initialize Inputs  
 
           reset = 1;  
           // Wait 100 ns for global reset to finish  
           #100;  
           reset = 0;  
           // store some data in data memory
           uut.data_memory_unit.ram[0]= 32'b00000000000000000000000000000001;// 00000001
           uut.data_memory_unit.ram[1]= 32'b00001111110101110110111000010000;// 0fd76e10 
           uut.data_memory_unit.ram[2]= 32'b01011010000000000100001010011011;// 5a00429b 
           uut.data_memory_unit.ram[3]= 32'b00010100001100110011111111111100;// 14333ffc 
           uut.data_memory_unit.ram[4]= 32'b00110010000111111110110111001011;// 321fedcb 
           uut.data_memory_unit.ram[5]= 32'b10000000000000000000000000000000;// 80000000 
           uut.data_memory_unit.ram[6]= 32'b10010000000100101111110101100101;// 9012fd65
           uut.data_memory_unit.ram[7]= 32'b10101011110000000000001000110111;// abc00237
           uut.data_memory_unit.ram[8]= 32'b10110101010010111100000000110001;// b54bc031
           uut.data_memory_unit.ram[9]= 32'b11000001100001111010011000000110;// c187a606 
          
          #1500; 

          
          if(uut.data_memory_unit.ram[11]==32'h0fd76e00) $display("NO DEPENDENCY ANDI 	success!\n"); else $display("NO DEPENDENCY ANDI 	failed!\n");
          if(uut.data_memory_unit.ram[12]==32'hf02891ee) $display("NO DEPENDENCY NOR  	success!\n"); else $display("NO DEPENDENCY NOR  	failed!\n");
          if(uut.data_memory_unit.ram[13]==32'h00000001) $display("NO DEPENDENCY SLT  	success!\n"); else $display("NO DEPENDENCY SLT  	failed!\n");
          if(uut.data_memory_unit.ram[14]==32'h7ebb7080) $display("NO DEPENDENCY SLL  	success!\n"); else $display("NO DEPENDENCY SLL  	failed!\n");
          if(uut.data_memory_unit.ram[15]==32'h00000000) $display("NO DEPENDENCY SRL  	success!\n"); else $display("NO DEPENDENCY SRL  	failed!\n");
          if(uut.data_memory_unit.ram[16]==32'hfe000000) $display("NO DEPENDENCY SRA  	success!\n"); else $display("NO DEPENDENCY SRA  	failed!\n");
          if(uut.data_memory_unit.ram[17]==32'h00000000) $display("NO DEPENDENCY XOR  	success!\n"); else $display("NO DEPENDENCY XOR  	failed!\n");
          if(uut.data_memory_unit.ram[18]==32'h0fd76e10) $display("NO DEPENDENCY MULT 	success!\n"); else $display("NO DEPENDENCY MULT 	failed!\n");
          if(uut.data_memory_unit.ram[19]==32'h0fd76e10) $display("NO DEPENDENCY DIV  	success!\n"); else $display("NO DEPENDENCY DIV  	failed!\n");
          
          if(uut.data_memory_unit.ram[20]==32'h00000d61) $display("ANDI No Forwarding       success!\n"); else $display("ANDI No Forwarding     failed!\n");
          if(uut.data_memory_unit.ram[21]==32'hf028908e) $display("Forward EX/MEM to EX B   success!\n"); else $display("Forward EX/MEM to EX B failed!\n");
          if(uut.data_memory_unit.ram[22]==32'h00000001) $display("Forward MEM/WB to EX A	success!\n"); else $display("Forward MEM/WB to EX A	failed!\n");
          if(uut.data_memory_unit.ram[23]==32'h5faca000) $display("SLL  No Forwarding		success!\n"); else $display("SLL  No Forwarding		failed!\n");
          if(uut.data_memory_unit.ram[24]==32'h00bf5940) $display("Forward EX/MEM to EX A	success!\n"); else $display("Forward EX/MEM to EX A	failed!\n");
          if(uut.data_memory_unit.ram[25]==32'h17eb2800) $display("Forward MEM/WB to EX A	success!\n"); else $display("Forward MEM/WB to EX A	failed!\n");
          if(uut.data_memory_unit.ram[26]==32'h9fc59375) $display("XOR  No Forwarding		success!\n"); else $display("XOR  No Forwarding		failed!\n");
          if(uut.data_memory_unit.ram[27]==32'he4e43c50) $display("MULT No Forwarding		success!\n"); else $display("MULT No Forwarding		failed!\n");
          if(uut.data_memory_unit.ram[28]==32'h00000000) $display("Forward MEM/WB to EX B	success!\n"); else $display("Forward MEM/WB to EX B	failed!\n");
          
          // Data Hazard is the result of dependency between LW instruction's destination register and one of the next instruction's source register
          // we need to insert a NOP. This means that pc shouldnt change for one clk cycle. check your waveform to make sure your pc doesnt change 
          if(uut.data_memory_unit.ram[29]==32'hd15f1416) $display("DATA HAZARD RS DEPENDENCY    success!\n"); else $display("DATA HAZARD RS DEPENDENCY  failed!\n");
          if(uut.data_memory_unit.ram[30]==32'hb54bc032) $display("DATA HAZARD RT DEPENDENCY	success!\n"); else $display("DATA HAZARD RT DEPENDENCY	failed!\n");
          
          // Control Hazard
          if(uut.data_memory_unit.ram[31]==32'hc187a606) $display("CONTROL HAZARD BRANCH	success!\n"); else $display("CONTROL HAZARD BRANCH	failed!\n");
          if(uut.data_memory_unit.ram[32]==32'hb54bc031) $display("CONTROL HAZARD JUMP	success!\n"); else $display("CONTROL HAZARD JUMP	failed!\n");
         
           
      end  
endmodule



//`timescale 1ns / 1ps


//module tb_mips_32;
//reg clk;  
//      reg reset;  
//      // Outputs  

//      wire [31:0] result;
//      // Instantiate the Unit Under Test (UUT)  
//      mips_32 uut (  
//           .clk(clk),   
//           .reset(reset),     
//           .result(result)  
//      );  
//      initial begin  
//           clk = 0;  
//           forever #10 clk = ~clk;  
//      end  
//      initial begin  
//           // Initialize Inputs  
//           reset = 1;  
//           // Wait 100 ns for global reset to finish  
//           #100;  
//     reset = 0;  
//           // Add stimulus here  
//      end  
//endmodule
